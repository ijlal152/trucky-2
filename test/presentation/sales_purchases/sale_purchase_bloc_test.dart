import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/sales_purchases/sale_purchase_persistence.dart';

/// Flushes the bloc's microtask queue so synchronous handlers complete.
Future<void> pumpEventQueue() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SalePurchaseBloc', () {
    late SalePurchaseBloc bloc;

    setUp(() {
      bloc = SalePurchaseBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state starts as a client sale', () {
      final state = bloc.state;
      expect(state.entityType, EntityType.client);
      expect(state.transactionType, TransactionType.sale);
      expect(state.operationType, OperationType.add);
      expect(state.selectedProdList, isEmpty);
    });

    group('InitSalePurchaseEvent', () {
      test('resets the flow for the given entity type', () async {
        bloc.add(const InitSalePurchaseEvent(entityType: EntityType.supplier));
        await pumpEventQueue();

        expect(bloc.state.entityType, EntityType.supplier);
        expect(bloc.state.selectedClientSupp, isNull);
        expect(bloc.state.selectedProdList, isEmpty);
      });

      test('clears any previous selection and discount', () async {
        bloc.add(const InitSalePurchaseEvent());
        await pumpEventQueue();
        bloc.add(SetDiscountEvent(cash: 50, percentage: 10));
        await pumpEventQueue();
        expect(bloc.state.discountCash, 50);

        bloc.add(const InitSalePurchaseEvent());
        await pumpEventQueue();

        expect(bloc.state.discountCash, 0);
        expect(bloc.state.discountPercentage, 0);
        expect(bloc.state.selectedTxn, isNull);
      });
    });

    group('ChooseClientSuppEvent', () {
      test('stores the selected entity', () async {
        final entity = _clientEntity();
        bloc.add(ChooseClientSuppEvent(entity: entity));
        await pumpEventQueue();

        expect(bloc.state.selectedClientSupp?.id, entity.id);
      });
    });

    group('ToggleProductEvent', () {
      test('adds a product priced for a client', () async {
        bloc.add(const InitSalePurchaseEvent(entityType: EntityType.client));
        await pumpEventQueue();

        final product = _product(sellingPrice: 99.9, purchasePrice: 80);
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();

        expect(bloc.state.selectedProdList.length, 1);
        expect(bloc.state.selectedProdList.first.unitPrice, 99.9);
        expect(bloc.state.subtotal, closeTo(99.9, 0.001));
      });

      test('prices a product for a supplier at purchase price', () async {
        bloc.add(const InitSalePurchaseEvent(entityType: EntityType.supplier));
        await pumpEventQueue();

        final product = _product(sellingPrice: 99.9, purchasePrice: 80);
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();

        expect(bloc.state.selectedProdList.first.unitPrice, 80);
      });

      test('toggling again removes the product', () async {
        final product = _product(sellingPrice: 10);
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();

        expect(bloc.state.selectedProdList, isEmpty);
      });

      test('ignores out-of-stock products', () async {
        final product = _product(sellingPrice: 10).copyWith(availableStock: 0);
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();

        expect(bloc.state.selectedProdList, isEmpty);
      });
    });

    group('Cart item editing', () {
      test('SetEditingItemEvent tracks the item being edited', () async {
        final product = _product(sellingPrice: 10);
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();

        final item = bloc.state.selectedProdList.first;
        bloc.add(SetEditingItemEvent(item));
        await pumpEventQueue();

        expect(bloc.state.editingItem?.product.id, product.id);
      });

      test('SetCartItemDataEvent applies quantity and price', () async {
        final product = _product(id: '7', sellingPrice: 10);
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();

        bloc.add(
          SetCartItemDataEvent(
            productId: '7',
            quantity: 3,
            unitPrice: 12,
            quantityPerPackage: '6',
          ),
        );
        await pumpEventQueue();

        final item = bloc.state.selectedProdList.first;
        expect(item.quantity, 3);
        expect(item.unitPrice, 12);
        expect(item.quantityPerPackage, '6');
        expect(bloc.state.editingItem, isNull);
      });
    });

    group('Discount', () {
      test('SetDiscountEvent combines cash and percentage', () async {
        final product = _product(sellingPrice: 100);
        bloc.add(ToggleProductEvent(product: product));
        await pumpEventQueue();

        bloc.add(SetDiscountEvent(cash: 10, percentage: 10));
        await pumpEventQueue();

        // 100 subtotal - (10 cash + 10% = 10) = 80.
        expect(bloc.state.discountAmount, closeTo(20.0, 0.001));
        expect(bloc.state.totalAfterDiscount, closeTo(80.0, 0.001));
      });

      test('ClearDiscountEvent resets both discount fields', () async {
        bloc.add(SetDiscountEvent(cash: 10, percentage: 5));
        await pumpEventQueue();
        bloc.add(const ClearDiscountEvent());
        await pumpEventQueue();

        expect(bloc.state.discountCash, 0);
        expect(bloc.state.discountPercentage, 0);
      });
    });

    group('RemoveCartItemEvent', () {
      test('removes only the given product', () async {
        bloc.add(
          ToggleProductEvent(product: _product(id: '1', sellingPrice: 10)),
        );
        bloc.add(
          ToggleProductEvent(product: _product(id: '2', sellingPrice: 20)),
        );
        await pumpEventQueue();

        bloc.add(const RemoveCartItemEvent(productId: '1'));
        await pumpEventQueue();

        expect(bloc.state.selectedProdList.length, 1);
        expect(bloc.state.selectedProdList.first.product.id, 2);
      });
    });

    group('ResetSalePurchaseDataEvent', () {
      test('clears cart, selection and discount', () async {
        bloc.add(ChooseClientSuppEvent(entity: _clientEntity()));
        bloc.add(ToggleProductEvent(product: _product(sellingPrice: 10)));
        bloc.add(SetDiscountEvent(cash: 5, percentage: 0));
        await pumpEventQueue();

        bloc.add(const ResetSalePurchaseDataEvent());
        await pumpEventQueue();

        final state = bloc.state;
        expect(state.selectedClientSupp, isNull);
        expect(state.selectedProdList, isEmpty);
        expect(state.discountCash, 0);
        expect(state.operationType, OperationType.add);
      });
    });

    group('Edit events', () {
      test('BeginEditCartEvent restores items and discount', () async {
        final txn = _txn(paymentType: 'Sale', discountAmount: '15');
        final client = _clientEntity();

        bloc.add(
          BeginEditCartEvent(
            txn: txn,
            clientSupp: client,
            items: [CartItem(product: _product(sellingPrice: 10), quantity: 2)],
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.operationType, OperationType.edit);
        expect(bloc.state.selectedTxn?.transactionId, txn.transactionId);
        expect(bloc.state.selectedClientSupp?.id, client.id);
        expect(bloc.state.selectedProdList.length, 1);
        expect(bloc.state.discountCash, 15);
      });

      test('BeginEditPaymentEvent clears cart items', () async {
        final txn = _txn(paymentType: 'Payment');
        bloc.add(BeginEditPaymentEvent(txn: txn, clientSupp: _clientEntity()));
        await pumpEventQueue();

        expect(bloc.state.operationType, OperationType.edit);
        expect(bloc.state.selectedProdList, isEmpty);
      });
    });
  });

  group('PaymentDataModel', () {
    test('paymentTypeString reflects entity role', () {
      final client = _clientEntity();
      final supplier = _clientEntity(role: 'supplier');

      expect(
        PaymentDataModel(
          paymentType: PaymentTransactionType.salePayment,
          clientSupplier: client,
        ).paymentTypeString,
        'Sale',
      );
      expect(
        PaymentDataModel(
          paymentType: PaymentTransactionType.salePayment,
          clientSupplier: supplier,
        ).paymentTypeString,
        'Purchase',
      );
      expect(
        const PaymentDataModel(
          paymentType: PaymentTransactionType.directPayment,
          clientSupplier: null,
        ).paymentTypeString,
        'Payment',
      );
      expect(
        const PaymentDataModel(
          paymentType: PaymentTransactionType.refund,
          clientSupplier: null,
        ).paymentTypeString,
        'Refund',
      );
      expect(
        const PaymentDataModel(
          paymentType: PaymentTransactionType.returnPayment,
          clientSupplier: null,
        ).paymentTypeString,
        'Return',
      );
    });

    test('newBalance applies sale/payment/refund rules', () {
      final sale = PaymentDataModel(
        paymentType: PaymentTransactionType.salePayment,
        clientSupplier: _clientEntity(),
        oldBalance: 1000,
        currentOrderAmount: 200,
        paymentAmount: 50,
      );
      // 1000 + 200 - 50 = 1150
      expect(sale.newBalance, closeTo(1150.0, 0.001));

      final payment = const PaymentDataModel(
        paymentType: PaymentTransactionType.directPayment,
        clientSupplier: null,
        oldBalance: 1000,
        paymentAmount: 300,
      );
      expect(payment.newBalance, closeTo(700.0, 0.001));

      final refund = const PaymentDataModel(
        paymentType: PaymentTransactionType.refund,
        clientSupplier: null,
        oldBalance: 1000,
        paymentAmount: 200,
      );
      expect(refund.newBalance, closeTo(1200.0, 0.001));

      final returnTxn = PaymentDataModel(
        paymentType: PaymentTransactionType.returnPayment,
        clientSupplier: _clientEntity(),
        oldBalance: 1000,
        currentOrderAmount: 300,
        paymentAmount: 300,
      );
      // 1000 - 300 - 300 = 400
      expect(returnTxn.newBalance, closeTo(400.0, 0.001));
    });
  });

  group('SalePurchasePersistence', () {
    late ClientSuppBloc clientSuppBloc;
    late ProductBloc productBloc;
    late Widget app;

    setUp(() {
      clientSuppBloc = ClientSuppBloc();
      productBloc = ProductBloc();
      app = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: clientSuppBloc),
          BlocProvider.value(value: productBloc),
        ],
        child: const MaterialApp(home: Scaffold(body: SizedBox())),
      );
    });

    tearDown(() {
      clientSuppBloc.close();
      productBloc.close();
    });

    Future<void> pumpContext(WidgetTester tester) async {
      await tester.pumpWidget(app);
    }

    testWidgets('direct payment writes a single transaction', (tester) async {
      await pumpContext(tester);
      final data = PaymentDataModel.directPayment(
        clientSupplier: _clientEntity(),
        oldBalance: 1000,
      ).copyWith(paymentAmount: 300, notes: 'paid');

      SalePurchasePersistence.addTransaction(
        tester.element(find.byType(SizedBox)),
        data,
      );
      await tester.pump();

      final txns = clientSuppBloc.state.allTransactions;
      expect(txns.length, 1);
      expect(txns.first.paymentType, 'Payment');
      expect(txns.first.amount, '300.00');
      expect(txns.first.note, 'paid');
    });

    testWidgets('sale writes the main txn, settlement and product details', (
      tester,
    ) async {
      await pumpContext(tester);
      final client = _clientEntity();
      final product = _product(id: '5', sellingPrice: 100);
      final data = PaymentDataModel.fromTransaction(
        clientSupplier: client,
        oldBalance: 1000,
        totalAmount: 100,
        transactionType: TransactionType.sale,
        products: [CartItem(product: product, quantity: 1, unitPrice: 100)],
      ).copyWith(paymentAmount: 40);

      SalePurchasePersistence.addTransaction(
        tester.element(find.byType(SizedBox)),
        data,
      );
      await tester.pump();

      final txns = clientSuppBloc.state.allTransactions
          .where((t) => t.clientSuppId == client.id)
          .toList();
      expect(txns.length, 2);

      final main = txns.firstWhere((t) => t.paymentType == 'Sale');
      expect(main.amount, '100.00');
      expect(main.discountAmount, '0.00');
      expect(main.products.length, 1);
      expect(main.products.first.productId, 5);

      final settlement = txns.firstWhere((t) => t.paymentType == 'Payment');
      expect(settlement.amount, '40.00');
      expect(settlement.transactionId, main.transactionId);

      final details = productBloc.state.productDetailsList
          .where((d) => d.transactionId == main.transactionId)
          .toList();
      expect(details.length, 1);
      expect(details.first.paymentType, 'Sale');
    });

    testWidgets('sale reduces the product available stock', (tester) async {
      await pumpContext(tester);
      productBloc.add(const LoadProductsEvent());
      await tester.pump();

      final product = productBloc.state.products.first;
      final before = product.availableStock;
      final data = PaymentDataModel.fromTransaction(
        clientSupplier: _clientEntity(),
        oldBalance: 0,
        totalAmount: 100,
        transactionType: TransactionType.sale,
        products: [CartItem(product: product, quantity: 2, unitPrice: 100)],
      );

      SalePurchasePersistence.addTransaction(
        tester.element(find.byType(SizedBox)),
        data,
      );
      await tester.pump();

      final updated = productBloc.state.products
          .where((p) => p.id == product.id)
          .first;
      expect(updated.availableStock, before - 2);
    });

    testWidgets('return writes a Refund settlement and restores stock', (
      tester,
    ) async {
      await pumpContext(tester);
      productBloc.add(const LoadProductsEvent());
      await tester.pump();

      final product = productBloc.state.products.first;
      final before = product.availableStock;
      final data = PaymentDataModel.fromTransaction(
        clientSupplier: _clientEntity(),
        oldBalance: 500,
        totalAmount: 50,
        transactionType: TransactionType.returnTransaction,
        products: [CartItem(product: product, quantity: 1, unitPrice: 50)],
      ).copyWith(paymentAmount: 50);

      SalePurchasePersistence.addTransaction(
        tester.element(find.byType(SizedBox)),
        data,
      );
      await tester.pump();

      final txns = clientSuppBloc.state.allTransactions;
      expect(txns.where((t) => t.paymentType == 'Return').length, 1);
      expect(txns.where((t) => t.paymentType == 'Refund').length, 1);

      final updated = productBloc.state.products
          .where((p) => p.id == product.id)
          .first;
      expect(updated.availableStock, before + 1);
    });

    testWidgets('editPaymentTransaction replaces the old record', (
      tester,
    ) async {
      await pumpContext(tester);
      final client = _clientEntity();
      final oldTxn = _txn(paymentType: 'Payment', amount: '100');
      clientSuppBloc.add(AddTransactionEvent(txn: oldTxn));
      await tester.pump();

      final newData = PaymentDataModel.directPayment(
        clientSupplier: client,
        oldBalance: 900,
      ).copyWith(paymentAmount: 150, notes: 'edited');

      SalePurchasePersistence.editTransaction(
        tester.element(find.byType(SizedBox)),
        newData,
        oldTxn,
      );
      await tester.pump();

      final remaining = clientSuppBloc.state.allTransactions
          .where((t) => t.transactionId == oldTxn.transactionId)
          .toList();
      expect(remaining, isEmpty);
      expect(clientSuppBloc.state.allTransactions.length, 1);
      expect(clientSuppBloc.state.allTransactions.first.amount, '150.00');
    });
  });
}

ClientSuppEntity _clientEntity({String role = 'client'}) {
  return ClientSuppEntity(
    id: 1,
    name: 'Ahmed Benali',
    role: role,
    phoneNumber: '0551000000',
    gpsLocation: '36.71, 3.19',
    createdAt: DateTime(2024, 1, 1),
  );
}

Product _product({
  String id = '1',
  double sellingPrice = 10,
  double purchasePrice = 8,
}) {
  return Product(
    id: id,
    productName: 'Engine Oil',
    purchasePrice: purchasePrice,
    sellingPrice: sellingPrice,
    availableStock: 10,
  );
}

ClientSuppTxn _txn({
  String paymentType = 'Payment',
  String amount = '100',
  String discountAmount = '0',
}) {
  return ClientSuppTxn(
    id: 1,
    clientSuppId: 1,
    transactionId: 'txn-1',
    clientSupplierName: 'Ahmed Benali',
    role: 'client',
    txnData: DateTime(2024, 1, 2),
    amount: amount,
    paymentType: paymentType,
    discountAmount: discountAmount,
  );
}

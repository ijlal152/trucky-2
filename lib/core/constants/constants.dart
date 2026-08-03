import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/enums.dart';

/// Model for a payment type option shown in the selector.
class PaymentTypeSelectorModel {
  final String? img;
  final String paymentType;

  const PaymentTypeSelectorModel({
    this.img,
    required this.paymentType,
  });
}

/// Global constants used across features.
abstract final class Constants {
  static List<String> sortingList = [
    'Alphabetically : A to Z',
    'Alphabetically : Z to A',
    'Balance : High to low',
    'Balance : Low to high',
    'Date : New to old',
    'Date : Old to new',
  ];

  /// Human-readable label for a sort type.
  static String sortTypeLabel(SortType sortType) {
    switch (sortType) {
      case SortType.ascending:
        return 'A to Z';
      case SortType.descending:
        return 'Z to A';
      case SortType.highToLow:
        return 'High to low';
      case SortType.lowToHigh:
        return 'Low to high';
      case SortType.newestFirst:
        return 'New to old';
      case SortType.oldestFirst:
        return 'Old to new';
      case SortType.none:
        return '';
    }
  }

  /// Payment type options for clients.
  static List<PaymentTypeSelectorModel> clientPaymentTypeSelector = [
    PaymentTypeSelectorModel(
      img: AppAssets.images.checkIconBlack,
      paymentType: 'All',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.sellsIconOne,
      paymentType: 'Sales',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.paymentIconOne,
      paymentType: 'Payments',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.returnIconOne,
      paymentType: 'Return',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.refundIconOne,
      paymentType: 'Refund',
    ),
  ];

  /// Payment type options for suppliers.
  static List<PaymentTypeSelectorModel> supplierPaymentTypeSelector = [
    PaymentTypeSelectorModel(
      img: AppAssets.images.checkIconBlack,
      paymentType: 'All',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.supplierIcon,
      paymentType: 'Purchases',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.negativePaymentIcon,
      paymentType: 'Payments',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.returnIconOne,
      paymentType: 'Return',
    ),
    PaymentTypeSelectorModel(
      img: AppAssets.images.negativeRefundIcon,
      paymentType: 'Refund',
    ),
  ];
}

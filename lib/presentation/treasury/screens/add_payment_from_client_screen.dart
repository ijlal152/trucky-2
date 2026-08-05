import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_bloc.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_event.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';
import 'package:trucky/presentation/widgets/textfield_validation_error.dart';

/// Add Payment from client screen.
class AddPaymentFromClientScreen extends StatefulWidget {
  const AddPaymentFromClientScreen({super.key});

  @override
  State<AddPaymentFromClientScreen> createState() =>
      _AddPaymentFromClientScreenState();
}

class _AddPaymentFromClientScreenState extends State<AddPaymentFromClientScreen> {
  final TextEditingController clientController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    clientController.dispose();
    dateController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2050, 12),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(43, 136, 216, 1),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  void _validate() {
    final bloc = context.read<TreasuryBloc>();
    bloc.add(
      AddPaymentEvent(
        client: clientController.text,
        date: dateController.text.isEmpty
            ? DateFormat('dd/MM/yyyy').format(DateTime.now())
            : dateController.text,
        time: DateFormat('HH:mm').format(DateTime.now()),
        amount: amountController.text,
        note: noteController.text,
      ),
    );

    final isValid =
        clientController.text.trim().isNotEmpty && amountController.text.trim().isNotEmpty;
    if (isValid) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClientRequired = context.watch<TreasuryBloc>().state.isClientRequired;
    final isAmountRequired = context.watch<TreasuryBloc>().state.isAmountRequired;

    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Add Payment from client'),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'Client',
                controller: clientController,
                errorBorderColor: isClientRequired ? Colors.red : Colors.white,
              ),
              textFieldValidationError(
                requiredParameter: 'Client name is required',
                isValid: !isClientRequired,
              ),
              10.verticalSpace,
              CustomTextFormField(
                labelText: 'Date',
                controller: dateController,
                onTap: _pickDate,
                readOnly: true,
              ),
              10.verticalSpace,
              CustomTextFormField(
                labelText: 'Amount',
                controller: amountController,
                errorBorderColor: isAmountRequired ? Colors.red : Colors.white,
              ),
              textFieldValidationError(
                requiredParameter: 'Amount is required',
                isValid: !isAmountRequired,
              ),
              10.verticalSpace,
              MultiLineTextFormField(
                labelText: 'Note',
                controller: noteController,
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBarWidget(
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomElevatedButton(
              onTap: _validate,
              btnTitle: 'Validate',
            ),
          ],
        ),
      ),
    );
  }
}
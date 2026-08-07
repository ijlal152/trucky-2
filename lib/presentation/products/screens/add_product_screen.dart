import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/utils/image_utils.dart';
import 'package:trucky/core/utils/regex_utils.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/widgets/bottom_sheet_widget.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_decorated_container.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_image_picker.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';
import 'package:trucky/presentation/widgets/textfield_validation_error.dart';

class AddProductScreen extends StatefulWidget {
  static const String id = '/addProduct';

  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productSKUController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _initialQtyController = TextEditingController();
  final TextEditingController _qtyPerPackageController =
      TextEditingController();

  File? _productImage;
  bool _isProductNameRequired = false;
  bool _isPurchasePriceRequired = false;
  bool _isSellingPriceRequired = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _productSKUController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _initialQtyController.dispose();
    _qtyPerPackageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() => _productImage = File(picked.path));
    }
    if (!mounted) return;
    context.pop();
  }

  Future<void> _scanQRCode() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#2B88D8',
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );
      if (result != '-1') {
        _productSKUController.text = result;
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to scan QR code: $e');
    }
  }

  Future<void> _addProduct() async {
    setState(() {
      _isProductNameRequired = _productNameController.text.trim().isEmpty;
      _isPurchasePriceRequired = _purchasePriceController.text.trim().isEmpty;
      _isSellingPriceRequired = _sellingPriceController.text.trim().isEmpty;
    });

    if (_isProductNameRequired ||
        _isPurchasePriceRequired ||
        _isSellingPriceRequired) {
      return;
    }

    // Encode the image off the UI thread so large camera photos do not jank
    // the form while the product is being saved.
    String? productImage;
    if (_productImage != null) {
      final bytes = await _productImage!.readAsBytes();
      productImage = await compute(ImageUtils.encodeImageBytes, bytes);
    }

    if (!mounted) return;

    context.read<ProductBloc>().add(
      AddProductEvent(
        productName: _productNameController.text.trim(),
        productSKU: _productSKUController.text.trim(),
        purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0.0,
        sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0.0,
        initialQuantity: int.tryParse(_initialQtyController.text) ?? 0,
        quantityPerPackage: _qtyPerPackageController.text.trim(),
        productImage: productImage,
      ),
    );

    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Add Product'),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  bottomSheetWidget(
                    bottomSheetWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const DividerWidget(color: Color(0xFFBDC3DD)),
                        20.verticalSpace,
                        imagePickerOption(
                          img: AppAssets.images.gallery,
                          option: 'Pick image from gallery',
                          onTap: () => _pickImage(ImageSource.gallery),
                        ),
                        15.verticalSpace,
                        imagePickerOption(
                          img: AppAssets.images.camera,
                          option: 'Pick image from camera',
                          onTap: () => _pickImage(ImageSource.camera),
                        ),
                        30.verticalSpace,
                      ],
                    ),
                  );
                },
                child: DecoratedContainer(
                  borderRadius: 12.r,
                  height: 120.h,
                  width: 120.h,
                  color: Colors.transparent,
                  decorationImage: DecorationImage(
                    image: _productImage != null
                        ? FileImage(_productImage!) as ImageProvider
                        : AssetImage(AppAssets.images.addProductIcon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              20.verticalSpace,
              CustomTextFormField(
                hintText: 'Product Name',
                labelText: 'Product Name',
                controller: _productNameController,
                textInputType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9 ]*$'),
                  ),
                ],
                errorBorderColor: _isProductNameRequired
                    ? Colors.red
                    : Colors.white,
              ),
              textFieldValidationError(
                requiredParameter: 'Product name is required',
                isValid: !_isProductNameRequired,
              ),
              10.verticalSpace,
              CustomTextFormField(
                hintText: 'Product SKU',
                labelText: 'Product SKU',
                controller: _productSKUController,
                suffixIcon: GestureDetector(
                  onTap: _scanQRCode,
                  child: Image.asset(AppAssets.images.barCodeScanner, scale: 3),
                ),
              ),
              10.verticalSpace,
              Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hintText: 'Purchase Price',
                          labelText: 'Purchase Price',
                          controller: _purchasePriceController,
                          textInputType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(RegexUtils.numbersWithDecimal),
                            ),
                          ],
                          errorBorderColor: _isPurchasePriceRequired
                              ? Colors.red
                              : Colors.white,
                        ),
                        textFieldValidationError(
                          requiredParameter: 'Purchase price is required',
                          isValid: !_isPurchasePriceRequired,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hintText: 'Selling Price',
                          labelText: 'Selling Price',
                          controller: _sellingPriceController,
                          textInputType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(RegexUtils.numbersWithDecimal),
                            ),
                          ],
                          errorBorderColor: _isSellingPriceRequired
                              ? Colors.red
                              : Colors.white,
                        ),
                        textFieldValidationError(
                          requiredParameter: 'Selling price is required',
                          isValid: !_isSellingPriceRequired,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              CustomTextFormField(
                hintText: 'Initial Quantity of units',
                labelText: 'Initial Quantity of units',
                controller: _initialQtyController,
                textInputType: TextInputType.number,
              ),
              10.verticalSpace,
              CustomTextFormField(
                hintText: 'Quantity per Package',
                labelText: 'Quantity per Package',
                controller: _qtyPerPackageController,
                textInputType: TextInputType.number,
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBarWidget(
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomElevatedButton(onTap: _addProduct, btnTitle: 'Add Product'),
          ],
        ),
      ),
    );
  }
}

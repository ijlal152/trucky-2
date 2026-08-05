import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_event.dart';
import 'package:trucky/presentation/settings/bloc/settings_models.dart';
import 'package:trucky/presentation/widgets/custom_decorated_container.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Bottom sheet to pick a dial code / country. Pops with the selected
/// [CountryCodeAndCurrencyModel].
class SelectCountryCodeBottomSheet extends StatefulWidget {
  const SelectCountryCodeBottomSheet({super.key});

  @override
  State<SelectCountryCodeBottomSheet> createState() =>
      _SelectCountryCodeBottomSheetState();
}

class _SelectCountryCodeBottomSheetState
    extends State<SelectCountryCodeBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryCodeAndCurrencyModel> _countries = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = context.read<SettingsBloc>();
    if (bloc.state.allCountries.isEmpty) {
      bloc.add(const LoadCountriesEvent());
      return;
    }
    if (_countries.isEmpty) {
      _countries = bloc.state.allCountries;
    }
  }

  void _search(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _countries = q.isEmpty
          ? context.read<SettingsBloc>().state.allCountries
          : context
              .read<SettingsBloc>()
              .state
              .allCountries
              .where((c) =>
                  (c.dialCode ?? '').toLowerCase().contains(q) ||
                  (c.country?.en ?? '').toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      borderRadius: 22.r,
      color: const Color.fromRGBO(232, 235, 245, 1),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          const DividerWidget(),
          8.verticalSpace,
          CustomTextFormField(
            height: 60.h,
            hintText: 'Select by dial code or country',
            controller: _searchController,
            onChanged: _search,
          ),
          10.verticalSpace,
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                final country = _countries[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(country),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: LabelWidget(
                            text: country.dialCode ?? '',
                            fontWeight: FontWeight.w600,
                            textSize: 15.sp,
                            textColor: Colors.black,
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: LabelWidget(
                            text: country.country?.en ?? '',
                            fontWeight: FontWeight.normal,
                            textSize: 15.sp,
                            textColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
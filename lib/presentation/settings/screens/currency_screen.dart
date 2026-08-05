import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_event.dart';
import 'package:trucky/presentation/settings/bloc/settings_state.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class CurrencyScreen extends StatefulWidget {
  static const String id = '/settings/currency';

  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final TextEditingController _searchCurrencyController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadCountriesEvent());
  }

  @override
  void dispose() {
    _searchCurrencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return CustomScaffold(
          appBar: const CustomAppBar(title: 'Currency'),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  hintText: 'Search by country or currency',
                  controller: _searchCurrencyController,
                  onChanged: (value) => context
                      .read<SettingsBloc>()
                      .add(SearchCurrencyEvent(query: value)),
                ),
                10.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: LabelWidget(
                    text:
                        'Select currency is: ${state.selectedCurrency ?? 'Not Set'}',
                  ),
                ),
                30.verticalSpace,
                if (state.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.errorMessage != null)
                  Expanded(
                    child: Center(
                      child: LabelWidget(
                        text: state.errorMessage!,
                        textColor: Colors.red,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.searchedCountries.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<SettingsBloc>()
                                .add(SelectCurrencyEvent(index: index));
                            context.pop();
                          },
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
                                    text: (index + 1).toString(),
                                  ),
                                ),
                                Flexible(
                                  child: LabelWidget(
                                    text:
                                        '${state.searchedCountries[index].country?.localized}  (${state.searchedCountries[index].currency?.localized})',
                                    maxLines: 2,
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
            ).paddingSymmetric(horizontal: 20.w),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Step 1 of a sale/purchase: pick the client (or supplier).
class ChooseClientSuppPage extends StatelessWidget {
  const ChooseClientSuppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entityType = context.read<ClientSuppBloc>().state.entityType;
    final title = entityType == EntityType.client ? 'Clients' : 'Suppliers';

    return BlocBuilder<ClientSuppBloc, dynamic>(
      builder: (context, _) {
        final state = context.read<ClientSuppBloc>().state;
        final searching = state.showSearchField &&
            state.searchQuery.trim().isNotEmpty;
        final list = searching ? state.searchResults : state.currentEntityList;

        return CustomScaffold(
          appBar: CustomAppBar(
            title: title,
            titleColor: Colors.black,
            automaticallyImplyLeading: true,
            actionWidgets: [
              if (!state.showSearchField)
                GestureDetector(
                  onTap: () => context.push(RoutePaths.addClientSupp),
                  child: const Icon(Icons.add, size: 30),
                ),
              GestureDetector(
                onTap: () {
                  final willShow = !state.showSearchField;
                  context.read<ClientSuppBloc>().add(
                        ToggleSearchFieldEvent(isVisible: willShow),
                      );
                },
                child: !state.showSearchField
                    ? Image.asset(
                        AppAssets.images.searchIcon,
                        height: 24.h,
                        width: 24.w,
                      ).paddingSymmetric(horizontal: 15.w)
                    : const Icon(Icons.close).paddingSymmetric(horizontal: 15.w),
              ),
            ],
            titleWidget: state.showSearchField
                ? TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: ' Search $title',
                      border: InputBorder.none,
                    ),
                    onChanged: (query) => context
                        .read<ClientSuppBloc>()
                        .add(SearchClientSuppEvent(query: query)),
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  )
                : null,
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: list.isEmpty
                        ? Center(
                            child: LabelWidget(
                              text: entityType == EntityType.client
                                  ? 'No Client Found'
                                  : 'No Supplier Found',
                            ),
                          )
                        : BlocBuilder<SalePurchaseBloc, dynamic>(
                            builder: (context, _) {
                              final selected =
                                  context.read<SalePurchaseBloc>().state
                                      .selectedClientSupp;
                              return ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final cs = list[index];
                                  final isSelected =
                                      selected?.id == cs.id;
                                  return InkWell(
                                    onTap: () {
                                      context
                                          .read<SalePurchaseBloc>()
                                          .add(ChooseClientSuppEvent(entity: cs));
                                      context.push(RoutePaths.chooseProducts);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                        vertical: 10.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          LabelWidget(
                                            text: cs.name,
                                            textColor: Colors.black,
                                            textSize: 17.sp,
                                          ),
                                          isSelected
                                              ? Image.asset(
                                                  AppAssets.images
                                                      .checkIconGreen,
                                                  height: 12.h,
                                                ).paddingSymmetric(
                                                    horizontal: 10.w)
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: dividerWidget(),
                                ),
                              ).paddingSymmetric(vertical: 10.h);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

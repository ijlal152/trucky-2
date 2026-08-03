import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/constants.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_state.dart';
import 'package:trucky/presentation/client_supplier/widgets/sorting_bottom_sheet.dart';
import 'package:trucky/presentation/widgets/common_home_view.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_fab_controller.dart';
import 'package:trucky/presentation/widgets/custom_list_tile.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Clients / Suppliers list screen.
class ClientSuppPage extends StatefulWidget {
  const ClientSuppPage({super.key});

  @override
  State<ClientSuppPage> createState() => _ClientSuppPageState();
}

class _ClientSuppPageState extends State<ClientSuppPage>
    with SingleTickerProviderStateMixin {
  late final CustomFabController fabCont;
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    fabCont = CustomFabController(this);
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<ClientSuppBloc>();
      if (bloc.state.currentEntityList.isEmpty &&
          bloc.state.allTransactions.isEmpty) {
        bloc.add(const LoadClientSuppEvent());
      }
    });
  }

  @override
  void dispose() {
    fabCont.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ClientSuppBloc>();
    return BlocBuilder<ClientSuppBloc, ClientSuppState>(
      builder: (context, state) {
        return CommonHomeView(
          scaleAnimation: fabCont.scaleAnimation,
          pageTitle: getPageTitle(state.entityType),
          balance: state.homeBalance.toString(),
          isBalanceVisible: state.isHomeBalanceVisible,
          focusNode: searchFocusNode,
          searchController: searchController,
          onToggleBalance: () => bloc.add(
            const ToggleHomeBalanceVisibilityEvent(),
          ),
          showObsecureIcon: true,
          showSearchField: state.showSearchField,
          searchIconOnTap: () {
            if (state.showSearchField) {
              searchController.clear();
            } else {
              searchFocusNode.requestFocus();
            }
            bloc.add(
              ToggleSearchFieldEvent(isVisible: !state.showSearchField),
            );
          },
          onChanged: (value) => bloc.add(SearchClientSuppEvent(query: value)),
          sortType: Constants.sortTypeLabel(state.sortType),
          filterIconOnTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (context) => const SortingBottomSheet(),
            );
          },
          fabOnTap: () {
            searchController.clear();
            bloc.add(const ToggleSearchFieldEvent(isVisible: false));
            context.push(RoutePaths.addClientSupp);
          },
          contentWidget: getCurrentList(state).isEmpty
              ? Center(child: LabelWidget(text: notFoundMsg(state.entityType)))
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: getCurrentList(state).length,
                  cacheExtent: MediaQuery.of(context).size.height * 2,
                  padding: EdgeInsets.zero,
                  controller: fabCont.scrollController,
                  itemBuilder: (ctx, index) {
                    final clientSupp = getCurrentList(state)[index];
                    final currentBalance = ClientSuppTxn
                        .calculateCurrentBalance(
                          clientSupplierId: clientSupp.id ?? -1,
                          allTransactions: state.currentTxnList,
                        );
                    return SimpleListTile(
                      name: clientSupp.name,
                      dateOfTransaction: clientSupp.updatedAt,
                      balance: currentBalance.toString(),
                      showBalance: !state.isHomeBalanceVisible,
                      onTap: () {
                        bloc.add(SelectClientSuppEvent(index: index));
                        context.push(RoutePaths.clientSuppDashboard);
                      },
                    );
                  },
                  separatorBuilder: (ctx, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: dividerWidget(),
                  ),
                ).paddingOnly(top: 10.h),
        );
      },
    );
  }

  List<ClientSuppEntity> getCurrentList(ClientSuppState state) {
    if (state.searchQuery.trim().isNotEmpty) {
      return state.searchResults;
    }
    return state.currentEntityList;
  }

  String getPageTitle(EntityType entityType) =>
      entityType == EntityType.client ? 'Clients' : 'Suppliers';

  String notFoundMsg(EntityType entityType) =>
      entityType == EntityType.client ? 'No Client Found' : 'No Supplier Found';
}

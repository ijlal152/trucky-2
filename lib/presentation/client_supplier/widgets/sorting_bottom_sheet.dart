import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/constants.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_state.dart';
import 'package:trucky/presentation/widgets/custom_bottom_sheet.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Bottom sheet listing the available sorting options.
class SortingBottomSheet extends StatelessWidget {
  const SortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheetContent(
      child: BlocBuilder<ClientSuppBloc, ClientSuppState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelWidget(
                text: 'Sort By',
                fontWeight: FontWeight.bold,
                textSize: 18.sp,
              ).paddingOnly(bottom: 15.h, top: 10.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Constants.sortingList.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final isSelected =
                      state.sortType == getSortTypeFromIndex(index);
                  return InkWell(
                    onTap: () {
                      context.read<ClientSuppBloc>().add(
                            SortClientSuppEvent(
                              index: getSortTypeIndex(index),
                            ),
                          );
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LabelWidget(
                            text: Constants.sortingList[index],
                            textSize: 15.sp,
                            textColor: isSelected
                                ? Colors.blue
                                : Colors.black87,
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20.sp,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ).paddingOnly(bottom: 20.h),
            ],
          );
        },
      ),
    );
  }

  SortType getSortTypeFromIndex(int index) {
    switch (index) {
      case 0:
        return SortType.ascending;
      case 1:
        return SortType.descending;
      case 2:
        return SortType.highToLow;
      case 3:
        return SortType.lowToHigh;
      case 4:
        return SortType.newestFirst;
      case 5:
        return SortType.oldestFirst;
      default:
        return SortType.none;
    }
  }

  int getSortTypeIndex(int listIndex) {
    return getSortTypeFromIndex(listIndex).index;
  }
}

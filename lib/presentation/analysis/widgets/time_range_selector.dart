import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Segmented day/week/month/year/period selector with prev/next navigation.
class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
    required this.labelText,
    required this.onPrevious,
    required this.onNext,
    this.getIcon,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String labelText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final IconData Function(String option)? getIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade600),
            borderRadius: BorderRadius.circular(32.r),
          ),
          child: IntrinsicHeight(
            child: IntrinsicWidth(
              child: Row(
                children: List.generate(options.length * 2 - 1, (i) {
                  if (i.isOdd) {
                    return Container(width: 1, color: Colors.grey.shade600);
                  }
                  final index = i ~/ 2;
                  final isSelected = selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onSelect(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE6DEFA)
                              : Colors.transparent,
                          borderRadius: index == 0
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                )
                              : index == options.length - 1
                                  ? const BorderRadius.only(
                                      topRight: Radius.circular(32),
                                      bottomRight: Radius.circular(32),
                                    )
                                  : BorderRadius.zero,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check
                                    : getIcon != null
                                        ? getIcon!(options[index])
                                        : Icons.calendar_today,
                                size: 16.sp,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                options[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Color.fromRGBO(73, 69, 79, 1),
              ),
              onPressed: onPrevious,
            ),
            Text(
              labelText,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
                color: Color.fromRGBO(73, 69, 79, 1),
              ),
              onPressed: onNext,
            ),
          ],
        ),
      ],
    );
  }
}
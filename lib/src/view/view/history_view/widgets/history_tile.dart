import 'dart:developer';

import 'package:evantez/src/model/components/date_time_picker.dart';
import 'package:evantez/src/model/repository/resource/employee_repository.dart';
import 'package:evantez/src/view/core//constants/constants.dart';
import 'package:evantez/src/view/core//themes/colors.dart';
import 'package:evantez/src/view/core//themes/typography.dart';
import 'package:evantez/src/view/core//widgets/custom_rating_star.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryTile extends StatelessWidget {
  HistoryTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EmployeesController>();
    final kSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kSize.height * 0.018,
        vertical: kSize.height * 0.018,
      ),
      margin: EdgeInsets.only(bottom: kSize.height * 0.016),
      decoration: BoxDecoration(
          color: AppColors.accentDark,
          borderRadius: BorderRadius.circular(AppConstants.basePadding),
          border: Border.all(
            color: AppColors.accentColor,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EV-${controller.employeeRatingList?.id ?? 0}',
                style: AppTypography.poppinsMedium.copyWith(
                  color: AppColors.secondaryColor.withOpacity(0.4),
                  fontSize: 14,
                ),
              ),
              Text(
                apiFormat.format(
                    controller.employeeRatingList?.createdAt ?? DateTime.now()),
                style: AppTypography.poppinsMedium.copyWith(
                  color: AppColors.secondaryColor.withOpacity(0.4),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(
            height: kSize.height * 0.01,
          ),
          CustomRatingStar(
            onRating: (value) {
              log('sdfghjk$value');
            },
            ignoreGestures: false,
            initialRating: 3,
          ),
          SizedBox(
            height: kSize.height * 0.01,
          ),
          labelRow(
              label: "Venue",
              value: controller.employeeRatingList?.venue ?? 'No Data'),
          labelRow(
              label: "Category",
              value: controller.employeeRatingList?.category ?? ''),
          labelRow(
              label: "Due",
              value: '₹ ${controller.employeeRatingList?.due ?? '0.0'}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              labelRow(
                  label: "Payment",
                  value:
                      '₹ ${controller.employeeRatingList?.payment ?? '0.0'}'),
              controller.employeeRatingList?.status == null
                  ? const SizedBox()
                  : paymentStatus(
                      status: controller.employeeRatingList?.status ?? ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget paymentStatus({required String status}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.statusPending,
          borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        status,
        style: AppTypography.poppinsRegular.copyWith(
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  Widget labelRow({required String label, required String value}) {
    return RichText(
        text: TextSpan(
      text: "$label :  ",
      style: AppTypography.poppinsMedium.copyWith(
          color: AppColors.secondaryColor.withOpacity(
        0.4,
      )),
      children: [
        TextSpan(
            text: value,
            style: AppTypography.poppinsMedium.copyWith(
              color: AppColors.secondaryColor,
              fontSize: 14,
            ))
      ],
    ));
  }
}

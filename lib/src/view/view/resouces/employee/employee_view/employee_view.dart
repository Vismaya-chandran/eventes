import 'package:cached_network_image/cached_network_image.dart';
import 'package:evantez/src/model/repository/auth/auth_controller.dart';
import 'package:evantez/src/model/repository/resource/employee_repository.dart';
import 'package:evantez/src/view/core//constants/app_images.dart';
import 'package:evantez/src/view/core//constants/constants.dart';
import 'package:evantez/src/view/core//widgets/custom_toggle_btn.dart';
import 'package:evantez/src/view/core//widgets/tab_bar.dart';
import 'package:evantez/src/view/view/resouces/employee/employee_view/widgets/change_position_bottom_sheet.dart';
import 'package:evantez/src/view/view/history_view/widgets/history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/themes/typography.dart';
import '../../../../core/widgets/custom_back_btn.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../employee_list_view/widgets/emp_history_filter.dart';

class EmployeeDetailView extends StatelessWidget {
  EmployeeDetailView({super.key});

  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final EmployeesController controller =
          context.read<EmployeesController>();

      if (controller.types.isEmpty) {
        controller.employeeTypesData(token: AuthController().accesToken ?? '');
      }
    });

    return Scaffold(
      appBar: appBar(context, kSize),
      body: SizedBox(
        height: kSize.height,
        width: kSize.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppConstants.baseBorderRadius,
              AppConstants.baseBorderRadius, AppConstants.baseBorderRadius, 0),
          child: Column(
            children: [
              empProPicDetail(kSize: kSize, context: context),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Divider(
                color: AppColors.secondaryColor.withOpacity(0.3),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              CustomTabBarView(
                selectedTap: (value) {
                  //
                  selectedTab.value = value;
                },
                tabItems: const ['Basic', 'History'],
              ),
              ValueListenableBuilder<int>(
                  valueListenable: selectedTab,
                  builder: (context, value, child) {
                    return value == 0
                        ? basicInfo(context, kSize)
                        : historySection(context, kSize);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget empProPicDetail({required Size kSize, required BuildContext context}) {
    final controller = context.watch<EmployeesController>();

    return Row(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(160)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: CachedNetworkImage(
                errorWidget: (context, error, stackTrace) {
                  return SvgPicture.asset(AppImages.camera);
                },
                placeholder: (context, url) => const Placeholder(),
                fit: BoxFit.cover,
                imageUrl: controller.employeeData?.image ?? ''),
          ),
        ),
        SizedBox(
          width: kSize.width * 0.018,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.employeeData?.name ?? '',
              style: AppTypography.poppinsSemiBold.copyWith(fontSize: 24),
            ),
            Row(
              children: [
                Wrap(
                  children: List.generate(
                      controller.selectedEmpList.value.length,
                      (index) => Text(controller.selectedEmpList.value[index])),
                ),
                Text(
                  controller.selectedPosition?.value ?? '',
                  style: AppTypography.poppinsMedium.copyWith(fontSize: 14),
                ),
                SizedBox(
                  width: kSize.width * 0.01,
                ),
                IconButton(
                    onPressed: () {
                      //
                      // List<String> positions = [
                      //   "Supervisor",
                      //   "Head",
                      //   'Captain',
                      //   "Vice Captain",
                      //   "Main Boy",
                      //   'A Boy',
                      //   "B Boy"
                      // ];
                      ChangeEmpPosition(
                        parentContext: context,
                        positions: controller.types,
                      ).show();
                    },
                    icon: SvgPicture.asset(AppImages.edit,
                        height: kSize.height * 0.025,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor,
                          BlendMode.srcIn,
                        )))
              ],
            )
          ],
        )
      ],
    );
  }

  AppBar appBar(BuildContext context, Size kSize) {
    return AppBar(
      elevation: 0,
      leading: const CustomBackButton(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: Text(
        AppStrings.employeeText,
        style: AppTypography.poppinsSemiBold.copyWith(
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  Widget basicInfo(BuildContext context, Size kSize) {
    final controller = context.watch<EmployeesController>();
    final auth = context.watch<AuthController>();

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: kSize.height * 0.032,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.activeText,
                    style: AppTypography.poppinsMedium.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  CustomToggleBtn(
                    isStatus: controller.employeeData?.isActive ?? false,
                    onChanged: (value) {
                      if (value) {
                        controller.isStatus = value;

                        controller.employeeStatus(
                            token: auth.accesToken ?? '',
                            id: controller.employeeData?.id ?? 0,
                            status: true);
                      } else {
                        controller.employeeStatus(
                            token: auth.accesToken ?? '',
                            id: controller.employeeData?.id ?? 0,
                            status: false);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Text(
                AppStrings.proInfoText,
                style: AppTypography.poppinsSemiBold.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.024,
              ),
              proInfo('Age', '${controller.employeeData?.dob?.day}'),
              SizedBox(
                height: kSize.height * 0.016,
              ),
              proInfo(AppStrings.bloodGroup,
                  '${controller.employeeData?.bloodGroup}'),
              SizedBox(
                height: kSize.height * 0.024,
              ),
              proInfo(
                  AppStrings.phoneText, controller.employeeData?.phone ?? ''),
              SizedBox(
                height: kSize.height * 0.024,
              ),
              proInfo(AppStrings.homeContactText,
                  '${controller.employeeData?.homeContact}'),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Divider(
                color: AppColors.secondaryColor.withOpacity(0.3),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Text(
                AppStrings.address,
                style: AppTypography.poppinsSemiBold.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.024,
              ),
              Text(
                controller.employeeData?.address ?? "",
                maxLines: 4,
                style: AppTypography.poppinsRegular.copyWith(
                  color: AppColors.secondaryColor.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Divider(
                color: AppColors.secondaryColor.withOpacity(0.3),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Text(
                AppStrings.paymentDetailsText,
                style: AppTypography.poppinsSemiBold.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.024,
              ),
              Text(
                AppStrings.bankDetails,
                maxLines: 4,
                style: AppTypography.poppinsMedium.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.01,
              ),
              Text(
                "${controller.employeePayment?.bankName ?? ''}\n ${controller.employeePayment?.branchName ?? ''}\n${controller.employeePayment?.ifscCode ?? ''}",
                maxLines: 4,
                style: AppTypography.poppinsRegular.copyWith(
                  color: AppColors.secondaryColor.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.024,
              ),
              Text(
                AppStrings.panCardText,
                maxLines: 4,
                style: AppTypography.poppinsMedium.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.01,
              ),
              Text(
                controller.employeeData?.idProofNumber ?? '',
                maxLines: 4,
                style: AppTypography.poppinsRegular.copyWith(
                  color: AppColors.secondaryColor.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Divider(
                color: AppColors.secondaryColor.withOpacity(0.3),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Text(
                AppStrings.paymentDetailsText,
                style: AppTypography.poppinsSemiBold.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
              Text(
                AppStrings.totalEarningsText,
                maxLines: 4,
                style: AppTypography.poppinsMedium.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.01,
              ),
              Text(
                " ${controller.employeeData?.totalEarning ?? '0.0'}",
                maxLines: 4,
                style: AppTypography.poppinsRegular.copyWith(
                  color: AppColors.secondaryColor.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: kSize.height * 0.032,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget proInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.poppinsMedium,
        ),
        Text(
          value,
          style: AppTypography.poppinsMedium,
        )
      ],
    );
  }

  Widget historySection(BuildContext context, Size kSize) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(
        top: kSize.height * 0.032,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.activeText,
                style: AppTypography.poppinsMedium.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                '120',
                textAlign: TextAlign.end,
                style: AppTypography.poppinsSemiBold.copyWith(
                  fontSize: 18,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: kSize.height * 0.024,
          ),
          Divider(
            color: AppColors.secondaryColor.withOpacity(0.3),
          ),
          SizedBox(
            height: kSize.height * 0.024,
          ),
          searchField(kSize, context),
          SizedBox(
            height: kSize.height * 0.024,
          ),
          historyListing(kSize),
        ],
      ),
    ));
  }

  Widget historyListing(Size kSize) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 130),
      child: HistoryTile(),
    ));
  }

  Widget searchField(Size kSize, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: CustomTextField(
            text: '',
            hintText: AppStrings.searchText,
            suffixIcon: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: SvgPicture.asset(
                AppImages.search,
                colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        SizedBox(
          width: kSize.width * 0.032,
        ),
        SizedBox(
          width: kSize.width * 0.1,
          child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.transparent,
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              ),
              onPressed: () {
                // history filter
                EmpHistoryFilter(context).show();
              },
              child: SvgPicture.asset(
                AppImages.filter,
                colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor, BlendMode.srcIn),
              )),
        )
      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:evantez/app/router/router_constant.dart';
import 'package:evantez/src/model/repository/auth/auth_controller.dart';
import 'package:evantez/src/model/repository/resource/employee_repository.dart';
import 'package:evantez/src/view/core/widgets/custom_back_btn.dart';
import 'package:evantez/src/view/view/resouces/employee/employee_list_view/widgets/employee_filter.dart';
import 'package:evantez/src/view/view/resouces/employee/employee_list_view/widgets/employee_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/themes/typography.dart';
import '../../../../core/widgets/custom_textfield.dart';

class EmployeeListView extends StatefulWidget {
  const EmployeeListView({super.key});

  @override
  State<EmployeeListView> createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  Timer? searchOnStoppedTyping;
  String lastChanged = '';
  @override
  void dispose() {
    super.dispose();

    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EmployeesController>();
    final auth = context.watch<AuthController>();

    search(value) {
      if (lastChanged != value) {
        setState(() {
          lastChanged = value;
        });
        controller.employeeList(
          token: auth.accesToken ?? '',
          search: value,
        );
      }
    }

    onChangeHandler(value) {
      const duration = Duration(milliseconds: 800);
      if (searchOnStoppedTyping != null) {
        setState(() => searchOnStoppedTyping?.cancel());
      }
      setState(
          () => searchOnStoppedTyping = Timer(duration, () => search(value)));
    }

    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, kSize),
      body: SizedBox(
        height: kSize.height,
        width: kSize.width,
        child: Column(
          children: [
            SizedBox(
              height: kSize.height * 0.032,
            ),
            searchField(context, kSize, onChangeHandler),
            SizedBox(
              height: kSize.height * 0.028,
            ),
            employeeList(context, kSize),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, Size kSize) {
    final controller = context.watch<EmployeesController>();
    final auth = context.watch<AuthController>();
    return AppBar(
      elevation: 0,
      leading: const CustomBackButton(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: Text(
        AppStrings.employeeListText,
        style: AppTypography.poppinsSemiBold.copyWith(),
      ),
      actions: [
        IconButton(
            onPressed: () {
              //
              controller.clearFields();
              controller.employeeTypesData(token: auth.accesToken ?? '');
              controller.employeeIdList(token: auth.accesToken ?? '');
              Navigator.pushNamed(
                  context, RouterConstants.addEmployeeViewRoute);
            },
            icon: SvgPicture.asset(
              AppImages.addCircle,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ))
      ],
    );
  }

  Widget searchField(
      BuildContext context, Size kSize, Function(String?)? onchanged) {
    final controller = context.watch<EmployeesController>();

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.baseBorderRadius),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: CustomTextField(
              keyboardType: TextInputType.name,
              onChanged: onchanged,
              controller: controller.searchController,
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                ),
                onPressed: () async {
                  //
                  showModalBottomSheet(
                      backgroundColor: AppColors.accentDark,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(AppConstants.basePadding),
                              topRight: Radius.circular(
                                AppConstants.basePadding,
                              ))),
                      context: context,
                      builder: (context) {
                        return EmployeeFilter();
                      });
                  // EmployeeFilter(context).show();
                },
                child: SvgPicture.asset(
                  AppImages.filter,
                  colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor, BlendMode.srcIn),
                )),
          )
        ],
      ),
    );
  }

  Widget employeeList(BuildContext context, Size kSize) {
    final controller = context.watch<EmployeesController>();
    final auth = context.watch<AuthController>();
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () {
        return controller.employeeList(token: auth.accesToken ?? '');
      },
      child: controller.employeeLists.isEmpty
          ? const Center(child: Text('No Data Found!'))
          : ListView.builder(
              itemCount: controller.employeeLists.length,
              padding: EdgeInsets.only(
                  bottom: kSize.height * 0.08,
                  left: AppConstants.baseBorderRadius,
                  right: AppConstants.baseBorderRadius),
              itemBuilder: (context, index) {
                return InkWell(
                  highlightColor: AppColors.transparent,
                  splashColor: AppColors.transparent,
                  onTap: () async {
                    await controller.initStateOdloading(
                        token: auth.accesToken ?? '',
                        id: controller.employeeLists[index].id ?? 0);

                    Navigator.pushNamed(
                        context, RouterConstants.employeeDetailViewRoute);
                  },
                  child: EmployeeTile(
                    index: index,
                  ),
                );
              }),
    ));
  }
}

// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:evantez/app/app.dart';
import 'package:evantez/src/model/core/models/employeetype/employeetype_model.dart';
import 'package:evantez/src/providers/resources/employee_type/employee_type_viewstate.dart';
import 'package:evantez/src/serializer/employee_type_id_response.dart';
import 'package:evantez/src/serializer/models/employee_details_response.dart';
import 'package:evantez/src/serializer/models/employee_list_response.dart';
import 'package:evantez/src/serializer/models/employee_payment_details.dart';
import 'package:evantez/src/serializer/models/employee_request.dart';
import 'package:evantez/src/serializer/models/employee_types_response.dart';
import 'package:evantez/src/serializer/models/rating_history.dart';
import 'package:evantez/src/view/core/widgets/drop_down_value.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../serializer/models/employee_proof_response.dart';
import '../../components/snackbar_widget.dart';

class EmployeesController extends ChangeNotifier {
  // late IEmployeeTypeRepository employeeTypeRepo;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController codeEditingController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // EmployeeTypeViewstate() {
  //   employeeTypeRepo = Services.employeeTypeRepo;
  // }

  // int _selectedIndex = 0;
  // int get selectedIndex => _selectedIndex;
  // set selectedIndex(int val) {
  //   _selectedIndex = val;
  //   notifyListeners();
  // }

  // late EmployeeType _employeeType;
  // EmployeeType get employeeType => _employeeType;
  // set employeeType(EmployeeType val) {
  //   _employeeType = val;
  //   notifyListeners();
  // }

  // late List<EmployeeType> _employeeTypes;
  // List<EmployeeType> get employeeTypes => _employeeTypes;
  // set employeeTypes(List<EmployeeType> val) {
  //   _employeeTypes = val;
  //   notifyListeners();
  // }

  // validators
  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return "Name Required..";
    } else {
      return null;
    }
  }

  // validators
  String? codeValidator(String? value) {
    if (value!.isEmpty) {
      return "Code Required..";
    } else {
      return null;
    }
  }

  // Future save() async {
  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     if (employeeType.id != null && employeeType.id! > 0) {
  //       await employeeTypeRepo.update(employeeType);
  //     } else {
  //       await employeeTypeRepo.save(employeeType);
  //     }
  //   }
  // }

  // Future getAll() async {
  //   employeeTypes = List<EmployeeType>.empty(growable: true);
  //   try {
  //     employeeTypes = await employeeTypeRepo.getAll();
  //   } catch (e) {
  //     employeeTypes = List<EmployeeType>.empty(growable: true);
  //   }
  // }

  bool isloading = false;
  List<EmployeeListResponse> employeeLists = [];
  TextEditingController searchController = TextEditingController();
  Future<void> employeeList({required String token, String? search}) async {
    try {
      isloading = true;
      final response = await EmployeeProvider()
          .loadEmployee(token: token, search: search ?? '');
      if (response != null) {
        employeeLists = response;

        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  initStateOdloading({required String token, required int id}) async {
    await employeeDetails(token: token, id: id);
    await employeePayments(token: token, id: id);
    await employeeRating(token: token, id: id);
    notifyListeners();
  }

  //=-=-=-=-=-=-=-= Employee Details =-=-==-=-=-=-=
  DropDownValue returnListValue(int id, List<DropDownValue> listValue) {
    int index = listValue.indexWhere((e) => e.id == id);
    if (index != -1) {
      return listValue[index];
    } else {
      return DropDownValue();
    }
  }

  EmployeeDetails? employeeData;
  Future<void> employeeDetails({required String token, required int id}) async {
    try {
      isloading = true;
      selectedPosition = null;
      final response =
          await EmployeeProvider().loadEmployeeDetails(token: token, id: id);
      if (response != null) {
        employeeData = response;
        selectedPosition =
            returnListValue(employeeData?.employeeType ?? 0, types);
        // selectedPosition = types
        //     .firstWhere((element) => element.id == employeeData?.employeeType);
        await employeeTypeId(id: id, token: token);

        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  DropDownValue? selectedItem;
  void chnage(value) {
    selectedItem = value;
    log("${selectedItem?.value}");
  }

  Future<void> changePosition(DropDownValue value,
      {required int id, required String token}) async {
    selectedPosition = value;
    await employeeTypeId(id: id, token: token);
    notifyListeners();
  }

  List<EmployeesTypesList> employeeTypesList = [];
  List<DropDownValue> types = [];
  DropDownValue? selectedPosition;
  Future<void> employeeTypesData({required String token}) async {
    try {
      isloading = true;
      final response =
          await EmployeeProvider().loadEmployeesTypes(token: token);
      if (response != null) {
        employeeTypesList = response;
        types = response
            .map((e) => DropDownValue(id: e.id, value: e.name))
            .toList();

        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  final ValueNotifier<List<String>> selectedEmpList =
      ValueNotifier<List<String>>([]);

  //=-=-=-=-=-=-=-= Employee Payemnt =-=-=-=-=-=-=-=
  EmployeeBank? employeePayment;
  Future<void> employeePayments(
      {required String token, required int id}) async {
    try {
      isloading = true;
      final response =
          await EmployeeProvider().employeePayment(token: token, id: id);
      if (response != null) {
        employeePayment = response;
        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  clearFields() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    emailController.clear();
    homeContact.clear();
    selectedItem = null;
    selectedId = null;
    idNumber.clear();
    selectedImage = null;
    bloodGroupController.clear();
    notifyListeners();
  }
  //=-=-=-=-=-=-=-= Add Employee  =-=-=-=-=-=-=-=

  File? selectedImage;

  MultipartFile? imagesData;
  imageToMultipart() async {
    if (selectedImage?.path != null && selectedImage!.path.isNotEmpty) {
      imagesData = await MultipartFile.fromFile(selectedImage?.path ?? '',
          filename: selectedImage?.path.split('/').last);
      notifyListeners();
    }

    log('Images links=============${imagesData?.filename}');
  }

  Future<void> employeeAdd(
      {required String token, required BuildContext context}) async {
    try {
      isloading = true;
      final response = await EmployeeProvider().addEmployee(
          token: token,
          data: EmployeeRequest(
              name: nameController.text,
              address: addressController.text,
              phone: int.parse(phoneController.text),
              homeContact: homeContact.text,
              email: emailController.text,
              employeeType: selectedItem?.id,
              idProofType: selectedId?.id,
              idProofNumber: idNumber.text,
              currentRating: "0",
              isActive: true,
              code: 'String',
              user: 1,
              dob: date,
              image: imagesData ?? MultipartFile(const Stream.empty(), 0),
              bloodGroup: bloodGroupController.text));
      if (response != null) {
        rootScaffoldMessengerKey.currentState!.showSnackBar(
            snackBarWidget('Successfully added!', color: Colors.green));
        Navigator.pop(context);
        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  //=-=-=-=-=-=-= TextField =-=-=-=-=-=-=-=
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController homeContact = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();

  //=-=-=-=-=-= Change Employee Id =--=--=-=-=-=
  DropDownValue? selectedId;
  void changeId(value) {
    selectedId = value;
  }

  DateTime? date;
  changeDate(value) {
    date = value;
  }

//=-=-=-=-=-=-=-= Employee Id =-=-=-=-=-=-=-=
  List<EmployeeIdList> employeeId = [];
  List<DropDownValue> employeeIdLists = [];

  Future<void> employeeIdList({required String token}) async {
    try {
      isloading = true;
      final response = await EmployeeProvider().employeeId(token: token);
      if (response != null) {
        employeeId = response;
        employeeIdLists = response
            .map((e) => DropDownValue(id: e.id, value: e.name))
            .toList();
        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  //=-=-=-=-=-=-=-= Add Employee  =-=-=-=-=-=-=-=
  TextEditingController nameTypeController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController amount = TextEditingController();

  Future<void> employeeTypeAdd(
      {required String token, required BuildContext context}) async {
    try {
      isloading = true;
      final response = await EmployeeProvider().addEmployeeType(
        token: token,
        name: nameTypeController.text,
        code: codeController.text,
        amount: int.parse(amount.text),
      );
      if (response != null) {
        rootScaffoldMessengerKey.currentState!.showSnackBar(
            snackBarWidget('Successfully added!', color: Colors.green));
        Navigator.pop(context);
        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

//=-=-==-=-=-=-=-=-= Employee Types Edit =-=-=-=-=-=
  Future<void> editEmployeeType({
    required String token,
    required BuildContext context,
    required int id,
  }) async {
    try {
      isloading = true;
      final response = await EmployeeProvider().editEmployeeType(
          token: token,
          name: nameTypeController.text,
          code: codeController.text,
          amount: amount.text,
          id: id);
      if (response != null) {
        rootScaffoldMessengerKey.currentState!.showSnackBar(
            snackBarWidget('Successfully upadted!', color: Colors.green));
        Navigator.pop(context);
        notifyListeners();
      }
      isloading = false;
    } catch (e, s) {
      log('message', stackTrace: s);
      isloading = false;
    }
  }

  //=-=-=-=-=-=-= Init State Loading =-=-=-=-==-=-=-=
  bool isEdit = false;
  void initStateLoading({EmployeesTypesList? data}) {
    if (data == null) {
      nameTypeController.clear();
      codeController.clear();
      amount.clear();
      isEdit = false;
    } else {
      isEdit = true;
      nameTypeController.text = data.name ?? '';
      codeController.text = data.code ?? '';
      amount.text = data.amount ?? '';
    }
  }

//=-=-=-=-=-=-= Employee Rating List =-=-=-=-=-=-=
  EmployeeRatingHistory? employeeRatingList;
  Future<void> employeeRating({required String token, required int id}) async {
    try {
      isloading = true;
      final response =
          await EmployeeProvider().loadEmployeeHistory(token: token, id: id);
      if (response != null) {
        employeeRatingList = response;
        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

//=-=-=-=-=-=-=-=-=-= Employee Status Change =-=-=-=-=-=
  bool isValue = false;
  changeValue(v) {
    isValue = v;

    log("$isValue");
    notifyListeners();
  }

  Future<void> employeeStatus(
      {required String token, required int id, required bool status}) async {
    try {
      isloading = true;
      final response = await EmployeeProvider()
          .employeeStatus(token: token, id: id, status: status);
      if (response != null) {
        employeeData = response;
        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  bool isStatus = false;

  EmployeeTypeIdResponse? emptype;
  Future<void> employeeTypeId({required String token, required int id}) async {
    try {
      isloading = true;
      final response = await EmployeeProvider().employeeTypeId(
          token: token,
          id: id,
          amount: 0,
          name: selectedPosition?.value ?? '',
          code: 'string');
      if (response != null) {
        emptype = response;
        notifyListeners();
      }
      isloading = false;
    } catch (e) {
      log('message');
      isloading = false;
    }
  }

  //=-=-=-=-=-=-= Global Key =-=-=-=-=-=
  final GlobalKey<FormState> empKey =
      GlobalKey<FormState>(debugLabel: 'employee_key');
}

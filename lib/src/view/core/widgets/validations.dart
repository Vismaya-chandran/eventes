import 'package:evantez/src/model/components/date_time_picker.dart';
import 'package:intl/intl.dart';

String? validateIsEmpty(String value, {String? returnText}) {
  if (value.isEmpty) {
    return returnText ?? '';
  } else if (value.trim() == '') {
    return returnText ?? '';
  } else {
    return null;
  }
}

String? taxNumber15Char(String value, {String? returnText}) {
  if (value.isEmpty) {
    return returnText;
  } else if (value.trim() == '') {
    return returnText ?? '';
  } else if (value.length != 15) {
    return 'Tax number should have 15 characters';
  }
  return null;
}

String? validatePasswordLength(String value) {
  if (value.isEmpty) {
    return 'Required';
  } else if (value.trim() == '') {
    return 'Required';
  } else if (value.length < 8) {
    return 'Password must be at least 8 characters.';
  } else {
    return null;
  }
}

//validate email--------------------
String? validateEmail(String value) {
  if (value.isEmpty) {
    return '';
  } else if (value.trim() == '') {
    return '';
  } else if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return 'Provide valid Email';
  } else {
    return null;
  }
}

String? validateMobileIndia(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Required';
  } else if (value.trim() == '') {
    return 'Required';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  } else {
    return null;
  }
}

String getCurrentTime() {
  String formattedTime = DateFormat.Hms().format(DateTime.now());
  return formattedTime;
}

bool isNumericUsingRegularExpression(String string) {
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
  return numericRegex.hasMatch(string);
}

String salesFilterQueryString(
    {required int limit,
    required int offset,
    DateTime? fromDate,
    DateTime? toDate,
    int? customerId,
    String? keyword}) {
  String queryString = '?offset=$offset&limit=$limit';
  if (customerId != null) {
    queryString = '$queryString&customer=$customerId';
  }
  if (fromDate != null) {
    String formattedDate = apiFormat.format(fromDate);
    queryString = '$queryString&from_date=$formattedDate';
  }
  if (toDate != null) {
    String formattedDate = apiFormat.format(toDate);
    queryString = '$queryString&to_date=$formattedDate';
  }
  if (keyword != null) {
    queryString = '$queryString&search=$keyword';
  }
  return queryString;
}

String purchaseFilterQueryString(
    {required int limit,
    required int offset,
    DateTime? fromDate,
    DateTime? toDate,
    int? vendorId,
    String? keyword}) {
  String queryString = '?offset=$offset&limit=$limit';
  if (vendorId != null) {
    queryString = '$queryString&vendor=$vendorId';
  }
  if (fromDate != null) {
    String formattedDate = apiFormat.format(fromDate);
    queryString = '$queryString&from_date=$formattedDate';
  }
  if (toDate != null) {
    String formattedDate = apiFormat.format(toDate);
    queryString = '$queryString&to_date=$formattedDate';
  }
  if (keyword != null) {
    queryString = '$queryString&search=$keyword';
  }
  return queryString;
}

//reports filter

//get dates
DateTime todayDate = DateTime.now();
//first day of the week
DateTime findFirstDateOfTheWeek() {
  return todayDate.subtract(Duration(days: todayDate.weekday - 1));
}

//last day of the week
DateTime findLastDateOfTheWeek() {
  return todayDate
      .add(Duration(days: DateTime.daysPerWeek - todayDate.weekday));
}

//first day of the month
DateTime findFirstDateOfTheMonth() {
  return DateTime(todayDate.year, todayDate.month, 1);
}

//last day of the month
DateTime findLastDateOfTheMonth() {
  return DateTime(todayDate.year, todayDate.month + 1, 0);
}

//round of total values

double roundDecimalPlaces(double value) {
  return double.parse((value).toStringAsFixed(2));
}

import 'package:flutter/material.dart';
import 'package:scadenziario/constants.dart' as Constants;
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';

class CertificationDto {
  final Person person;
  final Certification? certification;
  final Course? course;

  CertificationDto({
    required this.person,
    required this.certification,
    required this.course,
  });

  bool get isExpired {
    if (certification == null || certification?.expirationDate == null) {
      return false;
    }

    DateTime expirationDateOnly =
        DateUtils.dateOnly(certification?.expirationDate as DateTime);
    DateTime nowDateOnly = DateUtils.dateOnly(DateTime.now());

    return nowDateOnly.compareTo(expirationDateOnly) > 0;
  }

  bool get isExpiring {
    if (certification == null || certification?.expirationDate == null) {
      return false;
    }

    DateTime expirationDateOnly =
        DateUtils.dateOnly(certification?.expirationDate as DateTime);
    DateTime nowDateOnly = DateUtils.dateOnly(DateTime.now());

    return nowDateOnly.difference(expirationDateOnly).inDays.abs() <=
        Constants.daysToExpirationWarning;
  }
}

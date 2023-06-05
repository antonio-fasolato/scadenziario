import 'package:flutter/material.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';

class CourseState extends ChangeNotifier {
  // COURSES
  Course? _course;
  final GlobalKey<FormState> _courseFormKey = GlobalKey<FormState>();
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _courseDescriptionController = TextEditingController();
  TextEditingController _courseDurationController = TextEditingController();

  // CERTIFICATIONS
  Certification? _certification;
  GlobalKey<FormState> _certificationFormKey = GlobalKey<FormState>();
  TextEditingController _certificationIssuingController =
      TextEditingController();

  bool get hasCourse => _course != null;

  Course get course => _course as Course;

  TextEditingController get courseNameController => _courseNameController;

  TextEditingController get courseDescriptionController =>
      _courseDescriptionController;

  TextEditingController get courseDurationController =>
      _courseDurationController;

  GlobalKey<FormState> get courseFormKey => _courseFormKey;

  selectCourse(Course course) {
    _course = course;
    _courseNameController = TextEditingController(text: course.name);
    _courseDescriptionController =
        TextEditingController(text: course.description);
    _courseDurationController = TextEditingController(
        text: course.duration == null ? "" : course.duration.toString());
    notifyListeners();
  }

  deselectCourse() {
    _course = null;
    _courseNameController = TextEditingController();
    _courseDescriptionController = TextEditingController();
    _courseDurationController = TextEditingController();
    notifyListeners();
  }

  Certification get certification => _certification as Certification;

  bool get hasCertification => _certification != null;

  GlobalKey<FormState> get certificationFormKey => _certificationFormKey;

  TextEditingController get certificationIssuingController =>
      _certificationIssuingController;

  selectCertification(Certification c) {
    _certification = c;
    _certificationFormKey = GlobalKey<FormState>();
    _certificationIssuingController =
        TextEditingController(text: c.expirationDate ?? "");
    notifyListeners();
  }

  deselectCertification() {
    _certification = null;
    notifyListeners();
  }

  changeCertificationIssuingDate(String date) {
    _certificationIssuingController.text = date;
    notifyListeners();
  }
}

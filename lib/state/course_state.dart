import 'package:flutter/material.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';

class CourseState extends ChangeNotifier {
  // COURSES
  Course? _course;
  final GlobalKey<FormState> _courseFormKey = GlobalKey<FormState>();
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _courseDescriptionController = TextEditingController();
  TextEditingController _courseDurationController = TextEditingController();

  // CERTIFICATIONS
  Certification? _certification;
  Person? _person;
  GlobalKey<FormState> _certificationFormKey = GlobalKey<FormState>();
  TextEditingController _certificationIssuingController =
      TextEditingController();
  TextEditingController _certificationExpirationController =
      TextEditingController();
  TextEditingController _certificationNoteController = TextEditingController();
  List<CertificationDto> _certifications = [];
  List<String> _selectedCertifications = [];

  bool get hasCourse => _course != null;

  Course get course => _course as Course;

  bool get hasPerson => _person != null;

  Person get person => _person as Person;

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

  TextEditingController get certificationExpirationController =>
      _certificationExpirationController;

  TextEditingController get certificationNoteController =>
      _certificationNoteController;

  List<CertificationDto> get certifications => _certifications;

  selectCertification(Certification c, Person person) {
    _certification = c;
    _person = person;
    _certificationFormKey = GlobalKey<FormState>();
    _certificationIssuingController =
        TextEditingController(text: c.issuingDate ?? "");
    _certificationExpirationController =
        TextEditingController(text: c.expirationDate ?? "");
    _certificationNoteController = TextEditingController(text: c.note ?? "");
    notifyListeners();
  }

  deselectCertification() {
    _certification = null;
    _person = null;
    _certificationIssuingController = TextEditingController();
    _certificationExpirationController = TextEditingController();
    _certificationNoteController = TextEditingController();
    notifyListeners();
  }

  changeCertificationIssuingDate(String date) {
    _certificationIssuingController.text = date;
    notifyListeners();
  }

  changeCertificationExpirationDate(String date) {
    _certificationExpirationController.text = date;
    notifyListeners();
  }

  setCertifications(List<CertificationDto> certificates) {
    _certifications = certificates;
    notifyListeners();
  }
}

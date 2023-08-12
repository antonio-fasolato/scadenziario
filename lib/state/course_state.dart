import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/state/with_attachments.dart';

class CourseState extends WithAttachments {
  // COURSES
  Course? _course;
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _courseDescriptionController = TextEditingController();
  TextEditingController _courseDurationController = TextEditingController();

  // CERTIFICATIONS
  Certification? _certification;
  Person? _person;
  GlobalKey<FormState> _certificationFormKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _certificationIssuingController =
      TextEditingController();
  TextEditingController _certificationExpirationController =
      TextEditingController();
  TextEditingController _certificationNoteController = TextEditingController();
  List<CertificationDto> _certifications = [];
  List<String> _checkedCertifications = [];

  bool get hasCourse => _course != null;

  Course get course => _course as Course;

  bool get hasPerson => _person != null;

  Person get person => _person as Person;

  TextEditingController get searchController => _searchController;

  TextEditingController get courseNameController => _courseNameController;

  TextEditingController get courseDescriptionController =>
      _courseDescriptionController;

  TextEditingController get courseDurationController =>
      _courseDurationController;

  selectCourse(Course course) {
    _course = course;
    _courseNameController = TextEditingController(text: course.name);
    _courseDescriptionController =
        TextEditingController(text: course.description);
    _courseDurationController = TextEditingController(
        text: course.duration == null ? "" : course.duration.toString());
    _certification = null;
    _checkedCertifications = [];
    notifyListeners();
  }

  deselectCourse() {
    _course = null;
    _courseNameController = TextEditingController();
    _courseDescriptionController = TextEditingController();
    _courseDurationController = TextEditingController();
    _certification = null;
    _checkedCertifications = [];
    notifyListeners();
  }

  Certification? get certification => _certification;

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
    _certificationIssuingController = TextEditingController(
        text: c.issuingDate != null
            ? DateFormat.yMd('it_IT').format(c.issuingDate as DateTime)
            : "");
    _certificationExpirationController = TextEditingController(
        text: c.expirationDate != null
            ? DateFormat.yMd('it_IT').format(c.expirationDate as DateTime)
            : "");
    _certificationNoteController = TextEditingController(text: c.note ?? "");
    notifyListeners();
  }

  deselectCertification() {
    _certification = null;
    _person = null;
    _certificationIssuingController = TextEditingController();
    _certificationExpirationController = TextEditingController();
    _certificationNoteController = TextEditingController();
    _checkedCertifications = [];
    notifyListeners();
  }

  changeSearchController(String q) {
    _searchController.text = q;
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

  List<String> get checkedCertifications => _checkedCertifications;

  bool isCertificationChecked(String id) => _checkedCertifications.contains(id);

  checkCertification(String id) {
    if (isCertificationChecked(id)) {
      _checkedCertifications.remove(id);
    } else {
      _checkedCertifications.add(id);
    }
    notifyListeners();
  }
}

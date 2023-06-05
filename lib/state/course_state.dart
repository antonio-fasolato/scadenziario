import 'package:flutter/material.dart';
import 'package:scadenziario/model/course.dart';

class CourseState extends ChangeNotifier {
  Course? _course;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _durationController = TextEditingController();

  bool get hasCourse => _course != null;

  Course get course => _course as Course;

  TextEditingController get nameController => _nameController;

  TextEditingController get descriptionController => _descriptionController;

  TextEditingController get durationController => _durationController;

  GlobalKey<FormState> get formKey => _formKey;

  selectCourse(Course course) {
    _course = course;
    _nameController = TextEditingController(text: course.name);
    _descriptionController = TextEditingController(text: course.description);
    _durationController = TextEditingController(
        text: course.duration == null ? "" : course.duration.toString());
    notifyListeners();
  }

  deselectCourse() {
    _course = null;
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _durationController = TextEditingController();
    notifyListeners();
  }
}

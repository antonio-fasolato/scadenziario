import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/model/person.dart';

class PersonState extends ChangeNotifier {
  Person? _selectedPerson;
  List<Duty> _duties = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _dutyController = TextEditingController();

  List<Duty> get duties => _duties;

  bool get isSelected => _selectedPerson != null;

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get nameController => _nameController;

  TextEditingController get birthDateController => _birthDateController;

  TextEditingController get mailController => _mailController;

  TextEditingController get phoneController => _phoneController;

  TextEditingController get mobileController => _mobileController;

  TextEditingController get dutyController => _dutyController;

  TextEditingController get surnameController => _surnameController;

  Person get person => _selectedPerson as Person;

  loadDuties(List<Duty> duties) {
    _duties = duties;
    notifyListeners();
  }

  selectPerson(Person p) {
    _selectedPerson = p;
    _nameController = TextEditingController(text: p.name);
    _surnameController = TextEditingController(text: p.surname);
    _birthDateController = TextEditingController(
        text: p.birthdate == null
            ? ""
            : DateFormat.yMd('it_IT').format(p.birthdate as DateTime));
    _mailController = TextEditingController(text: p.email);
    _phoneController = TextEditingController(text: p.phone);
    _mobileController = TextEditingController(text: p.mobile);
    _dutyController = TextEditingController(text: p.duty);
    notifyListeners();
  }

  deselectPerson() {
    _selectedPerson = null;
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _birthDateController = TextEditingController();
    _mailController = TextEditingController();
    _phoneController = TextEditingController();
    _mobileController = TextEditingController();
    _dutyController = TextEditingController();
    notifyListeners();
  }

  changePersonBirthdate(String date) {
    _birthDateController.text = date;
    notifyListeners();
  }

  changePersonDuty(String duty) {
    _dutyController.text = duty;
    notifyListeners();
  }
}

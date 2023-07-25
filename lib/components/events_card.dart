import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/dto/event_dto.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/course_repository.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/state/course_state.dart';

class EventsCard extends StatelessWidget {
  final EventDto _event;
  final SqliteConnection _connection;

  const EventsCard(
      {super.key,
      required EventDto event,
      required SqliteConnection connection})
      : _event = event,
        _connection = connection;

  Widget _getCardSubtitle() {
    DateTime expirationDateOnly = DateUtils.dateOnly(_event.expirationDate);
    DateTime nowDateOnly = DateUtils.dateOnly(DateTime.now());

    if (nowDateOnly.compareTo(expirationDateOnly) == 0) {
      return Text("${_event.personName} - In scadenza oggi");
    }
    if (nowDateOnly.compareTo(expirationDateOnly) > 0) {
      return Text(
          "${_event.personName} - scaduto da ${nowDateOnly.difference(expirationDateOnly).inDays} giorni");
    } else if (nowDateOnly.difference(expirationDateOnly).inDays.abs() <= 10) {
      return Text(
          "${_event.personName} - scade tra ${nowDateOnly.difference(expirationDateOnly).inDays.abs()} giorni");
    }

    return Text(_event.personName);
  }

  Color? _getCardColor() {
    DateTime expirationDateOnly = DateUtils.dateOnly(_event.expirationDate);
    DateTime nowDateOnly = DateUtils.dateOnly(DateTime.now());

    if (nowDateOnly.compareTo(expirationDateOnly) > 0) {
      return Colors.redAccent;
    } else if (nowDateOnly.difference(expirationDateOnly).inDays.abs() <= 10) {
      return Colors.yellowAccent;
    }
  }

  _goToCourse(BuildContext context) async {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    Certification? certification = await CertificationRepository(_connection)
        .getById(_event.certificationId);
    Course? course =
        await CourseRepository(_connection).getById(_event.courseId);
    Person? person =
        await PersonRepository(_connection).getById(_event.personId);
    if (certification != null && course != null && person != null) {
      state.selectCourse(course);
      state.selectCertification(certification, person);
    }

    Navigator.of(context).pushNamed("/certificates");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(_event.courseName),
        subtitle: _getCardSubtitle(),
        leading: const Icon(Icons.event),
        tileColor: _getCardColor(),
        onTap: () => _goToCourse(context),
      ),
    );
  }
}

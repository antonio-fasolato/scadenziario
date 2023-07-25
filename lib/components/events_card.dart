import 'package:flutter/material.dart';
import 'package:scadenziario/dto/event_dto.dart';

class EventsCard extends StatelessWidget {
  final EventDto _event;

  const EventsCard({super.key, required EventDto event}) : _event = event;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(_event.courseName),
        subtitle: _getCardSubtitle(),
        leading: const Icon(Icons.event),
        tileColor: _getCardColor(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scadenziario/components/events_calendar.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/dto/event_dto.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CalendarScene extends StatefulWidget {
  final SqliteConnection _connection;

  const CalendarScene({
    super.key,
    required SqliteConnection connection,
  }) : _connection = connection;

  @override
  State<CalendarScene> createState() => _CalendarSceneState();
}

class _CalendarSceneState extends State<CalendarScene> {
  List<EventDto> _events = [];

  _setEvents(List<EventDto> events) {
    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Calendario"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventsCalendar(
                connection: widget._connection,
                setEvents: _setEvents,
              ),
              Visibility(
                visible: _events.isNotEmpty,
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                  ),
                  child: Text(
                    "Eventi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _events.isNotEmpty,
                child: ListView(
                  shrinkWrap: true,
                  children: _events
                      .map(
                        (e) => ListTile(
                          title: Text(e.title),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

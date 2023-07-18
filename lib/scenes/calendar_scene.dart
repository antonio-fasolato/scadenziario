import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/dto/event_dto.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final log = Logger((_CalendarSceneState).toString());
  final DateFormat _compactDateFormat = DateFormat("yyyyMMdd");
  final DateTime _calendarDate = DateTime.now();
  LinkedHashMap<String, EventDto> _monthEvents = LinkedHashMap();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getEventsForDayMonth(_calendarDate);
  }

  _getEventsForDayMonth(DateTime day) async {
    var certifications = await CertificationRepository(widget._connection)
        .getCertificationExpiringInMonth(day);
    LinkedHashMap<String, EventDto> res = LinkedHashMap();
    for (var c in certifications) {
      res[c.expirationDate != null
          ? _compactDateFormat.format(c.expirationDate as DateTime)
          : ""] = EventDto.fromCertification(c);
    }
    setState(() {
      _monthEvents = res;
    });
  }

  List<EventDto?> _eventLoader(DateTime day) {
    List<EventDto?> res =
        _monthEvents.containsKey(_compactDateFormat.format(day))
            ? [_monthEvents[_compactDateFormat.format(day)]]
            : [];
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Calendario"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            locale: "it_IT",
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _eventLoader,
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                final text = DateFormat.E().format(day);
                if (day.weekday == DateTime.sunday ||
                    day.weekday == DateTime.saturday) {
                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
              defaultBuilder: (context, day, focusedDay) {
                final text = DateFormat.d().format(day);
                if (day.weekday == DateTime.sunday ||
                    day.weekday == DateTime.saturday) {
                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              },
              todayBuilder: (context, day, focusedDay) {
                return Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(
                      DateFormat.d().format(day),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return CircleAvatar(
                    maxRadius: 8,
                    child: Text(
                      "${events.length}",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

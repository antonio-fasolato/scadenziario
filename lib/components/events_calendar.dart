import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:scadenziario/dto/event_dto.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendar extends StatefulWidget {
  final SqliteConnection _connection;
  final Function(List<EventDto>) _setEvents;

  const EventsCalendar({
    super.key,
    required SqliteConnection connection,
    required Function(List<EventDto>) setEvents,
  })  : _connection = connection,
        _setEvents = setEvents;

  @override
  State<EventsCalendar> createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  final log = Logger((_EventsCalendarState).toString());
  final DateFormat _compactDateFormat = DateFormat("yyyyMMdd");
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _calendarDate = DateTime.now();
  LinkedHashMap<String, EventDto> _monthEvents = LinkedHashMap();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getEventsForMonth(_calendarDate);
  }

  List<EventDto?> _eventLoader(DateTime day) {
    List<EventDto?> res =
        _monthEvents.containsKey(_compactDateFormat.format(day))
            ? [_monthEvents[_compactDateFormat.format(day)]]
            : [];
    return res;
  }

  String _buildEventsTooltip(List<Object?> events) {
    String toReturn = "";

    for (var e in events) {
      if (e != null) {
        EventDto event = e as EventDto;
        toReturn += "${event.title} ";
      }
    }

    return toReturn;
  }

  _getEventsForMonth(DateTime day) async {
    var certifications = await CertificationRepository(widget._connection)
        .getCertificationsExpiringInMonth(day);
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

  _selectDay(DateTime selectedDay, DateTime focusedDay) {
    if (_monthEvents.containsKey(_compactDateFormat.format(selectedDay))) {
      widget._setEvents(
          List.from([_monthEvents[_compactDateFormat.format(selectedDay)]]));
    } else {
      widget._setEvents([]);
    }
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().add(const Duration(days: -365 * 10)).toUtc(),
      lastDay: DateTime.now().add(const Duration(days: 365 * 10)).toUtc(),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      locale: "it_IT",
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: _selectDay,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        _getEventsForMonth(focusedDay);
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
            return Tooltip(
              message: _buildEventsTooltip(events),
              child: CircleAvatar(
                maxRadius: 8,
                child: Text(
                  "${events.length <= 10 ? events.length : "+"}",
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scadenziario/components/events_calendar.dart';
import 'package:scadenziario/components/events_card.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/scadenziario_app_bar.dart';
import 'package:scadenziario/dto/event_dto.dart';

class CalendarScene extends StatefulWidget {
  const CalendarScene({
    super.key,
  });

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
      appBar: ScadenziarioAppBar("Scadenziario - Calendario"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventsCalendar(
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
                        (e) => EventsCard(event: e),
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

import 'package:flutter/material.dart';
import 'package:scadenziario/dto/NotificationDto.dart';

class AppBarTitle extends StatefulWidget {
  final String _title;

  const AppBarTitle({super.key, required String title}) : _title = title;

  @override
  State<AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  List<NotificationDto> _notifications = [];

  @override
  void initState() {
    super.initState();

    _notifications = [
      NotificationDto("Notifica di prova", DateTime.now()),
      NotificationDto("Notifica di prova", DateTime.now()),
      NotificationDto("Notifica di prova", DateTime.now()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [Text(widget._title)];
    if (_notifications.isNotEmpty) {
      children.add(const SizedBox(width: 16));
      children.add(Tooltip(
        message: "Hai ${_notifications.length} notifiche",
        child: Badge(
          label: Text("${_notifications.length}"),
          child: IconButton(
            onPressed: () => Navigator.of(context).pushNamed("/notifications"),
            color: Colors.red,
            icon: const Icon(Icons.notification_important_outlined),
          ),
        ),
      ));
    }

    return Row(children: children);
  }
}

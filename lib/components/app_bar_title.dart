import 'package:flutter/material.dart';
import 'package:scadenziario/repositories/certification_repository.dart';

class AppBarTitle extends StatefulWidget {
  final String _title;

  const AppBarTitle({super.key, required String title}) : _title = title;

  @override
  State<AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  int _notificationsCount = 0;

  @override
  void initState() {
    super.initState();

    _getNotificationsCount();
  }

  _getNotificationsCount() async {
    var c = await CertificationRepository.getNotificationsCount(DateTime.now());

    setState(() {
      _notificationsCount = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (_notificationsCount > 0) {
      children.add(const SizedBox(width: 16));
      children.add(
        Tooltip(
          message: "Hai $_notificationsCount notifiche",
          child: Badge(
            label: Text("$_notificationsCount"),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed("/notifications"),
              color: Colors.red,
              icon: const Icon(Icons.notification_important_outlined),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Text(widget._title),
        Visibility(
          visible: _notificationsCount > 0,
          child: const SizedBox(width: 16),
        ),
        Visibility(
          visible: _notificationsCount > 0,
          child: Tooltip(
            message: "Hai $_notificationsCount notifiche",
            child: Badge(
              label: Text("$_notificationsCount"),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed("/notifications"),
                color: Colors.red,
                icon: const Icon(Icons.notification_important_outlined),
              ),
            ),
          ),
        )
      ],
    );
  }
}

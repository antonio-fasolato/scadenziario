import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scadenziario/components/app_bar_title.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/dto/notification_dto.dart';
import 'package:scadenziario/repositories/certification_repository.dart';

class NotificationsScene extends StatefulWidget {
  const NotificationsScene({super.key});

  @override
  State<NotificationsScene> createState() => _NotificationsSceneState();
}

class _NotificationsSceneState extends State<NotificationsScene> {
  List<NotificationDto> _notifications = [];

  @override
  void initState() {
    super.initState();

    _loadNotifications();
  }

  _loadNotifications() async {
    var res = await CertificationRepository.getNotifications(DateTime.now());

    setState(() {
      _notifications = res;
    });
  }

  ListTile _buildTile(NotificationDto n) {
    return ListTile(
      title: Text("${n.person.surname} ${n.person.name} - ${n.course?.name}"),
      subtitle: Text(
          "Il corso ${n.course?.name} e' ${n.isExpiring ? "in scadenza" : "scaduto"} il ${DateFormat("dd-MM-yyyy").format(n.certification?.expirationDate as DateTime)} per ${n.person.surname} ${n.person.name}"),
      tileColor: n.isExpiring
          ? Colors.yellowAccent
          : n.isExpired
              ? Colors.redAccent
              : null,
      leading:
          n.isExpiring ? const Icon(Icons.warning) : const Icon(Icons.error),
      trailing: const Tooltip(
        message: "Nascondi questa notifica",
        child: Icon(Icons.disabled_visible),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: "Scadenziario - notifiche"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: _notifications.map((n) => _buildTile(n)).toList(),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

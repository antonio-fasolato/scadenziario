import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scadenziario/components/app_bar_title.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/dto/notification_dto.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/services/csv_service.dart';

class NotificationsScene extends StatefulWidget {
  const NotificationsScene({super.key});

  @override
  State<NotificationsScene> createState() => _NotificationsSceneState();
}

class _NotificationsSceneState extends State<NotificationsScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  bool _searchHiddenController = false;
  List<NotificationDto> _notifications = [];

  @override
  void initState() {
    super.initState();

    _loadNotifications();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  _loadNotifications() async {
    var res = await CertificationRepository.getNotifications(
      DateTime.now(),
      _searchController.text,
      _searchHiddenController,
    );

    setState(() {
      _notifications = res;
    });
  }

  _toCsv() async {
    List<List<dynamic>> data = [];
    data.add(NotificationDto.csvHeader);
    for (var n in _notifications) {
      data.add(n.csvArray);
    }

    await CsvService.save(CsvService.toCsv(data));
  }

  ListTile _buildTile(NotificationDto n) {
    return ListTile(
      title: Text("${n.person.surname} ${n.person.name} - ${n.course?.name}"),
      titleTextStyle: n.certification?.notificationHidden ?? false
          ? const TextStyle(color: Colors.black26)
          : const TextStyle(),
      subtitle: Text(
          "Il corso ${n.course?.name} e' ${n.isExpiring ? "in scadenza" : "scaduto"} il ${DateFormat("dd-MM-yyyy").format(n.certification?.expirationDate as DateTime)} per ${n.person.surname} ${n.person.name}"),
      subtitleTextStyle: n.certification?.notificationHidden ?? false
          ? const TextStyle(color: Colors.black26)
          : const TextStyle(),
      leading: n.isExpiring
          ? const Icon(
              Icons.warning,
              color: Colors.yellow,
            )
          : const Icon(
              Icons.error,
              color: Colors.red,
            ),
      trailing: n.certification?.notificationHidden ?? false
          ? Tooltip(
              message: "Ripristina questa notifica",
              child: IconButton(
                onPressed: () async {
                  if (n.certification != null) {
                    Certification c = n.certification as Certification;
                    c.notificationHidden = false;
                    await CertificationRepository.save(c);
                    await _loadNotifications();
                  }
                },
                icon: const Icon(Icons.visibility),
                color: Colors.black26,
              ),
            )
          : Tooltip(
              message: "Nascondi questa notifica",
              child: IconButton(
                onPressed: () async {
                  if (n.certification != null) {
                    Certification c = n.certification as Certification;
                    c.notificationHidden = true;
                    await CertificationRepository.save(c);
                    await _loadNotifications();
                  }
                },
                icon: const Icon(Icons.visibility_off),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: "Scadenziario - notifiche"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          label: const Text("Cerca"),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _loadNotifications();
                            },
                            icon: const Icon(Icons.backspace),
                          )),
                      onChanged: (value) => _loadNotifications(),
                    ),
                  ),
                  const Text("Mostra nascosti"),
                  Switch(
                    value: _searchHiddenController,
                    onChanged: (value) {
                      setState(() {
                        _searchHiddenController = value;
                      });

                      _loadNotifications();
                    },
                  ),
                  IconButton(
                    onPressed: () async => await _toCsv(),
                    icon: const Icon(Icons.save),
                    tooltip: "Salva le notifiche come csv",
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: _notifications.map((n) => _buildTile(n)).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

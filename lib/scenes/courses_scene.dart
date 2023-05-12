import 'package:flutter/material.dart';
import 'package:scadenziario/components/activity_edit.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/model/class.dart';
import 'package:scadenziario/repositories/class_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CoursesScene extends StatefulWidget {
  final SqliteConnection _connection;

  const CoursesScene({super.key, required SqliteConnection connection})
      : _connection = connection;

  @override
  State<CoursesScene> createState() => _CoursesSceneState();
}

enum SidebarType { none, newActivity, editActivity }

class _CoursesSceneState extends State<CoursesScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  SidebarType _sidebarWidgetType = SidebarType.none;
  List<Class> _activities = [];
  Class? _selectedActivity;

  @override
  void initState() {
    super.initState();
    _getAllActivities();
  }

  _getAllActivities() async {
    var res = await ClassRepository(widget._connection).getAll();
    setState(() {
      _activities = res;
    });
  }

  _activitiesSaved() {
    setState(() {
      _sidebarWidgetType = SidebarType.none;
    });
    _getAllActivities();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Corso salvato correttamente"),
      ),
    );
  }

  void _editCancelled() {
    setState(() {
      _sidebarWidgetType = SidebarType.none;
    });
  }

  Widget _sidePanelBuilder() {
    switch (_sidebarWidgetType) {
      case SidebarType.newActivity:
        {
          return Expanded(
              flex: 70,
              child: ActivityEdit(
                confirm: _activitiesSaved,
                cancel: _editCancelled,
                connection: widget._connection,
              ));
        }
      default:
        {
          return Expanded(
              flex: 70,
              child: ActivityEdit(
                confirm: _activitiesSaved,
                cancel: _editCancelled,
                connection: widget._connection,
                activity: _selectedActivity,
              ));
        }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Corsi"),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 30,
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                          label: Text("Cerca"), prefixIcon: Icon(Icons.search)),
                    )),
                ListView(
                  shrinkWrap: true,
                  children: _activities
                      .map((a) => ListTile(
                            title: Text("${a.name}"),
                            subtitle: Text("${a.description}"),
                            leading: const Icon(Icons.business_center),
                            onTap: () {
                              setState(() {
                                _selectedActivity = a;
                                _sidebarWidgetType = SidebarType.editActivity;
                              });
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Visibility(
              visible: _sidebarWidgetType != SidebarType.none,
              child: _sidePanelBuilder())
        ],
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _sidebarWidgetType = SidebarType.newActivity;
          });
        },
        tooltip: "Aggiungi Corso",
        child: const Icon(Icons.add),
      ),
    );
  }
}

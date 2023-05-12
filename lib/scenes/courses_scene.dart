import 'package:flutter/material.dart';
import 'package:scadenziario/components/course_edit.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/course_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CoursesScene extends StatefulWidget {
  final SqliteConnection _connection;

  const CoursesScene({super.key, required SqliteConnection connection})
      : _connection = connection;

  @override
  State<CoursesScene> createState() => _CoursesSceneState();
}

enum SidebarType { none, newCourse, editCourse }

class _CoursesSceneState extends State<CoursesScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  SidebarType _sidebarWidgetType = SidebarType.none;
  List<Course> _courses = [];
  Course? _selectedCourse;

  @override
  void initState() {
    super.initState();
    _getAllCourses();
  }

  _getAllCourses() async {
    var res = await CourseRepository(widget._connection).getAll();
    setState(() {
      _courses = res;
    });
  }

  _courseSaved() {
    setState(() {
      _sidebarWidgetType = SidebarType.none;
    });
    _getAllCourses();

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
      case SidebarType.newCourse:
        {
          return Expanded(
              flex: 70,
              child: CourseEdit(
                confirm: _courseSaved,
                cancel: _editCancelled,
                connection: widget._connection,
              ));
        }
      default:
        {
          return Expanded(
              flex: 70,
              child: CourseEdit(
                confirm: _courseSaved,
                cancel: _editCancelled,
                connection: widget._connection,
                course: _selectedCourse,
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
                  children: _courses
                      .map((a) => ListTile(
                            title: Text("${a.name}"),
                            subtitle: Text("${a.description}"),
                            leading: const Icon(Icons.business_center),
                            onTap: () {
                              setState(() {
                                _selectedCourse = a;
                                _sidebarWidgetType = SidebarType.editCourse;
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
            _sidebarWidgetType = SidebarType.newCourse;
          });
        },
        tooltip: "Aggiungi Corso",
        child: const Icon(Icons.add),
      ),
    );
  }
}

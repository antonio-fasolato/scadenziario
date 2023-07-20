import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/course_edit.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/course_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/state/course_state.dart';

class CoursesScene extends StatefulWidget {
  final SqliteConnection _connection;

  const CoursesScene({super.key, required SqliteConnection connection})
      : _connection = connection;

  @override
  State<CoursesScene> createState() => _CoursesSceneState();
}

class _CoursesSceneState extends State<CoursesScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _getAllCourses();
  }

  _getAllCourses() async {
    List<Course> res = [];

    if (_searchController.text.isNotEmpty) {
      res = await CourseRepository(widget._connection)
          .findByName(_searchController.text);
    } else {
      res = await CourseRepository(widget._connection).getAll();
    }
    setState(() {
      _courses = res;
    });
  }

  _courseSaved() {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    state.deselectCourse();

    _getAllCourses();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Corso salvato correttamente"),
      ),
    );
  }

  void _editCancelled() {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    state.deselectCourse();
  }

  Widget _sidePanelBuilder() {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    if (state.hasCourse) {
      return Expanded(
        flex: 70,
        child: CourseEdit(
          confirm: _courseSaved,
          cancel: _editCancelled,
          connection: widget._connection,
        ),
      );
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
                    decoration: InputDecoration(
                      label: Text("Cerca"),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _getAllCourses();
                        },
                        icon: const Icon(Icons.backspace),
                      ),
                    ),
                    onChanged: (value) => _getAllCourses(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: _courses
                        .map(
                          (course) => ListTile(
                            title: Text("${course.name}"),
                            subtitle: Text("${course.description}"),
                            leading: const Icon(Icons.business_center),
                            onTap: () {
                              setState(() {
                                CourseState state = Provider.of<CourseState>(
                                    context,
                                    listen: false);
                                state.selectCourse(course);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Consumer<CourseState>(
            builder: (context, state, child) => Visibility(
              visible: state.hasCourse,
              child: _sidePanelBuilder(),
            ),
          )
        ],
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: Consumer<CourseState>(
        builder: (context, state, child) => Visibility(
          visible: !state.hasCourse,
          child: FloatingActionButton(
            onPressed: () {
              state.selectCourse(Course.empty());
            },
            tooltip: "Aggiungi Corso",
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

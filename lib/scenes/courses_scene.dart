import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/attachment_type.dart';
import 'package:scadenziario/components/course_edit.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/course_repository.dart';
import 'package:scadenziario/services/csv_service.dart';
import 'package:scadenziario/state/course_state.dart';

class CoursesScene extends StatefulWidget {
  const CoursesScene({super.key});

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
      res = await CourseRepository.findByName(_searchController.text);
    } else {
      res = await CourseRepository.getAll();
    }
    setState(() {
      _courses = res;
    });
  }

  Future<void> _selectCourse(Course c) async {
    final state = Provider.of<CourseState>(context, listen: false);
    state.selectCourse(c);
    state
        .setAttachments(await AttachmentRepository.getAttachmentsByLinkedEntity(
      c.id as String,
      AttachmentType.course,
    ));
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
        ),
      );
    }

    return Container();
  }

  _toCsv() async {
    List<List<dynamic>> data = [];
    data.add(Course.csvHeader);
    for (var c in _courses) {
      data.add(c.csvArray);
    }

    await CsvService.save(CsvService.toCsv(data));
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
                                _getAllCourses();
                              },
                              icon: const Icon(Icons.backspace),
                            ),
                          ),
                          onChanged: (value) => _getAllCourses(),
                        ),
                      ),
                      IconButton(
                        onPressed: () async => await _toCsv(),
                        icon: const Icon(Icons.save),
                        tooltip: "Salva come csv",
                      )
                    ],
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
                            onTap: () => _selectCourse(course),
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

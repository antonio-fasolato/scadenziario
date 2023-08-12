import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/dto/person_dto.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/state/person_state.dart';

class CoursePersonsList extends StatelessWidget {
  final String? _courseId;

  const CoursePersonsList({
    super.key,
    required String? courseId,
  }) : _courseId = courseId;

  Future<List<PersonDto>> _getPersons() async {
    return _courseId == null
        ? []
        : await PersonRepository.getPersonsFromCourse(_courseId as String);
  }

  _goToPerson(BuildContext context, PersonDto p) async {
    final navigator = Navigator.of(context);

    PersonState state = Provider.of<PersonState>(context, listen: false);
    state.selectPerson(p.person);

    navigator.pushNamed("/persons");
  }

  String _getPersonSubtitle(PersonDto p) {
    if (p.certifications.isEmpty) {
      return "Nessuna certificazione";
    }

    int count = 0, expiring = 0, expired = 0;
    for (var c in p.certifications) {
      count++;
      if (c.isExpiring) {
        expiring++;
      }
      if (c.isExpired) {
        expired++;
      }
    }

    return "$count certificazioni, $expiring in scadenza, $expired scadute";
  }

  ListTile _buildTile(BuildContext context, PersonDto p) {
    return ListTile(
      title: Text("${p.surname} ${p.name}"),
      subtitle: Text(_getPersonSubtitle(p)),
      leading: IconButton(
        icon: const Icon(Icons.workspace_premium_outlined),
        onPressed: () => _goToPerson(context, p),
      ),
    );
  }

  Widget _alternativeText(String s) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          s,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_courseId == null) {
      return Container();
    }
    
    return Card(
      elevation: 4,
      child: FutureBuilder<List<PersonDto>>(
        future: _getPersons(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _alternativeText("Caricamento");
            case ConnectionState.waiting:
              return _alternativeText("Caricamento");
            default:
              if (snapshot.hasError) {
                return _alternativeText('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null && (snapshot.data?.length ?? 0) > 0) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "Persone",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemBuilder: (context, index) =>
                            _buildTile(context, snapshot.data![index]),
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  );
                }
                return _alternativeText("Nessun certificato presente");
              }
          }
        },
      ),
    );
  }
}

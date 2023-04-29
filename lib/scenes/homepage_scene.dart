import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class HomepageScene extends StatelessWidget {
  const HomepageScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Pagina inziale"),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/people");
                  },
                  iconSize: 200,
                  icon: const Icon(
                    Icons.people,
                  )),
              const Text(
                "Personale",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/calendar");
                  },
                  iconSize: 200,
                  icon: const Icon(
                    Icons.calendar_month,
                  )),
              const Text(
                "Calendario",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/activities");
                  },
                  iconSize: 200,
                  icon: const Icon(
                    Icons.business_center,
                  )),
              const Text(
                "Attività e corsi",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ],
      )),
      bottomNavigationBar: const Footer(),
    );
  }
}

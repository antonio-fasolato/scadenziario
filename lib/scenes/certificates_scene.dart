import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/state/course_state.dart';

class CertificateScene extends StatelessWidget {
  const CertificateScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CourseState>(builder: (context, state, child) => Text("Scadenziario - Certificati ${state.course.name}"),)
        ,
      ),
      body: Container(),
      bottomNavigationBar: const Footer(),
    );
  }
}

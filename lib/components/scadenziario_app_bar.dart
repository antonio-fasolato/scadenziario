import 'package:flutter/material.dart';

class ScadenziarioAppBar extends AppBar {
  ScadenziarioAppBar(title, {super.key})
      : super(
          title: Text(title),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined),
            )
          ],
        );
}

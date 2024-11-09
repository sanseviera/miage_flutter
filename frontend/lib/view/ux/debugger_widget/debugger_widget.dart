import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projet_clothes/view/ux/debugger_widget/popups/popup_user_infos.dart';


class DebuggerWidget extends StatefulWidget {
  const DebuggerWidget({super.key});

  @override
  State<DebuggerWidget> createState() => _DebuggerWidget();
}

class _DebuggerWidget extends State<DebuggerWidget> {
  // Initial position of the widget
  static double top = 10;
  static double left = 10;
  static double? _startX;
  static double? _startY;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onPanStart: (details) {
          // Save the starting position when the drag begins
          _startX = details.localPosition.dx;
          _startY = details.localPosition.dy;
        },
        onPanUpdate: (details) {
          // Update the position of the widget during drag
          setState(() {
            top = top + details.localPosition.dy - (_startY ?? 0);
            left = left + details.localPosition.dx - (_startX ?? 0);
          });

          // Update the starting positions after moving
          _startX = details.localPosition.dx;
          _startY = details.localPosition.dy;
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(170, 43, 43, 43),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const PopupUserInfos();
                    },
                  );
                },
                icon: const Icon(Icons.person, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  log("Settings clicked");
                },
                icon: const Icon(Icons.settings,
                    color: Color.fromARGB(255, 255, 162, 0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

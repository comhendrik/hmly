import 'package:flutter/material.dart';

class ChangeUserAttributesWidget extends StatefulWidget {

  const ChangeUserAttributesWidget({
    super.key
  });

  @override
  State<ChangeUserAttributesWidget> createState() => _ChangeUserAttributesWidgetState();
}

class _ChangeUserAttributesWidgetState extends State<ChangeUserAttributesWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {
          var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return AnimatedPadding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            duration: const Duration(milliseconds: 20),
            child: SafeArea(
                bottom: keyboardHeight <= 0.0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings, weight: 5.0),
                            Text(' Change Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditableTextField extends StatefulWidget {
  final String title;
  final Function(String) callback;
  final EditableTextFieldType type;
  final TextStyle style;

  const EditableTextField({
    super.key,
    required this.title,
    required this.callback,
    required this.type,
    required this.style
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();

}

class _EditableTextFieldState extends State<EditableTextField> {

  bool showTextField = false;
  final textEditionController = TextEditingController();
  String textStr = "";
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    textStr = widget.title;
    textEditionController.text = textStr;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          setState(() {
            showTextField = !showTextField;
          });
        },
        child: showTextField ?
        Container(
          width: MediaQuery. of(context). size. width / 2, // Adjust the width as per your preference
          child: TextFormField(
            controller: textEditionController,
            onEditingComplete: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  showTextField = false;
                });
                widget.callback(textStr);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorMessageNull;
              }
              switch (widget.type) {
                case EditableTextFieldType.date:
                  if (DateTime.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.validatorMessageValidFormat;
                  }
                  if (!DateTime.tryParse(value)!.isAfter(DateTime.now())) {
                    return AppLocalizations.of(context)!.validatorMessageDateFuture;
                  }
                  return null;
                case EditableTextFieldType.number:
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return AppLocalizations.of(context)!.validatorMessagePositiveNumber;
                  }
                  return null;
                case EditableTextFieldType.text:
                  return null;
              }
            },
            onTapOutside: (_) {
              setState(() {
                textStr = widget.title;
                showTextField = false;
              });
            },
            onChanged: (value) {
              textStr = value;
            },

            style: const TextStyle(fontSize: 12),
            // Adjust the font size
          ),
        )
            : Text(
            ' $textStr',
            style: widget.style
        ),
      ),
    );
  }
}

enum EditableTextFieldType {
  date,
  number,
  text
}
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskInputWidget extends StatefulWidget {
  final Function(String title, DateTime dueTom, int pointsWorth) onTaskAdded;

  const TaskInputWidget({super.key, required this.onTaskAdded});

  @override
  State<TaskInputWidget> createState() => _TaskInputWidgetState();
}

class _TaskInputWidgetState extends State<TaskInputWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dueToController;


  late TextEditingController _pointsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _dueToController = TextEditingController();
    _pointsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dueToController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _addTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final DateTime dueTo = DateTime.parse(_dueToController.text);
      final int points = int.parse(_pointsController.text);

      setState(() {
        widget.onTaskAdded(title,dueTo,points);
        Navigator.pop(context);
      });

      // Clear the input fields
      _titleController.clear();
      _dueToController.clear();
      _pointsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.title,
              prefixIcon: const Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorMessageNull;
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dueToController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.dateLabel,
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorMessageNull;
              }
              if (DateTime.tryParse(value) == null) {
                return AppLocalizations.of(context)!.validatorMessageValidFormat;
              }
              if (!DateTime.tryParse(value)!.isAfter(DateTime.now())) {
                return AppLocalizations.of(context)!.validatorMessageDateFuture;
              }
              return null;
            },
          ),
          TextFormField(
            controller: _pointsController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.pointsWorthLabel,
              prefixIcon: Icon(Icons.star),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorMessageNull;
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return AppLocalizations.of(context)!.validatorMessagePositiveNumber;
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(AppLocalizations.of(context)!.cancel)
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),

                    onPressed: () {
                      _addTask(context);

                    },
                    label: Text(AppLocalizations.of(context)!.addTask)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
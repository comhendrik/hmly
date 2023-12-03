import 'package:flutter/material.dart';

class CustomIconElevatedButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final Function() action;
  final bool expand;

  const CustomIconElevatedButton({
    super.key,
    required this.icon,
    required this.buttonText,
    required this.action,
    this.expand = false
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        minimumSize: expand ? const Size.fromHeight(40) : null,
      ),
      icon: Icon(icon, color: Colors.white,),
      label: Text(buttonText, style: const TextStyle(color: Colors.white),),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final Function()? action;
  final bool expand;

  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.action,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        minimumSize: expand ? const Size.fromHeight(40) : null,
      ),
      child: Text(buttonText, style: const TextStyle(color: Colors.white),),
    );
  }
}

import 'package:flutter/material.dart';

class CustomIconElevatedButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final Function() action;

  const CustomIconElevatedButton({
    super.key,
    required this.icon,
    required this.buttonText,
    required this.action
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: action,
      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.blueGrey)),
      icon: Icon(icon, color: Colors.white,),
      label: Text(buttonText, style: const TextStyle(color: Colors.white),),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final Function()? action;

  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.action
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(action == null ? Colors.grey : Colors.blueGrey)),
      child: Text(buttonText, style: const TextStyle(color: Colors.white),),
    );
  }
}

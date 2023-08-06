import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SControls extends StatefulWidget {
  const SControls({
    super.key
  });


  @override
  State<SControls> createState() => _SControlsState();
}

class _SControlsState extends State<SControls> {
  final _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.update),
          onPressed: () async {
            //await _storage.write(key: "Test", value: "third test");
            await _storage.delete(key: "email");
            await _storage.delete(key: "password");
           // String value = await _storage.read(key: "email") ?? "no data";
           // print(value);

          },

        )
      ],
    );
  }

}
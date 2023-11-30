import 'package:flutter/material.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hmly/core/widgets/custom_button.dart';

class BlocErrorWidget extends StatelessWidget {

  final Failure failure;
  final Function() reloadAction;

  const BlocErrorWidget({
    super.key,
    required this.failure,
    required this.reloadAction
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error, // Error icon
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              failure.type.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.errorCode(failure.data['code'].toString()),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              failure.data['message'],
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            CustomIconElevatedButton(
                icon: Icons.refresh,
                buttonText: AppLocalizations.of(context)!.reload,
                action: reloadAction
            ),
          ],
        ),
      ),
    );
  }
}


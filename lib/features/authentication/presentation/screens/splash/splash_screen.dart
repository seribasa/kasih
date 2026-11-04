import 'package:kasih/core/widgets/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final permission = Permission.notification.request();
    permission.then((status) {
      if (status.isGranted == false) {
        snackbarCustom(
          'Izinkan notifikasi untuk menerima pemberitahuan',
        ).show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/e_patient_logo.png',
              width: 120,
              semanticLabel: 'Logo Kasih',
            ),
            const SizedBox(height: 20),
            const Text('Kasih'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

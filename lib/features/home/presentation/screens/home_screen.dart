import 'package:kasih/routers/route_paths/profile_route_paths.dart';
import 'package:kasih/routers/route_paths/root_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Utama', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              isLandscape
                  ? const SizedBox()
                  : SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/e_patient_care.png',
                          fit: BoxFit.contain,
                          semanticLabel:
                              'Pasien dan keluarga mengatur kesehatan bersama',
                        ),
                      ),
                    ),
                  ),
              Expanded(
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: GridView.count(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: const EdgeInsets.all(12),
                    crossAxisCount: isLandscape ? 4 : 2,
                    children: [
                      TombolMenu(
                        icon: Icons.calendar_today,
                        onTap: () {
                          context.push(RootRoutePaths.calendar.fullPath);
                        },
                        label: 'Kalender',
                      ),
                      TombolMenu(
                        icon: Icons.people_alt_outlined,
                        onTap: () {
                          context.push(ProfileRoutePaths.children.fullPath);
                        },
                        label: 'Pasien',
                      ),
                      TombolMenu(
                        icon: Icons.medical_services_rounded,
                        onTap: () {
                          context.push(RootRoutePaths.vaccination.fullPath);
                        },
                        label: 'Vaksinasi',
                      ),
                      TombolMenu(
                        icon: Icons.my_library_books_rounded,
                        onTap: () {
                          context.push(RootRoutePaths.healthyBook.fullPath);
                        },
                        label: 'Buku Sehat',
                      ),
                      TombolMenu(
                        icon: Icons.contact_mail_rounded,
                        onTap: () {
                          context.push(RootRoutePaths.contact.fullPath);
                        },
                        label: 'Kontak',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TombolMenu extends StatelessWidget {
  final Function? onTap;
  final IconData? icon;
  final String? label;

  TombolMenu({Key? key, this.icon, this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.zero,
                ),
                child: Icon(icon, color: Colors.white, size: 50),
              ),
            ),
            SizedBox(height: 5),
            Text(
              label!,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

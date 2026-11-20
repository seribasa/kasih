import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/constant.dart';

class PesanPage extends StatefulWidget {
  @override
  _PesanPageState createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          AppConstant.MESSAGE_LABEL,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Card(
              elevation: 0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: SvgPicture.asset(
                        'assets/images/undraw_Mailbox_re_dvds.svg',
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.mark_email_unread_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        title: Text('Undangan imunisasi'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.mark_email_read_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        title: Text('Konfirmasi imunisasi di rumah'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

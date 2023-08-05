// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bottombar.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  final TextEditingController _problemController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      //sendEmail(_problemController.text);
      Navigator.of(context).pop();
    }
  }

  void sendEmail(String problem) async {
    final Email email = Email(
      subject: 'Support Request',
      body: problem,
      recipients: ['zuvec00@gmail.com'],
      attachmentPaths: []
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('error $error');
      platformResponse = error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyBottomBar())),
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text(
            'S U P P O R T',
            style: GoogleFonts.quicksand(color: Colors.grey[900]),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height:MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Expanded(
                    flex:2,child: Image.asset('lib/assets/contactSupport.png')),
                  
                  Expanded(
                    flex:3,
                      child: Column(children: [
                    Text(
                      'We\'re here to help you with any issue. Please describe your problem and we\'ll get back to you as soon as possible. Thank you for choosing our service.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 150,
                        child:
                            AccountTextField(controller: _problemController)),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        sendEmail(_problemController.text);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text('Sumbit',
                              style: TextStyle(color: Colors.grey[100]))),
                    ),
                  ]))
                  /*Image.asset(
                    'lib/assets/contactSupport.png',
                    height: 150,
                  ),*/
                ],
              ),
            ),
          ),
        ));
  }
}

class AccountTextField extends StatelessWidget {
  final TextEditingController controller;
  const AccountTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 1.5, color: Colors.grey[600]!)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(width: 1.5, color: Colors.deepPurple[600]!)),
          labelText: 'Describe your issue',
          labelStyle: GoogleFonts.quicksand(color: Colors.grey[900]),
          border: OutlineInputBorder()),
    );
  }
}

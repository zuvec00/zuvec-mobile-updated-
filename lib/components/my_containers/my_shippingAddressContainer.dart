// ignore_for_file: avoid_single_cascade_in_expression_statements, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/provider/model.dart';
import 'package:firebase_practice/routes/shippingAddress/addNewAddress_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/database_service.dart';

class MyShippingAddressContainer extends StatefulWidget {
  final int index;
  final String firstName;
  final String lastName;
  final String deliveryAddress;
  final String additionalInfo;
  final String region;
  final String city;
  final String mobilePhoneNo;
  final String additionalPhoneNo;
  final bool selected;

  MyShippingAddressContainer({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.deliveryAddress,
    required this.additionalInfo,
    required this.region,
    required this.city,
    required this.index,
    required this.mobilePhoneNo,
    required this.additionalPhoneNo,
    required this.selected,
  });

  @override
  State<MyShippingAddressContainer> createState() =>
      _MyShippingAddressContainerState();
}

int noOfTrueValues = 0;

String _getCurrentUserId() {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  String userID = currentUser.uid;
  return userID;
}

class _MyShippingAddressContainerState
    extends State<MyShippingAddressContainer> {
  @override
  Widget build(BuildContext context) {
    final DocumentReference parentDocRef = FirebaseFirestore.instance
        .collection('usersAddresses')
        .doc(_getCurrentUserId());

    final CollectionReference addressSubCollection =
        parentDocRef.collection('user_address');

    Future<void> countTrueValues() async {
      try {
        final querySnapshot = await addressSubCollection
            .where('addressSelected', isEqualTo: true)
            .get();
        setState(() {
          noOfTrueValues = querySnapshot.size;
        });
        print('tures:$noOfTrueValues');
      } catch (e) {
        print('Error counting true values: $e');
      }
    }

    bool addressSelected = widget.selected;
    final size = MediaQuery.of(context).size;
    return Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              DatabaseService(uID: _getCurrentUserId())
                  .deleteAddressItem(widget.index, addressSubCollection);
              Provider.of<Model>(context, listen: false)
                  .removeAddress(widget.index);
            },
            icon: Icons.delete_rounded,
            backgroundColor: Colors.deepPurple.shade600,
            borderRadius: BorderRadius.circular(15),
          )
        ]),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 26, color: Colors.grey[600]),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200, //make this responsive
                      child: Text(
                        widget.deliveryAddress,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(widget.region,
                            style: TextStyle(color: Colors.grey[600])),
                        Text(', ', style: TextStyle(color: Colors.grey[600])),
                        Text(widget.city,
                            style: TextStyle(color: Colors.grey[600]))
                      ],
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => AddNewAddressPage(
                              index: widget.index,
                            ))));
              },
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        await countTrueValues();
                        if (noOfTrueValues == 0) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.deepPurple[600]));
                              });
                          await DatabaseService(uID: _getCurrentUserId())
                              .updateAddressSelected(
                                  widget.index, addressSubCollection, true);
                          Navigator.pop(context);
                        } else if (noOfTrueValues == 1) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.deepPurple[600]));
                              });
                          if (!widget.selected) {
                            Navigator.pop(context);
                            Flushbar(
                              flushbarPosition: FlushbarPosition.TOP,
                              backgroundColor: Colors.red[400]!,
                              margin: const EdgeInsets.only(top: 0),
                              duration: const Duration(seconds: 2),
                              icon: const Icon(Icons.error_outline_rounded,
                                  color: Colors.white),
                              messageText: Text(
                                  "You can only choose a single shipping address.",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white)),
                            )..show(context);
                          }
                          await DatabaseService(uID: _getCurrentUserId())
                              .updateAddressSelected(
                                  widget.index, addressSubCollection, false);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: widget.selected
                                ? Colors.grey[900]
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: widget.selected ? 0.0 : 1.5,
                                color: widget.selected
                                    ? Colors.white
                                    : Colors.grey[300]!)),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Text('Edit',
                      style: TextStyle(
                          color: Colors.deepPurple[600],
                          decoration: TextDecoration.underline)),
                ],
              ),
            ),
          ]),
        ));
  }
}

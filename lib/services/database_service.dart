import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uID;

  DatabaseService({
    required this.uID,
  });

  final CollectionReference zuvecAppUsers =
      FirebaseFirestore.instance.collection('zuvecAppUsers');
  final CollectionReference emailSubscribers =
      FirebaseFirestore.instance.collection('emailSubscribers');
  final CollectionReference appRating =
      FirebaseFirestore.instance.collection('appRating');
  final CollectionReference wishlist =
      FirebaseFirestore.instance.collection('usersWishlistProducts');
  CollectionReference wishlistSubCollection =
      FirebaseFirestore.instance.collection('usersWishlistProducts');
  CollectionReference cartSubCollection =
      FirebaseFirestore.instance.collection('usersCartProducts');
  CollectionReference addressSubCollection =
      FirebaseFirestore.instance.collection('usersAddresses');
  CollectionReference orderSubCollection =
      FirebaseFirestore.instance.collection('userOrders');
  CollectionReference donationCollection =
      FirebaseFirestore.instance.collection('donations');

  Future updateUserData(String tokenID, String firstName, String lastName,
      String phoneNo, String emailID) async {
    return await zuvecAppUsers.doc(uID).set({
      'Device TokenID': tokenID,
      'First Name': firstName,
      'Last Name': lastName,
      'Phone Number': phoneNo,
      'Email ID': emailID,
    });
  }

  Future<String> getUserFirstName() async {
    String firstName = '';
    final DocumentSnapshot zuvecAppUserCollection = await FirebaseFirestore
        .instance
        .collection('zuvecAppUsers')
        .doc(uID)
        .get();

    if (zuvecAppUserCollection.exists) {
      firstName =
          (zuvecAppUserCollection.data() as Map<String, dynamic>)['First Name'];
    }
    return firstName;
  }

  Future updateUserEmailPreference(String emailID, bool isSubscribed) async {
    return await emailSubscribers
        .doc(uID)
        .set({'Email ID': emailID, 'User subscribed': isSubscribed});
  }

  Future updateRating(String feedback, double rating) async {
    return await appRating.doc(uID).set({
      'User feedback': feedback,
      'Rating value': rating,
    });
  }

  Future createUserCartCollection() async {
    final DocumentReference parentDocRef =
        FirebaseFirestore.instance.collection('usersCartProducts').doc(uID);

    String subCollectionName = 'user_cart_item';
    CollectionReference subCollectionRef =
        parentDocRef.collection(subCollectionName);
    cartSubCollection = subCollectionRef;

    addCartItem('0', '', 'productName', 0.0, '1000', 1, subCollectionRef);
  }

  Future addCartItem(
      String docID,
      String productImage,
      String productName,
      double productPrice,
      String productSize,
      int productQuantity,
      CollectionReference subCollectionRef) async {
    return await subCollectionRef.doc(docID).set({
      'Product image': productImage,
      'Product name': productName,
      'Product price': productPrice,
      'Product variant': productSize,
      'Product ID': docID,
      'Product quantity': productQuantity
    }).then((value) =>
        print("Item added successfully to subcollection:'user_wishlist_item'"));
  }

  Future incrementProductQuantity(
      CollectionReference subCollectionRef, String pID) async {
    QuerySnapshot querySnapshot = await subCollectionRef
        .where('Product ID', isEqualTo: pID)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String docID = querySnapshot.docs.first.id;

      await subCollectionRef
          .doc(docID)
          .update({'Product quantity': FieldValue.increment(1)});
    }
  }

  Future decrementProductQuantity(
      CollectionReference subCollectionRef, String pID) async {
    QuerySnapshot querySnapshot = await subCollectionRef
        .where('Product ID', isEqualTo: pID)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String docID = querySnapshot.docs.first.id;

      subCollectionRef.doc(docID).get().then((docSnapshot) async {
        int currentValue =
            (docSnapshot.data() as Map<String, dynamic>)['Product quantity'] ??
                0;
        if (currentValue > 1) {
          await subCollectionRef
              .doc(docID)
              .update({'Product quantity': FieldValue.increment(-1)});
        }
      });
    }
  }

  Future<double> getTotalPrice(CollectionReference subCollection) async {
    double totalValue = 0.0;

    QuerySnapshot querySnapshot = await subCollection.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      double price =
          (documentSnapshot.data() as Map<String, dynamic>)['Product price'] ??
              0.0;
      int quantity = (documentSnapshot.data()
              as Map<String, dynamic>)['Product quantity'] ??
          0;

      double itemValue = price * quantity;
      totalValue += itemValue;
    }
    print('cart total price: $totalValue');

    return totalValue;
  }

  Future<int> getTotalNoOfCartItems(CollectionReference subCollection) async {
    int totalCartItems = 0;

    QuerySnapshot querySnapshot = await subCollection.get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      totalCartItems++;
    }
    return totalCartItems;
  }

  Future deleteCartItem(CollectionReference subCollection, String docID) async {
    try {
      await subCollection.doc(docID).delete();
      print('item successuflly deleted');
    } catch (e) {
      print('Error deleteing data');
    }
  }

  Future<void> deleteAllCartItems(CollectionReference subCollection) async {
    final querySnapshot = await subCollection.get();

    querySnapshot.docs.forEach((doc) async {
      await doc.reference.delete();
    });
  }

  Future createUserWishlistCollection() async {
    final DocumentReference parentDocRef =
        FirebaseFirestore.instance.collection('usersWishlistProducts').doc(uID);

    String subCollectionName = 'user_wishlist_item';
    CollectionReference subCollectionRef =
        parentDocRef.collection(subCollectionName);
    wishlistSubCollection = subCollectionRef;

    addWishlistItem('0', '', 'productName', 0.0, '1000', subCollectionRef);
  }

  Future<bool> getSavedState(
      CollectionReference collectionRef, String productImageAddress) async {
    QuerySnapshot querySnapshot = await collectionRef
        .where('Product image', isEqualTo: productImageAddress)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      bool savedState = querySnapshot.docs.first['Product saved'];
      return savedState;
    } else {
      print('No snapshot available');
      return false;
    }
  }

  Future savedStateHandler(CollectionReference subCollectionRef,
      String productImageAddress, bool isProductSaved) async {
    QuerySnapshot querySnapshot = await subCollectionRef
        .where('Product image', isEqualTo: productImageAddress)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String docID = querySnapshot.docs.first.id;

      await subCollectionRef
          .doc(docID)
          .update({'Product saved': isProductSaved});
      print('Item saved state updated successfully');
    } else {
      print('No document fetched from the collection');
    }
  }

  Future<void> updateAllProductSavedStatusToFalse(
      CollectionReference collectionRef) async {
    try {
      final querySnapshot = await collectionRef.get();

      for (final docSnapshot in querySnapshot.docs) {
        final docRef = docSnapshot.reference;

        await docRef.update({
          'Product saved': false,
        });
      }
      print('All documents updated successfully.');
    } catch (error) {
      print('Error updating documents: $error');
    }
  }

  Future addWishlistItem(String docID, String productImage, String productName,
      double productPrice, String productSize,
      [CollectionReference? subCollectionRef]) async {
    return await subCollectionRef!.doc(docID).set({
      'Product image': productImage,
      'Product name': productName,
      'Product price': productPrice,
      'Product variant': productSize,
      'Product ID': docID
    }).then((value) =>
        print("Item added successfully to subcollection:'user_wishlist_item'"));
  }

  Future deleteWishlistItem(
      CollectionReference subCollection, String docID) async {
    try {
      await subCollection.doc(docID).delete();
      print('item successuflly deleted');
    } catch (e) {
      print('Error deleteing date');
    }
  }

  Future<void> deleteAllWishlistItems(CollectionReference subCollection) async {
    final querySnapshot = await subCollection.get();

    querySnapshot.docs.forEach((doc) async {
      await doc.reference.delete();
    });
  }

  Future createUserAddressCollection() async {
    final DocumentReference parentDocRef =
        FirebaseFirestore.instance.collection('usersAddresses').doc(uID);

    String subCollectionName = 'user_address';
    CollectionReference subCollectionRef =
        parentDocRef.collection(subCollectionName);

    addressSubCollection = subCollectionRef;

    addAddressItem(addressSubCollection, {}, '0');
  }

  Future addAddressItem(
      CollectionReference subCollectionRef, Map<String, dynamic> addressFields,
      [String? docID]) {
    return subCollectionRef.doc(docID).set(addressFields).then((value) => print(
        'Address Field added succesfully to the subcollection:user_address'));
  }

  Future updateAddressItem(int key, CollectionReference subCollectionRef,
      Map<String, dynamic> addressFields) async {
    QuerySnapshot querySnapshot =
        await subCollectionRef.where('key', isEqualTo: key).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      String docID = querySnapshot.docs.first.id;

      await subCollectionRef.doc(docID).update(addressFields);
    }
  }

  Future deleteAddressItem(
    int key,
    CollectionReference subCollectionRef,
  ) async {
    QuerySnapshot querySnapshot =
        await subCollectionRef.where('key', isEqualTo: key).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      String docID = querySnapshot.docs.first.id;
      await subCollectionRef.doc(docID).delete();
    }
  }

  Future updateAddressSelected(int key, CollectionReference subCollectionRef,
      bool addressSelected) async {
    QuerySnapshot querySnapshot =
        await subCollectionRef.where('key', isEqualTo: key).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      String docID = querySnapshot.docs.first.id;

      await subCollectionRef
          .doc(docID)
          .update({'addressSelected': addressSelected});
    }
  }

  Future<double> getShippingFee(CollectionReference subCollectionRef) async {
    QuerySnapshot querySnapshot = await subCollectionRef
        .where('addressSelected', isEqualTo: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      dynamic item = querySnapshot.docs.first['region'];
      if (item == 'Edo' || item == 'edo') {
        return 1000.00;
      } else {
        return 3500.00;
      }
    } else {
      print('no snapshot available');
      // Handle the case when no document with addressSelected=true is found
      return 0;
    }
  }

  Future<bool> verifyShippingAddress(
    CollectionReference subCollectionRef,
  ) async {
    QuerySnapshot querySnapshot = await subCollectionRef
        .where('addressSelected', isEqualTo: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      false;
    }
    return false;
  }

  Future createUserOrderCollection() async {
    final DocumentReference parentDocRef =
        FirebaseFirestore.instance.collection('usersOrders').doc(uID);

    String subCollectionName = 'user_orders';
    CollectionReference subCollectionRef =
        parentDocRef.collection(subCollectionName);

    orderSubCollection = subCollectionRef;

    addOrderDetails(
        orderSubCollection, addressSubCollection, cartSubCollection);
  }

  Future addOrderDetails(
      CollectionReference orderSubCollection,
      CollectionReference addressSubCollection,
      CollectionReference cartSubCollection) async {
    QuerySnapshot addressQuerySnapshot = await addressSubCollection
        .where('addressSelected', isEqualTo: true)
        .limit(1)
        .get();

    if (addressQuerySnapshot.docs.isNotEmpty) {
      String firstName = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['firstName'] as String;
      String lastName = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['lastName'] as String;
      String buyerAddress = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['deliveryAddress'] as String;
      String additionalInfo = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['additionalInfo'] as String;
      String region = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['region'] as String;
      String city = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['city'] as String;
      String mobilePhoneNo = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['mobilePhoneNo'] as String;
      String additionalPhoneNo = (addressQuerySnapshot.docs[0].data()
          as Map<String, dynamic>)['additionalPhoneNo'] as String;

      final cartQuerySnapshot = await cartSubCollection.get();

      final List<String> itemIDs = [];
      final List<String> itemNames = [];
      final List<String> itemImages = [];
      final List<double> itemPrices = [];
      final List<int> itemQuantities = [];
      final List<String> itemVariants = [];

      cartQuerySnapshot.docs.forEach((doc) {
        final String itemID =
            (doc.data() as Map<String, dynamic>)['Product ID'] as String;
        itemIDs.add(itemID);
        final String itemName =
            (doc.data() as Map<String, dynamic>)['Product name'] as String;
        itemNames.add(itemName);
        final String itemImage =
            (doc.data() as Map<String, dynamic>)['Product image'] as String;
        itemImages.add(itemImage);
        final double itemPrice =
            (doc.data() as Map<String, dynamic>)['Product price'] as double;
        itemPrices.add(itemPrice);
        final int itemQuantity =
            (doc.data() as Map<String, dynamic>)['Product quantity'] as int;
        itemQuantities.add(itemQuantity);
        final String itemVariant =
            (doc.data() as Map<String, dynamic>)['Product variant'] as String;
        itemVariants.add(itemVariant);
      });
      return orderSubCollection.doc().set({
        'Buyer First Name': firstName,
        'Buyer Last Name': lastName,
        'Buyer Address': buyerAddress,
        'Buyer Additional Info': additionalInfo,
        'Buyer State': region,
        'Buyer City': city,
        'Buyer Mobile Phone No': mobilePhoneNo,
        'Buyer Additonal Mobile Phone No': additionalPhoneNo,
        'Item IDs': itemIDs,
        'Item Names': itemNames,
        'Item Images': itemImages,
        'Item Prices': itemPrices,
        'Item Variants': itemVariants,
        'Item Quantities': itemQuantities,
      }).then(
          (success) => print('OrderFields successfully added to: user_orders'));
    } else {
      final cartQuerySnapshot = await cartSubCollection.get();

      final List<String> itemIDs = [];
      final List<String> itemNames = [];
      final List<String> itemImages = [];
      final List<double> itemPrices = [];
      final List<int> itemQuantities = [];
      final List<String> itemVariants = [];

      cartQuerySnapshot.docs.forEach((doc) {
        final String itemID =
            (doc.data() as Map<String, dynamic>)['Product ID'] as String;
        itemIDs.add(itemID);
        final String itemName =
            (doc.data() as Map<String, dynamic>)['Product name'] as String;
        itemNames.add(itemName);
        final String itemImage =
            (doc.data() as Map<String, dynamic>)['Product image'] as String;
        itemImages.add(itemImage);
        final double itemPrice =
            (doc.data() as Map<String, dynamic>)['Product price'] as double;
        itemPrices.add(itemPrice);
        final int itemQuantity =
            (doc.data() as Map<String, dynamic>)['Product quantity'] as int;
        itemQuantities.add(itemQuantity);
        final String itemVariant =
            (doc.data() as Map<String, dynamic>)['Product variant'] as String;
        itemVariants.add(itemVariant);
      });
      return orderSubCollection.doc().set({
        'Buyer Address': 'Store Pick Up',
        'Item IDs': itemIDs,
        'Item Names': itemNames,
        'Item Images': itemImages,
        'Item Prices': itemPrices,
        'Item Variants': itemVariants,
        'Item Quantities': itemQuantities,
      }).then((success) => print(
          'OrderFields successfully added to: user_orders -- address: store pick up'));
      ;
    }
  }

  Future addDonationDetails(String docID, String donator, int donationAmount,
      bool isAnonymous) async {
    return await donationCollection.doc(docID).set({
      'Donator Name': donator,
      'Donation Amount': donationAmount,
      'Anonymous': isAnonymous,
    });
  }
}

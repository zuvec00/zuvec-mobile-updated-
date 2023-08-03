import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<bool> itemSaved = [];
List<String> itemsID = [];
int documentLength2 = 0;

class Model extends ChangeNotifier {

  
  //reference boxes
  final _refUserSavedItems = Hive.box('currentUserSavedItems');
  final _refUserCartItems = Hive.box('currentUserCartItemsNew');
  final _refUserShippingAddress = Hive.box('currentUserShippingAddressDetails');
  final _refUserLikedItems = Hive.box('userLikedItems');

  //item list
  List<Map<String, dynamic>> userSavedItems = [];
  List<Map<String, dynamic>> userCartItems = [];
  List<Map<String, dynamic>> userShippingAddressDetails = [];
  List<Map<String, dynamic>> userOrderHistory = [];
  List userLikedItems = [];
  List<bool> functionCalled = [];
  int cartLength = 0;

  //delete these list later once you are sure.

  // *** S A V E D  S E C T I O N *** //

  // function handling adding saved items

  Future<void> addSavedItem(Map<String, dynamic> newItem) async {
    await _refUserSavedItems.add(newItem);
    refreshSavedItems();
  }

  //function handling refreshing saved item list
  void refreshSavedItems() {
    final data = _refUserSavedItems.keys.map((key) {
      final savedItem = _refUserSavedItems
          .get(key); // this gets the value of the particular key
      print(savedItem);
      return {
        'key': key,
        'productImagePath': savedItem['productImagePath'],
        'productName': savedItem['productName'],
        'productPrice': savedItem['productPrice'],
        'productSize':savedItem['productSize']
      };
    }).toList();

    userSavedItems = data.reversed.toList();
    print('userSavedItems list: $userSavedItems');
    print('userSaveItems length: ${userSavedItems.length}');
    notifyListeners();
  }

  //function handling removing a saved item
  void removeSavedItem(int index) async {
    await _refUserSavedItems.delete(index);
    refreshSavedItems();
    print('was removed');
    notifyListeners();
  }

  //function handling removing all saved items
  void removeAllSavedItems() {
    _refUserSavedItems.clear();
    refreshSavedItems();
    notifyListeners();
  }

  //function handling the no of save bool to add
  void itemSavedHandler() {
    for (int i = 0; i < documentLength2; i++) {
      itemSaved.add(false);
    }
    notifyListeners();
    print(documentLength2);
    print('savedItems $itemSaved');
  }

  //function handling the 'save' state of each item
  void saveStateHandler(int index) {
    itemSaved[index] = !itemSaved[index];
    notifyListeners();
  }

  // *** F E E D  S E C T I O N *** //

  Future<void> addLikedItem(int index, bool newItem) async {
    await _refUserLikedItems.put(index, newItem);
    refreshLikedItems();
  }

  add2LikedItems(Map<String, dynamic> mapItem) {
    userLikedItems.add(mapItem);
    notifyListeners();

    print('userLikedITmes:$userLikedItems');
  }

  void functionCalledHandler() {
    functionCalled.add(false);
    notifyListeners();
    print('functionCallded:$functionCalled');
  }

  bool functionCalledHander2(int index) {
    if (!functionCalled[index]) {
      functionCalled[index] = true;
      notifyListeners();
      print('functionCalledagain:$functionCalled');
      return false;
    }
    return true;
  }

  bool getLikedState(int index) {
    bool likedState = _refUserLikedItems.get(index);
    return likedState;
  }

  //function handling refreshing liked item list
  void refreshLikedItems() {
    final data = _refUserLikedItems.keys.map((key) {
      final likedItem = _refUserLikedItems.get(key);
      print('liked item key:$key');
      print('liked item: $likedItem');
      return {'key': key, 'likedItem': likedItem};
    }).toList();

    userLikedItems = data.toList();
    print('userLikedItems list: $userLikedItems');
    print('userLikedItems length: ${userLikedItems.length}');
    notifyListeners();
  }

  //function handling removing a liked item
  void removeAllLikedItem() async {
    await _refUserLikedItems.clear();
    refreshLikedItems();
    print('was removed');
    notifyListeners();
  }

  // *** C A R T  S E C T I O N *** //

  // function handling adding cart items
  Future<void> addCartItem(Map<String, dynamic> newItem) async {
    await _refUserCartItems.add(newItem);
    refreshCartItems();
  }

  //fucntion handling refreshing cart items
  void refreshCartItems() {
    final data = _refUserCartItems.keys.map((key) {
      final cartItem = _refUserCartItems.get(key);

      return {
        'key': key,
        'productImagePath': cartItem['productImagePath'],
        'productName': cartItem['productName'],
        'productPrice': cartItem['productPrice'],
        'productSize': cartItem['productSize'],
        'productItemQuantity': cartItem['productItemQuantity'],
      };
    }).toList();

    userCartItems = data.reversed.toList();
    print('userCartItems:$userCartItems');
    updateCartItemsLength();
    notifyListeners();
  }

  //function handling removing a cart item

  void removeCartItem(int index) async {
    await _refUserCartItems.delete(index);
    refreshCartItems();
    print('was removed');
    notifyListeners();
  }

  //function handling removing all saved items
  void removeAllCartItems() {
    _refUserCartItems.clear();
    refreshCartItems();
    notifyListeners();
  }

  //function handling the cart length
  void updateCartItemsLength() {
    cartLength = userCartItems.length;
    notifyListeners();
  }

  //function handling updating the cart item quantity
  void updateCartItemsQuantity(int key, Map<String, dynamic> item) async {
    await _refUserCartItems.put(key, item);
    refreshCartItems(); //update the UI
  }

  double getTotalPrice() {
    double totalPrice = 0;
    // loop through the  cartItems list and get the prices
    for (int i = 0; i < userCartItems.length; i++) {
      totalPrice += userCartItems[i]['productPrice'] *
          userCartItems[i]['productItemQuantity'];
    }
    return totalPrice;
  }

  // *** A D D R E S S  S E C T I O N *** //

  //funtion handling adding user addresses to local storage
  Future<void> addNewAddress(Map<String, dynamic> addressFields) async {
    await _refUserShippingAddress.add(addressFields);
    refreshShippingAddress();
  }

  //function handling the update of the UI; refreshing the list
  void refreshShippingAddress() {
    final data = _refUserShippingAddress.keys.map((key) {
      final addressField = _refUserShippingAddress.get(key);
      print(addressField);
      return {
        'key': key,
        'firstName': addressField['firstName'],
        'lastName': addressField['lastName'],
        'deliveryAddress': addressField['deliveryAddress'],
        'additionalInfo': addressField['additionalInfo'],
        'region': addressField['region'],
        'city': addressField['city'],
        'mobilePhoneNo': addressField['mobilePhoneNo'],
        'additionalPhoneNo': addressField['additionalPhoneNo'],
        'addressSelected': addressField['addressSelected']
      };
    }).toList();

    userShippingAddressDetails = data.toList();
    print('User shipping details: $userShippingAddressDetails');
    notifyListeners();
  }

  //function handling removing an address

  void removeAddress(int index) async {
    await _refUserShippingAddress.delete(index);
    refreshShippingAddress();
    print('was removed');
    notifyListeners();
  }

  void removeAllAdress() {
    _refUserShippingAddress.clear();
    refreshShippingAddress();
    notifyListeners();
  }

  //function handling updating the cart item quantity
  void updateAddress(int key, Map<String, dynamic> addressField) async {
    await _refUserShippingAddress.put(key, addressField);
    refreshShippingAddress(); //update the UI
  }

  void toggleSelectedAddress(
      int index, Map<String, dynamic> addressField) async {
    await _refUserShippingAddress.put(index, addressField);
    refreshShippingAddress();
  }

  // *** O R D E R  D E T A I L S  S E C T I O N *** //

  List<dynamic> productNames = [];
  List<dynamic> productImagePaths = [];
  List<dynamic> productPrices = [];
  List<dynamic> productSizes = [];
  List<dynamic> productQuantities = [];
  List<dynamic> userPrefferedAddress = [];

  //T H I S  I S  F O R  T H E  O R D E R  H I S T O R Y
  List<dynamic> orderNames = [];
  List<dynamic> orderImagePaths = [];

  //function handling calling all the function to get order details
  void addOrderDetails() {
    addProductName();
    addProductImage();
    addProductPrices();
    addProductSize();
    addProductQuantity();
    addUserAddress();
  }

  void refreshOrderHistory() {
    orderNames;
    orderImagePaths;
  }

  //function handling adding order product name
  void addProductName() {
    final data = _refUserCartItems.keys.map((key) {
      final cartItem = _refUserCartItems.get(key);

      return cartItem['productName'];
    }).toList();

    productNames = data.toList();
    orderNames = productNames;
    notifyListeners();
    print(' Ordered productName list: $productNames');
    print(' order anames: $orderNames');
  }

  //function handling adding order product image path
  void addProductImage() {
    final data = _refUserCartItems.keys.map((key) {
      final cartItem = _refUserCartItems.get(key);

      return cartItem['productImagePath'];
    }).toList();

    productImagePaths = data.toList();
    orderImagePaths = productImagePaths;
    notifyListeners();
    print(' Ordered productImagePaths list: $productImagePaths');
    print(orderImagePaths);
  }

  //function handling adding order product prices

  void addProductPrices() {
    final data = _refUserCartItems.keys.map((key) {
      final cartItem = _refUserCartItems.get(key);

      return cartItem['productPrice'];
    }).toList();

    productPrices = data.toList();
    notifyListeners();
    print(' Ordered productPrices list: $productPrices');
  }

  void addProductSize() {
    final data = _refUserCartItems.keys.map((key) {
      final cartItem = _refUserCartItems.get(key);

      return cartItem['productSize'];
    }).toList();

    productSizes = data.toList();
    notifyListeners();
    print(' Ordered productPrices list: $productSizes');
  }

  //function handling adding order product quantites
  void addProductQuantity() {
    final data = _refUserCartItems.keys.map((key) {
      final cartItem = _refUserCartItems.get(key);

      return cartItem['productItemQuantity'];
    }).toList();

    productQuantities = data.toList();
    notifyListeners();
    print(' Ordered productQuantities list: $productQuantities');
  }

  //function handling adding preffered user address

  void addUserAddress() {
    final Map<String, dynamic> preferredShippingAddress =
        userShippingAddressDetails
            .firstWhere((element) => element['addressSelected'] == true);
    userPrefferedAddress.add({
      'firstName': preferredShippingAddress['firstName'],
      'lastName': preferredShippingAddress['lastName'],
      'deliveryAddress': preferredShippingAddress['deliveryAddress'],
      'additionalInfo': preferredShippingAddress['additionalInfo'],
      'region': preferredShippingAddress['region'],
      'city': preferredShippingAddress['city'],
      'mobilePhoneNo': preferredShippingAddress['mobilePhoneNo'],
      'additionalPhoneNo': preferredShippingAddress['additionalPhoneNo'],
    });
    notifyListeners();

    print('User preffered shipping address: $userPrefferedAddress');
    //remember to access it just use userPrefferedAddress[index][key]
  }

  bool verifyUserPreferredAddress() {
    final Map<String, dynamic> prefferedAddress = userShippingAddressDetails
        .firstWhere((element) => element['addressSelected'] == true,
            orElse: () => {});
    print('Preffered Address: $prefferedAddress');
    if (!prefferedAddress.isEmpty) {
      return true;
    } else if (prefferedAddress == {}) {
      return false;
    }
    return false;
  }

  //get shipping fee
  double getUserPrefferedAddress() {
    final Map<String, dynamic> preferredAddress = userShippingAddressDetails
        .firstWhere((element) => element['addressSelected'] == true,
            orElse: () => {});
    final item = preferredAddress['region'];
    if (item == 'Edo' || item == 'edo') {
      return 1000;
    }
     else {
      return 3500;
    }
  }

  //function handling adding the order details to the firebase firestore
  Future updateUserOrderDetails(
      CollectionReference userOrderDetails, String uID) async {
    return await userOrderDetails.doc(uID).set({
      'Product Name': productNames,
      'Product ImagePath': productImagePaths,
      'Product Prices': productPrices,
      'Product Size': productSizes,
      'Product Quantity': productQuantities,
      'Preffered Shipping Address': userPrefferedAddress,
    });
  }

  //function handling the clearing of list

  void clearAllOrderDetailsFromList() {
    productNames.clear();
    productImagePaths.clear();
    productPrices.clear();
    productQuantities.clear();
    userPrefferedAddress.clear();
    removeAllCartItems();
  }
}



//just by the way: 
// final existingItem = userCartItems.firstWhere((element) => element['key']==key);


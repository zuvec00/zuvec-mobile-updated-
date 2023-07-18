/*
Consumer<Model>(
                builder: (context, value, child) => ListView.builder(
                    itemCount: value.userShippingAddressDetails.length,
                    itemBuilder: (context, index) {
                      final currentItem =
                          value.userShippingAddressDetails[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.50),
                          child: MyShippingAddressContainer(
                            index: currentItem['key'],
                            firstName: currentItem['firstName'],
                            lastName: currentItem['lastName'],
                            deliveryAddress: currentItem['deliveryAddress'],
                            additionalInfo: currentItem['additionalInfo'],
                            region: currentItem['region'],
                            city: currentItem['city'],
                            mobilePhoneNo: currentItem['mobilePhoneNo'],
                            additionalPhoneNo: currentItem['additionalPhoneNo'],
                            selected: currentItem['addressSelected'],
                          ));
                    }),
              ),
*/

/*
GestureDetector(
                      onTap: () {
                        setState(() {
                          addressSelected = !addressSelected;
                        });

                        // calling function to toggle if the address selected or not
                        Provider.of<Model>(context, listen: false)
                            .toggleSelectedAddress(widget.index, {
                          'firstName': widget.firstName,
                          'lastName': widget.lastName,
                          'deliveryAddress': widget.deliveryAddress,
                          'additionalInfo': widget.additionalInfo,
                          'region': widget.region,
                          'city': widget.city,
                          'mobilePhoneNo': widget.mobilePhoneNo,
                          'additionalPhoneNo': widget.additionalPhoneNo,
                          'addressSelected': addressSelected,
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: widget.selected
                                ? Colors.deepPurple[600]
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
                      



 bool addressChosen =
                      Provider.of<Model>(context, listen: false)
                          .verifyUserPreferredAddress();
                  print('Address Chosen: $addressChosen');

                  if (!storePickUp &&
                      value.userShippingAddressDetails.isEmpty) {
                    //notifies user
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Colors.red[400]!,
                      margin: const EdgeInsets.only(top: 0),
                      duration: const Duration(seconds: 2),
                      icon: const Icon(Icons.error_outline_rounded,
                          color: Colors.white),
                      messageText: Text(
                          "Add a shipping address before proceeding to payment",
                          style: GoogleFonts.quicksand(color: Colors.white)),
                    )..show(context);
                  } else if (!storePickUp && !addressChosen) {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Colors.red[400]!,
                      margin: const EdgeInsets.only(top: 0),
                      duration: const Duration(seconds: 2),
                      icon: const Icon(Icons.error_outline_rounded,
                          color: Colors.white),
                      messageText: Text("Please select one shipping address",
                          style: GoogleFonts.quicksand(color: Colors.white)),
                    )..show(context);
                  }                     



ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Frames(
                            index:
                                streamSnapshot.data!.docs.length - (index + 1),
                            postImages: streamSnapshot.data!.docs[
                                streamSnapshot.data!.docs.length -
                                    (index + 1)]['Post Images'],
                            postComment: streamSnapshot.data!.docs[
                                streamSnapshot.data!.docs.length -
                                    (index + 1)]['Post Comment'],
                          );
                        }),






Consumer<Model>(
          builder: (context, value, child) => value.userCartItems.length == 0
              ? CartEmpty()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('CART SUMMARY',
                              style: TextStyle(
                                  color: Colors.grey[
                                      600] /*fontSize: 18, fontWeight: FontWeight.bold*/)),
                          MyRemoveAllContainer2(),
                        ],
                      ),
                      Expanded(
                        flex: 5,
                        child: Consumer<Model>(
                          builder: (context, value, child) =>
                              ListView.builder(
                                  itemCount: value.userCartItems.length,
                                  itemBuilder: (context, index) {
                                    final currentItem =
                                        value.userCartItems[index];
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7.50),
                                        child: MyCartItems(
                                          index: currentItem['key'],
                                          productImagePath:
                                              currentItem['productImagePath'],
                                          productName:
                                              currentItem['productName'],
                                          productPrice:
                                              currentItem['productPrice'],
                                          productSize:
                                              currentItem['productSize'],
                                          itemQuantity: currentItem[
                                              'productItemQuantity'],
                                        ));
                                  }),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                thickness: 1,
                              ),
                              Expanded(
                                  child: Consumer<Model>(
                                builder: (context, value, child) => ListView(
                                  children: [
                                    const Text('Order Info',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Subtotal',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600])),
                                        Price(
                                          price: value.getTotalPrice(),
                                          fontSize: 13.5,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Shipping Cost',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600])),
                                        Text('Not included yet.',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600])),
                                        Price(
                                          price: value.getTotalPrice(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ))
                    ]),
        ),






        Consumer<Model>(
                      builder: (context, value, child) => ListView.builder(
                          itemCount: value.userSavedItems.length,
                          itemBuilder: (context, index) {
                            final currentItem = value.userSavedItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: MySavedItems(
                                productImagePath:
                                    currentItem['productImagePath'],
                                productName: currentItem['productName'],
                                productPrice: currentItem['productPrice'],
                                productSize: currentItem['productSize'],
                                index: currentItem['key'],
                              ),
                            );
                          }),
                    )
                       */
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/checkOutCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:canteen/providers/cartProvider.dart';
import 'package:canteen/screens/Maps/google_api_map.dart';
import 'package:canteen/widgets/cart_item.dart';

import '../providers/userProvider.dart';

class Checkout extends StatefulWidget {
  Checkout({
    super.key,
  });

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'API_KEY_NOT_FOUND';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getCordinates();
  }

  final TextEditingController deliveryNote = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
       resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            app.checkOut,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              tooltip: app.back,
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ScreenHelper(
                  desktop: _buildDesktopView(app, cartProvider, userProvider),
                  mobile: _buildMobileView(app, cartProvider, userProvider),
                  tablet: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 800
                      ),
                      child: _buildMobileView(app, cartProvider, userProvider)),
                  ),
                )),
          ),
        ),
        bottomSheet:   ScreenHelper.isDesktop(context) ?null:  _buildBottomCard(app, cartProvider),
        
        
        );
  }

  Widget _buildMobileView(AppLocalizations app, CartProvider cartProvider,
      UserProvider userProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 130),
        child: ListView(
          children: <Widget>[
            _buildHead(app, cartProvider, userProvider),
            _buildItems(app: app, cartProvider: cartProvider)
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopView(AppLocalizations app, CartProvider cartProvider,
      UserProvider userProvider) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ListView(
              children: <Widget>[
                _buildItems(app: app, cartProvider: cartProvider),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        Container(
          width: 1.5, // Thickness of the divider
          color: Colors.grey[300], // Light grey color for subtle effect
          margin: EdgeInsets.symmetric(
              vertical: 10), // Add spacing from top & bottom
        ),
      Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox.expand(
              child: Stack(
                children: [
              
                  SingleChildScrollView(
                   // Prevents content from hiding behind bottom card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHead(app, cartProvider, userProvider),
              
                        SizedBox(height: 10), // Spacing
              
                        AspectRatio(
                          aspectRatio: 16 / 9, // Responsive Map Placeholder
                          child: Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              final latitude =
                                  cartProvider.address?.geoPoint?.latitude;
                              final longitude =
                                  cartProvider.address?.geoPoint?.longitude;
              
                              final String staticMapUrl =
                                  "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=600x400&markers=color:red%7C$latitude,$longitude&key=$apiKey";
              
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  staticMapUrl,
                                  fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // Image loaded
                                    } else {
                                      return AspectRatio(
                                        aspectRatio: 16 / 9, // A
                                        child: Container(
                                          color: Colors.grey[
                                              200], // Placeholder background color
                                          child: Center(
                                            child: Icon(
                                              Icons.image, // Placeholder icon
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return AspectRatio(
                                      aspectRatio: 16 / 9, // A
                                      child: Container(
                                        color: Colors.grey[
                                            200], // Background color for errors
                                        child: Center(
                                          child: Icon(
                                            Icons
                                                .broken_image, // Icon for failed image load
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  
              
                                ),
                              );
                            },
                          ),
                        ),
              
                     
                      ],
                    ),
                  ),
              
                  // ✅ Bottom Card Stays Fixed on Top of the Column
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: _buildBottomCard(app, cartProvider),
                  ),
                ],
              ),
            ),
          ),
        )

      ],
    );
  }

  Widget _buildHead(AppLocalizations app, CartProvider cartProvider,
      UserProvider userProvider) {
    List<String> category = [app.cash, app.payStack];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: app.shippingAddress + ": ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: cartProvider.fullAddress,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                softWrap: true,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return PlacePickerWidget();
                }));
              },
              child: Icon(
                Icons.edit,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        ListTile(
          title: Text(
            userProvider.user!.firstName!,
            style: const TextStyle(
              //                    fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          subtitle: Text(userProvider.user!.address ?? ""),
        ),
        const SizedBox(height: 10.0),
        Text(
          app.paymentMethod,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        Card(
          color: Colors.white,
          shadowColor: Colors.grey[900],
          surfaceTintColor: Colors.white,
          elevation: 4.0,
          child: ListTile(
            title: CustomDropdown<String>(
              hintText: app.selectPaymentMethod,
              items: category,
              initialItem: category[1],
              onChanged: (value) {
                cartProvider.selectedObject = value;
              },
            ),
            leading: Icon(
              FontAwesomeIcons.creditCard,
              size: 50.0,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCard(AppLocalizations app, CartProvider cartProvider) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: CheckoutCard(
          deliveryNote: deliveryNote, app: app, cartProvider: cartProvider),
    );
  }

  Widget _buildItems(
      {required AppLocalizations app, required CartProvider cartProvider}) {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Text(
          app.items,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        GridView.builder(
        shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ScreenHelper.isMobile(context) ? 1 : ScreenHelper.isTablet(context) ? 3: 2,
            childAspectRatio: ScreenHelper.isMobile(context) ? 2.2 : 2.2,
          ),
          itemCount: cartProvider.cartMenus.length,
          itemBuilder: (BuildContext context, int index) {
            final food = cartProvider.cartMenus[index];

            return CartItem(
              menu: food,
            );
          },
        ),
      ],
    );
  }
}

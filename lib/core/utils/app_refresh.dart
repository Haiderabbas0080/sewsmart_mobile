import 'package:flutter/foundation.dart';

// Tells open screens that orders or saved designs changed, so they load their
// data again.
//
// The bottom navigation keeps every tab alive in an IndexedStack. A tab that
// loads its list once in initState would otherwise keep showing old data after
// an order is placed, accepted or delivered on another screen.
class AppRefresh {
  AppRefresh._();

  static final ValueNotifier<int> orders = ValueNotifier<int>(0);

  static void ordersChanged() => orders.value++;

  // A design was saved to or removed from the wishlist.
  static final ValueNotifier<int> wishlist = ValueNotifier<int>(0);

  static void wishlistChanged() => wishlist.value++;
}

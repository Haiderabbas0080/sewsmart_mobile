import 'package:flutter/foundation.dart';

// Tells open screens that orders changed, so they load their data again.
//
// The bottom navigation keeps every tab alive in an IndexedStack. A tab that
// loads its list once in initState would otherwise keep showing old data after
// an order is placed, accepted or delivered on another screen.
class AppRefresh {
  AppRefresh._();

  static final ValueNotifier<int> orders = ValueNotifier<int>(0);

  static void ordersChanged() => orders.value++;
}

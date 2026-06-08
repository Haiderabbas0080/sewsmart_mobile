import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../core/data/mock_data.dart';
import '../core/widgets/shared_widgets.dart';
import '../modules/customer/screens/customer_home_screen.dart';
import '../modules/customer/screens/browse_tailors_screen.dart';
import '../modules/customer/screens/order_history_screen.dart';
import '../modules/customer/screens/customer_profile_screen.dart';
import '../modules/tailor/screens/tailor_dashboard_screen.dart';
import '../modules/tailor/screens/incoming_orders_screen.dart';
import '../modules/tailor/screens/tailor_earnings_screen.dart';
import '../modules/tailor/screens/tailor_profile_manage_screen.dart';
import '../modules/tailor/screens/tailor_chat_screen.dart';
import '../modules/rider/screens/rider_dashboard_screen.dart';
import '../modules/rider/screens/rider_earnings_screen.dart';
import '../modules/rider/screens/rider_profile_screen.dart';

// ─── Customer Navigation ───────────────────────────────────────────────────────
class MainNavigationCustomer extends StatefulWidget {
  const MainNavigationCustomer({super.key});

  @override
  State<MainNavigationCustomer> createState() => _MainNavigationCustomerState();
}

class _MainNavigationCustomerState extends State<MainNavigationCustomer> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CustomerHomeScreen(),
    BrowseTailorsScreen(),
    OrderHistoryScreen(),
    _CustomerChatListScreen(),
    CustomerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primaryLight,
            unselectedItemColor: AppColors.textMuted,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explore'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Customer Chat List ────────────────────────────────────────────────────────
class _CustomerChatListScreen extends StatelessWidget {
  const _CustomerChatListScreen();

  @override
  Widget build(BuildContext context) {
    // Show conversations for customer C001 (current mock user)
    final orders = MockData.orders.where((o) => o.customerId == 'C001').toList();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text('Messages',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ),
              Expanded(
                child: orders.isEmpty
                    ? const EmptyState(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'No conversations yet',
                        subtitle: 'Place an order to chat with your tailor',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: orders.length,
                        itemBuilder: (ctx, i) {
                          final o = orders[i];
                          return GlassCard(
                            padding: const EdgeInsets.all(14),
                            onTap: () => Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => TailorChatScreen(
                                  customerName: o.tailorName,
                                  orderId: o.id,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                        colors: [AppColors.primary, AppColors.teal]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      o.tailorName[0],
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(o.tailorName,
                                          style: GoogleFonts.poppins(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13)),
                                      Text('Order: ${o.id} · ${o.garmentType}',
                                          style: GoogleFonts.poppins(
                                              color: AppColors.textMuted, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded,
                                    color: AppColors.textMuted, size: 14),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tailor Navigation ─────────────────────────────────────────────────────────
class MainNavigationTailor extends StatefulWidget {
  const MainNavigationTailor({super.key});

  @override
  State<MainNavigationTailor> createState() => _MainNavigationTailorState();
}

class _MainNavigationTailorState extends State<MainNavigationTailor> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TailorDashboardScreen(),
    IncomingOrdersScreen(),
    _TailorChatListScreen(),
    TailorEarningsScreen(),
    TailorProfileManageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.tealLight,
            unselectedItemColor: AppColors.textMuted,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Earnings'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}


// ── Tailor Chat List ──────────────────────────────────────────────────────────
class _TailorChatListScreen extends StatelessWidget {
  const _TailorChatListScreen();

  @override
  Widget build(BuildContext context) {
    // Show conversations for tailor T001
    final orders = MockData.orders.where((o) => o.tailorId == 'T001').toList();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.tealOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text('Messages',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ),
              Expanded(
                child: orders.isEmpty
                    ? const EmptyState(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'No conversations yet',
                        subtitle: 'Conversations will appear when customers place orders',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: orders.length,
                        itemBuilder: (ctx, i) {
                          final o = orders[i];
                          return GlassCard(
                            padding: const EdgeInsets.all(14),
                            onTap: () => Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => TailorChatScreen(
                                  customerName: o.customerName,
                                  orderId: o.id,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                        colors: [AppColors.teal, AppColors.tealLight]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      o.customerName[0],
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(o.customerName,
                                          style: GoogleFonts.poppins(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13)),
                                      Text('Order: ${o.id} · ${o.garmentType}',
                                          style: GoogleFonts.poppins(
                                              color: AppColors.textMuted, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                StatusBadge(
                                    label: o.statusLabel,
                                    color: AppColors.teal),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ─── Rider Navigation ──────────────────────────────────────────────────────────
class MainNavigationRider extends StatefulWidget {
  const MainNavigationRider({super.key});

  @override
  State<MainNavigationRider> createState() => _MainNavigationRiderState();
}

class _MainNavigationRiderState extends State<MainNavigationRider> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RiderDashboardScreen(),
    RiderDashboardScreen(),   // Deliveries tab — same dashboard shows assigned deliveries
    RiderEarningsScreen(),
    RiderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.riderColor,
            unselectedItemColor: AppColors.textMuted,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.local_shipping_rounded), label: 'Deliveries'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Earnings'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}


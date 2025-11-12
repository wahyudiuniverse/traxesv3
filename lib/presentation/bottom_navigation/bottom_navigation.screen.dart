    import 'package:flutter/material.dart';
    import 'package:traxes/presentation/dashboard/dashboard.screen.dart';
    import 'package:traxes/presentation/user/profile.dart';
    import 'package:traxes/presentation/feature/history/history.screen.dart';

    class BottomNavigation extends StatefulWidget {
      const BottomNavigation({super.key});

      @override
      _BottomNavigationBarState createState() => _BottomNavigationBarState();
    }

    class _BottomNavigationBarState extends State<BottomNavigation> {
      int _selectedIndex = 0; // Tracks the currently selected tab index

      // List of widgets to display for each tab
      static List<Widget> _widgetOptions = <Widget>[
        DashboardScreen(),
        HistoryScreen(),
        ProfileScreen(),
      ];

      void _onItemTapped(int index) {
        setState(() {
          _selectedIndex = index;
        });
      }

      @override
      Widget build(BuildContext context) {
        // Nilai margin yang kita inginkan antara batas atas dan ikon menu
        const double topMarginValue = 8.0; 
        
        // Tinggi default BottomNavigationBar adalah sekitar 56.0
        const double defaultBarHeight = 70.0;

        // Tinggi total yang kita inginkan: Default Height + Margin Atas
        const double customBarHeight = defaultBarHeight + topMarginValue;
        
        return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex), // Display the selected page
          ),
          bottomNavigationBar: Container(
            height: customBarHeight + MediaQuery.of(context).padding.bottom, // Tambah bottom padding untuk safe area
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02), // Shadow color with transparency
                  blurRadius: 1, // Adjust the blur radius for a softer shadow
                  spreadRadius: 1, // Adjust how much the shadow spreads
                  offset: const Offset(0, -1), // Position the shadow above the bar
                ),
              ],
            ),
            child: BottomNavigationBar(
              // The rest of your BottomNavigationBar code
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFF0D6EFD),
              unselectedItemColor: Color(0xFF6B7280),
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  label: 'Riwayat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      }
    }
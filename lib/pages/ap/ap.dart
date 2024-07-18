import 'package:flutter/material.dart';
import 'package:flutter_progect/pages/ap/apBooking.dart';
import 'package:flutter_progect/pages/ap/apHall.dart';
import 'package:flutter_progect/pages/ap/apLight.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0; // 0 - Залы, 1 - Свет, 2 - Брони

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF707070),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Admin',
              style: TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF008BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Сворачиваемая панель слева
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.meeting_room),
                label: Text('Залы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.lightbulb),
                label: Text('Свет'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book),
                label: Text('Брони'),
              ),
            ],
          ),
          // Основное содержимое
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Список залов, осветительных приборов или броней
                  Expanded(
                    child: _selectedIndex == 0
                        ? APHallPage() // Вывод страницы "Залы"
                        : _selectedIndex == 1
                            ? APLightPage() // Вывод страницы "Свет"
                            : _selectedIndex == 2
                                ? AllBookingsPage() // Вывод страницы "Брони"
                                : const Center(
                                    child: Text('Страница в разработке'),
                                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


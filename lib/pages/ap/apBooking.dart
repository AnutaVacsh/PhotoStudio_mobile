import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllBookingsPage extends StatefulWidget {
  @override
  _AllBookingsPageState createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings(); // Загрузка бронирований при инициализации
  }

  Future<void> _fetchBookings() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/Booking/allBooking'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          bookings = jsonData.map((bookingData) => Booking.fromJson(bookingData)).toList();
        });
      } else {
        throw Exception('Ошибка при получении данных с сервера: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Брони'),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          Color cardColor;
          if (bookings[index].state == 'canceled') {
            cardColor = Color.fromARGB(255, 255, 240, 245);
          } else if (bookings[index].state == 'created') {
            cardColor = Color.fromARGB(255, 255, 255, 255);
          } else {
            cardColor = Colors.white;
          }

          return Card(
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Дата: ${bookings[index].day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Время: ${bookings[index].time}'),
                  SizedBox(height: 8),
                  Text('Зал: ${bookings[index].idHall}'),
                  SizedBox(height: 8),
                  Text('Стоимость: ${bookings[index].price}'),
                  SizedBox(height: 8),
                  Text('Статус: ${bookings[index].state}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
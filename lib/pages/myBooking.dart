import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_progect/user_data.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  List<Booking> bookings = [];
  var userId;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    // userId = UserDataProvider.of(context)?.userData.userId;
    // print(UserDataProvider.of(context)?.userData.userId);
  }

  Future<void> _fetchBookings() async {
    print(userId);
    // if (userId != null) {
      try {
        // print(UserDataProvider.of(context)?.userData.userId);
        // final response = await http.get(Uri.parse('http://localhost:8080/Booking/userBooking/${UserDataProvider.of(context)?.userData.userId}'));
        final response = await http.get(Uri.parse('http://localhost:8080/Booking/allBooking'));


        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body) as List<dynamic>;
          setState(() {
            bookings = jsonData.map((bookingData) => Booking(
              id: bookingData['id'], 
              year: bookingData['year'],
              month: bookingData['month'],
              day: bookingData['day'],
              time: bookingData['time'],
              idHall: bookingData['idHall'],
              idBack: bookingData['idBack'],
              idUser: bookingData['idUser'],
              state: bookingData['state'],
              price: bookingData['price'],
            )).toList();
          });
        } else {
          throw Exception('Ошибка при получении данных с сервера: ${response.statusCode}');
        }
      } catch (e) {
        print('Ошибка: $e');
      }
    // }
  }

  Future<void> _cancelBooking(int bookingId) async {
    try {
      final response = await http.put(Uri.parse('http://localhost:8080/Booking/editState/$bookingId'), 
        headers: {'Content-Type': 'application/json'}, 
        body: 'canceled'
      );
      if (response.statusCode == 200) {
        // Обновляем список броней после изменения статуса
        // Поиск брони с измененным статусом
        final bookingIndex = bookings.indexWhere((booking) => booking.id == bookingId);
        if (bookingIndex != -1) {
          setState(() {
            // bookings[bookingIndex].state = bookings[bookingIndex].state;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Бронь отменена')),
        );
      } else {
        throw Exception('Ошибка при отмене брони: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при отмене брони: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF707070), 
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        )
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'МОИ БРОНИ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBookingRow('Дата', '${booking.day}'),
                        _buildBookingRow('Время', '${booking.time}:00'),
                        _buildBookingRow('Зал', booking.idHall.toString()),
                        _buildBookingRow('Стоимость',
                            '${booking.price} рублей'),
                        _buildBookingRow('Статус', booking.state),
                      ],
                    ),
                    trailing: booking.state == 'created'
                        ? ElevatedButton(
                            onPressed: () => _cancelBooking(booking.id!), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              textStyle: const TextStyle(fontSize: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Text('Отменить'),
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
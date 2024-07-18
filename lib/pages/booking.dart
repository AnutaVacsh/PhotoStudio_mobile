import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:intl/intl.dart';
import 'package:flutter_progect/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int  selectedHallId = -1;
  List<int> selectedLights = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<Hall> halls = [];
  List<Light> lights = [];


  Future<void> _fetchHalls() async {
    final response = await http.get(Uri.parse('http://localhost:8080/Hall/allHall'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        halls = data.map((item) => Hall.fromJson(item)).toList();
      });
    } else {
      print('Error fetching halls: ${response.statusCode}');
    }
  }

  Future<void> _fetchLights() async {
    final response = await http.get(Uri.parse('http://localhost:8080/Light/allLight'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        lights = data.map((item) => Light.fromJson(item)).toList();
      });
    } else {
      print('Error fetching lights: ${response.statusCode}');
    }
  }

  Future<void> _safeBooking() async {

      final response = await http.post(
        Uri.parse('http://localhost:8080/Booking/safeBooking'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
            'year': selectedDate!.year,
            'month': selectedDate!.month,
            'day': selectedDate!.day,
            'time': selectedTime!.hour,
            'idHall': selectedHallId,
            // 'idBack': -1,
            'idUser': UserDataProvider.of(context)!.userData.userId,
            'state': 'created',
            'price': prise(),
          }),
      );

      if (response.statusCode == 200) {
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Бронирование добавлено')),
        );
      } else {
        throw Exception('Ошибка при добавлении бронирования: ${response.statusCode}');
      }
    }

  int prise(){
    int p = 0;

    halls.forEach((element) { 
      if(element.id == selectedHallId) p += element.priceDays;
    });

    lights.forEach((light) {
      selectedLights.forEach((select) { 
        if(light.id == select) p += light.price;
      });
    });

    return p;
  }

  @override
  void initState() {
    super.initState();
    _fetchHalls();
    _fetchLights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF707070),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            print(Navigator.defaultRouteName);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        )
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'БРОНЬ СТУДИИ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 20),
            const Text(
              'Выберите зал',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: halls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedHallId = halls[index].id;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Image.asset(
                            'img/${halls[index].img ?? ''}',
                            width: 100,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image_not_supported, size: 50);
                          },
                          ),
                          const SizedBox(height: 5),
                          Text(
                            halls[index].numberHall,
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedHallId == halls[index].id
                                  ? const Color(0xFF008BFF)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Выберите один или несколько осветительных приборов',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lights.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedLights.contains(lights[index].id)) {
                          selectedLights.remove(lights[index].id);
                        } else {
                          selectedLights.add(lights[index].id);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Image.asset(
                            'img/${lights[index].img ?? ''}',
                            width: 100,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image_not_supported, size: 50);
                          },
                          ),
                          const SizedBox(height: 5),
                          Text(
                            lights[index].title,
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedLights.contains(lights[index].id)
                                  ? const Color(0xFF008BFF)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Выберите день и время',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((value) {
                        setState(() {
                          selectedDate = value;
                        });
                      });
                    },
                    child: Text(
                      selectedDate != null
                          ? DateFormat('dd.MM.yyyy').format(selectedDate!)
                          : 'Выбрать дату',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        setState(() {
                          selectedTime = value; // Сохраняем выбранное время
                        });
                      });
                    },
                    child: Text(
                      selectedTime != null
                          ? '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                          : 'Выбрать время',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            UserDataProvider.of(context)?.userData.userStatus == 'user' ?
              ElevatedButton(
                onPressed: () {
                  if (selectedHallId != -1 && selectedDate != null && selectedTime != null) {
                    _safeBooking();
                    print('Бронирование: Зал ${selectedHallId}, '
                        'Освещение: ${selectedLights.join(', ')}, '
                        'Дата: ${DateFormat('dd.MM.yyyy').format(selectedDate!)}'
                        'Время: ${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                    );
                    Navigator.pushReplacementNamed(context, '/thanks'); 
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Выберите зал, дату и время')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008BFF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(250, 40),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Забронировать'),
              ) :
              const Text(
                'Вы не зарегистрировались',
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:flutter_progect/pages/ap/editHall.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APHallPage extends StatefulWidget {
  const APHallPage({Key? key}) : super(key: key);

  @override
  State<APHallPage> createState() => _APHallPageState();
}

class _APHallPageState extends State<APHallPage> {
  List<Hall> halls = [];

  @override
  void initState() {
    super.initState();
    _fetchHalls();
  }

  Future<void> _fetchHalls() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/Hall/allHall')); 

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          halls = jsonData.map((hallData) => Hall(
            id: hallData['id'], 
            title: hallData['title'], 
            description: hallData['description'],
            img: hallData['img'], 
            numberHall: hallData['numberHall'], 
            priceDays: hallData['priceDays'],
            priceEnd: hallData['priceEnd'], 
          )).toList();
        });
      } else {
        throw Exception('Ошибка при получении данных с сервера: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  Future<void> _deleteHall(int hallId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:8080/Hall/deleteHall/$hallId'));
          // headers: {'Content-Type': 'application/json'},
          // body: jsonEncode({'status': 'удалён'}));

      if (response.statusCode == 200) {
        _fetchHalls(); // Обновляем список залов после удаления
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Зал удален')),
        );
      } else {
        throw Exception('Ошибка при удалении зала: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении зала: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Залы',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Кнопка "Добавить новый зал"
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addHall');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008BFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text('Добавить новый зал'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Список залов
            Expanded(
              child: ListView.builder(
                itemCount: halls.length,
                itemBuilder: (context, index) {
                  final hall = halls[index];
                  return HallItem(
                    hall: hall,
                    onDelete: () => _deleteHall(hall.id), 
                    onEdit: () {
                      // Navigator.pushNamed(context, '/editHall', arguments: {
                      //   'hallId': hall.id,
                      // });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditHallPage(hallId: hall.id)));
                      print(hall.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HallItem extends StatelessWidget {
  final Hall hall;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const HallItem({
    Key? key,
    required this.hall,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset( // Изменяем на Image.network
                  'img/${hall.img!}',
                  width: 120,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported); // Отображаем иконку ошибки, если изображение не загружено
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Зал "${hall.numberHall}"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Text(hall.description ?? ''),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
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
                  child: const Text('Удалить'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008BFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text('Редактировать'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
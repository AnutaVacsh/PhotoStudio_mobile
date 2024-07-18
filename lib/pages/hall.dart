import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HallPage extends StatefulWidget {
  const HallPage({Key? key}) : super(key: key);

  @override
  State<HallPage> createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> {
  List<Hall> halls = []; 

  @override
  void initState() {
    super.initState();
    _fetchHallsFromLocalhost(); // Загрузка залов при инициализации
  }

  Future<void> _fetchHallsFromLocalhost() async {
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

    halls.forEach((element) { print(element.img);});
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
            const Text(
              'ВЫБЕРИТЕ ЗАЛ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: halls.length, 
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                    // visualDensity: VisualDensity.compact,
                    leading:  halls[index].img != null && halls[index].img!.isNotEmpty
                      ? Image.asset(
                          'img/${halls[index].img ?? ''}',
                          width: 120,
                          height: 150,
                          // fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image_not_supported, size: 50);
                          },
                        )
                      : Icon(Icons.image_not_supported, size: 50), 
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Зал "${halls[index].numberHall}"', 
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'цена в будние дни ${halls[index].priceDays}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'цена в выходные дни ${halls[index].priceEnd}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/hallDetails', arguments: {
                        'hallId': halls[index].id,
                      });
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
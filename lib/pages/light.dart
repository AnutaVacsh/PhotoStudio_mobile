import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LightPage extends StatefulWidget {
  const LightPage({Key? key}) : super(key: key);

  @override
  State<LightPage> createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  List<Light> lights = [];

  @override
  void initState() {
    super.initState();
    _fetchLightsFromLocalhost(); // Загрузка света при инициализации
  }

  Future<void> _fetchLightsFromLocalhost() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/Light/allLight'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          lights = jsonData.map((lightData) => Light(
            id: lightData['id'],
            title: lightData['title'],
            description: lightData['description'],
            img: lightData['img'],
            price: lightData['price'],
          )).toList();
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
        backgroundColor: const Color(0xFF707070),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ВЫБЕРИТЕ ОСВЕЩЕНИЕ',
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
                itemCount: lights.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    
                    dense: true,
                    visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                    leading: lights[index].img != null && lights[index].img!.isNotEmpty 
                        ? Image.network(
                            'img/${lights[index].img!}', 
                            width: 120,
                            height: 150,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.lightbulb, size: 100);
                            },
                          ) 
                        : const Icon(Icons.lightbulb, size: 100),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lights[index].title, 
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'стоимость ${lights[index].price}', // Используйте описание света из массива света
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        
                      ],
                    ),
                    onTap: () {
                      // Переход на страницу с деталями света
                      Navigator.pushNamed(context, '/lightDetails', arguments: {
                        'lightId': lights[index].id, // Передаем ID света из массива света
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
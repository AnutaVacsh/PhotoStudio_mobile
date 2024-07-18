import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:flutter_progect/pages/ap/editLight.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APLightPage extends StatefulWidget {
  const APLightPage({super.key});
  
  @override
  State<APLightPage> createState() => _APLightPageState();
}

class _APLightPageState extends State<APLightPage> {
  List<Light> lights = [];

  @override
  void initState() {
    super.initState();
    _fetchLights();
  }

  Future<void> _fetchLights() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/Light/allLight'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          lights = jsonData.map((lightData) => Light(
            id: lightData['id'], 
            title: lightData['title'], // Используйте поле 'numberHall' для имени
            description: lightData['description'],
            img: lightData['img'], 
            price: lightData['price'], // Используйте поле 'img' для пути изображения
          )).toList();
        });
      } else {
        throw Exception('Ошибка при получении данных с сервера: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошиlhlhlбка: $e');
    }
  }

   Future<void> _deleteLight(int lightId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:8080/Light/deleteLight/$lightId'));

      if (response.statusCode == 200) {
        _fetchLights();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Свет удален')),
        );
      } else {
        throw Exception('Ошибка при удалении света: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении света: $e')),
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
            // Заголовок
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Свет',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Кнопка "Добавить новый свет"
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addLight'); // Переход на страницу добавления света
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
                  child: const Text('Добавить новый свет'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Список осветительных приборов
            Expanded(
              child: ListView.builder(
                itemCount: lights.length,
                itemBuilder: (context, index) {
                  final light = lights[index];
                  return LightItem(
                    light: light,
                    onDelete: () => _deleteLight(light.id),
                    onEdit: () {
                      // Navigator.pushNamed(context, '/editLight', arguments: {
                      //   'lightId': light.id,
                      // });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditLightPage(lightId: light.id)));
                      print(light.id);
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

class LightItem extends StatelessWidget {
  final Light light;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const LightItem({
    Key? key,
    required this.light,
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
                Image.network(
                  'img/${light.img ?? ''}',
                  width: 120,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  } 
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        light.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Text(light.description ?? ''),
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
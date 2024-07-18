import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditLightPage extends StatefulWidget {
  final int lightId;

  const EditLightPage({Key? key, required this.lightId}) : super(key: key);

  @override
  State<EditLightPage> createState() => _EditLightPageState();
}

class _EditLightPageState extends State<EditLightPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePathController = TextEditingController();
  final _priceController = TextEditingController();

  late Light light;

  @override
  void initState() {
    super.initState();
    _fetchLight();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imagePathController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _fetchLight() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/Light/getLight/${widget.lightId}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final lightData = Light.fromJson(jsonData);
        setState(() {
          light = lightData;
          _titleController.text = light.title;
          _descriptionController.text = light.description!;
          _imagePathController.text = light.img!;
          _priceController.text = light.price.toString();
        });
      } else {
        throw Exception('Ошибка при получении данных с сервера: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  Future<void> _editLight() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final imagePath = _imagePathController.text;
      final price = int.tryParse(_priceController.text) ?? 0; 

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/Light/editLight/${light.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': title,
            'price': price,
            'description': description,
            'img': imagePath, 
            'status': 'есть', 
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Свет обновлен')),
          );
        } else {
          throw Exception('Ошибка при обновлении света: ${response.statusCode}');
        }
      } catch (e) {
        print('Ошибка: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при обновлении света: $e')),
        );
      }
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
        title: const Text('Редактировать Свет'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название света',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название света';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание света',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите описание света';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Путь к изображению света',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите путь к изображению света';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена света',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену света';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите числовое значение';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _editLight,
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
                child: const Text('Обновить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
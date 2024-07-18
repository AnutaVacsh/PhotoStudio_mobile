import 'package:flutter/material.dart';
import 'package:flutter_progect/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditHallPage extends StatefulWidget {
  final int hallId;

  const EditHallPage({Key? key, required this.hallId}) : super(key: key);

  @override
  State<EditHallPage> createState() => _EditHallPageState();
}

class _EditHallPageState extends State<EditHallPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePathController = TextEditingController();

  late Hall hall;

  @override
  void initState() {
    super.initState();
    _fetchHall();
    
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imagePathController.dispose();
    super.dispose(); 
  }

  Future<void> _fetchHall() async {
    try {
      print('khkhkkh${widget.hallId}');
      final response = await http.get(Uri.parse('http://localhost:8080/Hall/getHall/${widget.hallId}'));
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final hallData = Hall.fromJson(jsonData);
        setState(() {
          hall = hallData; 
          print(hall.numberHall);
          _nameController.text = hall.numberHall;
          _descriptionController.text = hall.description!;
          _imagePathController.text = hall.img!;
        });
      } else {
        throw Exception('Ошибка при получении данных с сервера: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  Future<void> _editHall() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final imagePath = _imagePathController.text;

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/Hall/editHall/${hall.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'numberHall': name, 
            'priceDays': hall.priceDays, 
            'priceEnd': hall.priceEnd, 
            'description': description,
            'img': imagePath,
            'status': 'есть',
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Зал обновлен')),
          );
        } else {
          throw Exception('Ошибка при обновлении зала: ${response.statusCode}');
        }
      } catch (e) {
        print('Ошибка: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при обновлении зала: $e')),
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
        title: const Text('Редактировать зал'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название зала',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название зала';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание зала',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите описание зала';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Путь к изображению зала',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите путь к изображению зала';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _editHall,
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
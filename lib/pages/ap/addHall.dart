import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Добавлен для работы с файлами

class AddHallPage extends StatefulWidget {
  @override
  _AddHallPageState createState() => _AddHallPageState();
}

class _AddHallPageState extends State<AddHallPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker(); 
  File? _selectedImage;
  String? _imagePath; // Храним путь к изображению
  String? _imageName; // Храним имя изображения

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        // Сохраняем путь к изображению
        _imagePath = pickedFile.path.split('/').last;
        // Извлекаем имя файла из пути
        _imageName = pickedFile.path.split('/').last;
      });
      print(_imageName);
    }
  }

  Future<void> _addHall() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = int.tryParse(_priceController.text) ?? 0;
      final description = _descriptionController.text;

      // Проверяем, есть ли выбранное изображение
      if (_imagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Выберите изображение')),
        );
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/Hall/safeHall'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'numberHall': name, 
            'priceDays': price, 
            'priceEnd': price+200, 
            'description': description,
            'img': _imageName,
            'status': 'есть',
          }),
        );

        if (response.statusCode == 201) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Зал добавлен')),
          );
        } else {
          throw Exception('Ошибка при добавлении зала: ${response.statusCode}');
        }
      } catch (e) {
        print('Ошибка: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при добавлении зала: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить новый Зал'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Название',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Цена',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              // Виджет выбора изображения
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Выбрать изображение'),
              ),
              if (_selectedImage != null)
                Image.asset(
                  'img/${_imageName!}',
                  height: 100,
                  width: 100,
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addHall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008BFF),
                  foregroundColor: Colors.white,
                ),
                child: Text('Сохранить'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008BFF),
                  foregroundColor: Colors.white,
                ),
                child: Text('Отменить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ThanksPage extends StatelessWidget {
  const ThanksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Спасибо!'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ваш заказ на рассмотрении',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Спасибо, что выбрали нас! Ждём вас по адресу:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'г. Саратов, проспект Строителей д.1к3А, ТЦ Атрио, центральный вход, 3-й этаж',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '8-967-806-49-37',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/'); // Переход на главную страницу
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF707070),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(250, 40),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('На главную'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
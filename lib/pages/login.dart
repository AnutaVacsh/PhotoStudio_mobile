import 'package:flutter/material.dart';
import 'package:flutter_progect/user_data.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

   void _checkData(String userType) async {
    if (_formKey.currentState!.validate()) {
      final login = _loginController.text;
      final password = _passwordController.text;

      if (userType == 'user') {
        final response = await http.get(Uri.parse('http://localhost:8080/User/checkUser/$login/$password'));

        if (response.statusCode == 200) {
          final userId = int.tryParse(response.body);
          if (userId != null && userId > 0) {
            // Авторизация успешна, переходим на другую страницу
            UserDataProvider.of(context)?.userData.changeUserName(login);
            UserDataProvider.of(context)?.userData.changeUserStatus('user');
            UserDataProvider.of(context)?.userData.changeUserId(userId);
            Navigator.pushReplacementNamed(context, '/');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Неверный логин или пароль')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ошибка при проверке пользователя')),
          );
        }
      } else if (userType == 'admin') {
        final response = await http.get(Uri.parse('http://localhost:8080/UserAdmin/checkAdmin/$login/$password'));

        if (response.statusCode == 200) {
          final adminId = int.tryParse(response.body);
          if (adminId != null && adminId > 0) {
            // Авторизация администратора успешна, переходим на другую страницу
            UserDataProvider.of(context)?.userData.changeUserName(login);
            UserDataProvider.of(context)?.userData.changeUserStatus('admin');
            Navigator.pushReplacementNamed(context, '/ap'); // Замените на нужный маршрут
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Неверный логин или пароль')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ошибка при проверке администратора')),
          );
        }
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
        )
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ВОЙТИ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 30),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Логин',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите логин';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите пароль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _checkData('user'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF707070),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(250, 40),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Войти'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _checkData('admin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF707070),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(250, 40),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Войти как администратор'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Навигация на страницу "Забыли пароль?"
                },
                child: const Text('Забыли логин или пароль?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
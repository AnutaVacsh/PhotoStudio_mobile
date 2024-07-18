import 'package:flutter/material.dart';
import 'package:flutter_progect/user_data.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      UserDataProvider.of(context)?.userData.userStatus == 'guest' ? AppBar(
        backgroundColor: const Color(0xFF707070),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF707070),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Text('Зарегистрироваться'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF707070),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Text('Войти'),
            ),
          ],
        ),
      ) :
      AppBar(
        backgroundColor: const Color(0xFF707070),
        title: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${UserDataProvider.of(context)?.userData.userName}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/myBooking'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF707070),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Text('Мои брони'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 430,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'img/home1.jpg',
                    width: 150,
                    height: 146,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/hall'); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBC0204),
                            foregroundColor: Colors.white,
                            minimumSize:Size(300, 40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: const Text('Посмотреть интерьер'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/booking'); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7A0001),
                            foregroundColor: Colors.white,
                            minimumSize:Size(300, 40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: const Text('Забронировать студию'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/light'); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0042A5),
                            minimumSize:Size(300, 40),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: const Text('Аренда света'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/map'); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005EEB),
                            foregroundColor: Colors.white,
                            minimumSize:Size(300, 40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: const Text('Посмотреть адреса'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                'СТИЛЬНАЯ ФОТОСЕССИЯ В ФОТОСТУДИИ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 10),
              const Text(
                'Интерьеры студий выполнены в стиле лофт, модерн, прованс, неоклассика, минимализм, где используется дорогая и качественная мебель. Уникальные предметы интерьера и световые элементы в сочетании с абсолютной мобильностью декораций придадут индивидуальный характер вашей фотосессии.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Image.asset(
                    'img/home2.png', 
                    width: 120,
                    height: 150,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'img/home3.png', 
                    width: 120,
                    height: 150,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'img/home4.png', 
                    width: 120,
                    height: 150,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Image.asset(
                    'img/home5.png', 
                    width: 120,
                    height: 150,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'img/home6.png',
                    width: 120,
                    height: 150,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'img/home7.png',
                    width: 120,
                    height: 150,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
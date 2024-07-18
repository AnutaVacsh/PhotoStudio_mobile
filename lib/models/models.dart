class Booking {
  final int? id;
  final int? year;
  final int? month;
  final int? day;
  final int time;
  final int idHall;
  final int? idBack;
  final int idUser;
  final String state;
  final int? price;

  Booking({
    this.id,
    this.year,
    this.month,
    this.day,
    required this.time,
    required this.idHall,
    this.idBack,
    required this.idUser,
    required this.state,
    this.price,
  });

    factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      time: json['time'],
      idHall: json['idHall'],
      idBack: json['idBack'],
      idUser: json['idUser'],
      state: json['state'],
      price: json['price'],
    );
  }
}

class Hall {
  final int id;
  final String numberHall;
  final String? title;
  final String? description;
  final int priceDays;
  final int priceEnd;
  final String? img;
  final String? status;

  Hall({
    required this.id,
    required this.numberHall,
    this.title,
    this.description,
    required this.priceDays,
    required this.priceEnd,
    this.img,
    this.status
  });

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      id: json['id'], 
      numberHall: json['numberHall'], 
      title: json['title'],
      description: json['description'],
      priceDays: json['priceDays'],
      priceEnd: json['priceEnd'],
      img: json['img'],
      status: json['status'],
      );
  }
}

class Light {
  final int id;
  final String title;
  final String? description;
  final int price;
  final String? img;
  final String? status;

  Light({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.img,
    this.status,
  });
  
    factory Light.fromJson(Map<String, dynamic> json) {
    return Light(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      img: json['img'],
      status: json['status'],
    );
  }
}

class MyUser {
  final int? id;
  final String login;
  final String password;
  final String email;

  MyUser({
    this.id,
    required this.login,
    required this.password,
    required this.email,
  });
}

class UserAdmin {
  final int? id;
  final String login;
  final String password;

  UserAdmin({
    this.id,
    required this.login,
    required this.password,
  });
}
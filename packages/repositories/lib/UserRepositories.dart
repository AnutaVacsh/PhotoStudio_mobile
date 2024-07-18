import 'package:models/db_model.dart';
import 'package:servises/data_models/db.dart';
import 'package:servises/database.dart';

class UserRepositories{
  Future<void> addUser(UserModel user) async {
    await DBProvider.db.addUser(DBPhotoStudio(
      id: user.id, 
      name: user.title, 
      description: user.description, 
      imagePath: user.description,
    ));
  }
}
import '../../new_chat/data/models/user_model.dart';
import 'message_repository_models.dart';

abstract class MessageRepository {
  Future<UserModel> getUserContact({required UserInstance userInstance});
}

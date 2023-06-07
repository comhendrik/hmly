import 'package:pocketbase/pocketbase.dart';

void getSampleData() async {
  final pb = PocketBase('http://127.0.0.1:8090');


  final _ = await pb.collection('users').authWithPassword('test@test.com', '12345678');

  final result = await pb.collection('household').getOne('g7szpsys0r944se');

  final users = result.data['users'];

  users.forEach((id) async {
    final user =  await pb.collection('users').getOne(id);
    print(user.data['username']);
  });
}

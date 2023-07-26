import 'package:pocketbase/pocketbase.dart';

void getSampleData() async {
  final pb = PocketBase('http://127.0.0.1:8090');


  final _ = await pb.collection('users').authWithPassword('test@test.com', '12345678');



  try {
    final _ = await pb.collection('tasks').getFullList(filter: 'household="ehhmumqij2n1mmn"');

  } catch(err) {
    print(err);
  }
}

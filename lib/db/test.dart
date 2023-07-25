import 'package:pocketbase/pocketbase.dart';

void getSampleData() async {
  final pb = PocketBase('http://127.0.0.1:8090');


  final res = await pb.collection('users').authWithPassword('test@test.com', '12345678');
  print(res);
  print(res.runtimeType);


  try {
    final result = await pb.collection('tasks').getFullList(filter: 'household="ehhmumqij2n1mmn"');
    print(result);
    for (final task in result) {
      print(task.runtimeType);
    }
  } catch(err) {
    print(err);
    print("errror is catched");
  }
}

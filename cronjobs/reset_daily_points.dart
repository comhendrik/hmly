import 'package:cron/cron.dart';
import 'package:pocketbase/pocketbase.dart';

main() {
  final cron = Cron();
  final pb = PocketBase('http://127.0.0.1:8090');

  cron.schedule(Schedule.parse('0 0 * * *'), () async {
    int currentDayOfWeek = DateTime.now().weekday;
    final allPoints = await pb.collection("points").getFullList(filter: 'day_number=$currentDayOfWeek');
    for (final point in allPoints) {
      Map<String, dynamic> body = {
        "value" : 0
      };
      pb.collection("points").update(point.id, body: body);
    }
  });
}
import 'package:cron/cron.dart';

main() {
  final cron = Cron();

  cron.schedule(Schedule.parse('* * * * *'), () async {
    print('every  minute');
  });
}
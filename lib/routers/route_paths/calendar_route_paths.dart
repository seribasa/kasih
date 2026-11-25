import 'package:kasih/routers/models/route_model.dart';
import 'package:kasih/routers/route_paths/root_route_paths.dart';

class CalendarRoutePaths {
  static const RouteModel addCalendar = RouteModel(
    path: 'add',
    parent: RootRoutePaths.calendar,
  );

  static const RouteModel editCalendar = RouteModel(
    path: 'edit',
    parent: RootRoutePaths.calendar,
  );
}

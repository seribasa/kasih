import 'package:kasih/routers/models/route_model.dart';
import 'package:kasih/routers/route_paths/root_route_paths.dart';

class ProfileRoutePaths {
  static const RouteModel children = RouteModel(
    path: 'children',
    parent: RootRoutePaths.profile,
  );

  static const RouteModel addChildren = RouteModel(
    path: 'add',
    parent: children,
  );

  static const RouteModel editChildren = RouteModel(
    path: 'edit',
    parent: children,
  );
}

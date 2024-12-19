import 'package:vania/vania.dart';
import 'package:new_app/route/api_route.dart';
import 'package:new_app/route/web.dart';
import 'package:new_app/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiRoute().register();
    WebSocketRoute().register();
  }
}

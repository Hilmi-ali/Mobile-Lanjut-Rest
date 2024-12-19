import 'package:vania/vania.dart';
import 'package:new_app/app/http/controllers/product_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.post('/product', productController.store);
    Router.get('/product', productController.create);
    Router.put('/product', productController.update);
    Router.delete('/product', productController.destroy);
  }
}

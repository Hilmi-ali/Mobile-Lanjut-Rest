import 'package:vania/vania.dart';

class CreateProductTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('product', () {
      char('prod_id', length: 10, unique: true);
      primary('prod_id');
      string('vend_id', length: 5);
      string('prod_name', length: 25);
      string('prod_price', length: 11);
      text('prod_desc');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('product');
  }
}

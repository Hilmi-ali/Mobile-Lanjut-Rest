import 'package:vania/vania.dart';

class CreateCustomerTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('customer', () {
      char('ID', length: 5, unique: true);
      primary('ID');
      string('name', length: 50);
      string('address', length: 50);
      string('city', length: 20);
      string('state', length: 20);
      string('zip', length: 7);
      string('country', length: 20);
      string('telp', length: 15);
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('customer');
  }
}

import 'package:vania/vania.dart';
import 'package:new_app/app/models/product.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello Home'});
  }

  Future<Response> create(Request request) async {
    request.validate({
      'name': 'required',
      'description': 'required',
      'price': 'required',
    }, {
      'name.required': 'Nama produk wajib diisi.',
      'description.required': 'Deskripsi produk wajib diisi.',
      'price.required': 'Harga produk wajib diisi.',
    });
    try {
      final requestData = request.input();

      return Response.json({
        'message': 'Produk berhasil ditambahkan.',
        'data': requestData,
      }, 201);
    } catch (e) {
      // Return response error
      return Response.json({
        'message': 'Terjadi kesalahan pada server.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    //validasi
    try {
      request.validate({
        'name': 'required|string|max_length:100',
        'description': 'required string max_length:255',
        'price': 'required|numeric|min:0',
      }, {
        'name.required': 'Nama produk wajib diisi.',
        'name.string': 'Nama produk harus berupa teks.',
        'name.max_length': 'Nama produk maksimal 100 karakter.',
        'description.required': 'Deskripsi produk wajib diisi.',
        'description.string': 'Deskripsi produk harus berupa teks.',
        'description.max_length': 'Deskripsi produk maksimal 255 karakter.',
        'price.required': 'Harga produk wajib diisi.',
        'price.numeric': 'Harga produk harus berupa angka.',
        'price.min': 'Harga produk tidak boleh kurang dari 8.',
      });

      final productData = request.input();

      final existingProduct = await Product()
          .query()
          .where('name', '=', productData['name'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Produk dengan nama yang sama sudah ada.',
        }, 409);
      }

      productData['created_at'] = DateTime.now().toIso8601String();

      await Product().query().insert(productData);

      return Response.json({
        'message': 'Produk berhasil ditambahkan.',
        'data': productData,
      }, 201);
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagt nanti.',
        }, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    try {
      final listProudct = await Product().query().get();
      return Response.json({
        'message': 'Daftar Produk.',
        'data': listProudct,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'name': 'required|string|max_length:100',
        'description': 'required|string|max_length:255',
        'price': 'required|numeric|min:0',
      }, {
        'name.required': 'Nama produk wajib diisi.',
        'name.string': 'Nama produk harus berupa teks.',
        'name.max_length': 'Nama produk maksimal 100 karakter.',
        'description.required': 'Deskripsi produk wajib diisi.',
        'description.string': 'Deskripsi produk harus berupa teks.',
        'description.max_length': 'Deskripsi produk maksimal 255 karakter.',
        'price.required': 'Harga produk wajib diisi.',
        'price.numeric': 'Harga produk harus berupa angka.',
        'price.min': 'Harga produk tidak boleh kurang dari 0.',
      });

      //ambil input data produk yang akan diupdate
      final productData = request.input();
      productData['updated_at'] = DateTime.now().toIso8601String();

      //mencari produk berdasarkan ID
      final product = await Product().query().where('id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      //update data produk
      await Product().query().where('id', '=', id).update(productData);

      return Response.json({
        'message': 'Produk berhasil diupdate.',
        'data': productData,
      }, 200);
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        }, 500);
      }
    }
  }

  Future<Response> destroy(int id) async {
    try {
      //mencari produk berdasarkan ID
      final product = await Product().query().where('id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      //hapus produk
      await Product().query().where('id', '=', id).delete();
      return Response.json({
        'message': 'Produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus produk.',
      }, 500);
    }
  }
}

final ProductController productController = ProductController();

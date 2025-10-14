import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/data/product_repo.dart';
import '../../home/model/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo productRepo;

  ProductCubit(this.productRepo) : super(ProductInitial());

  Future<void> loadProducts() async {
    try {
      emit(ProductLoading());
      final products = await productRepo.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

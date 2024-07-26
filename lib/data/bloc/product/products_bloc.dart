import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_2/data/bloc/product/products_state.dart';

import '../../services/product/product_repository.dart';
import 'products_event.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository _cartProductRepository;

  ProductsBloc(this._cartProductRepository) : super(ProductsLoadingState()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(ProductsLoadingState());
      try {
        final products = await _cartProductRepository.getProducts();
        emit(ProductsLoadedState(products));
      } catch (e) {
        emit(ProductsErrorState(e.toString()));
      }
    });
  }
}

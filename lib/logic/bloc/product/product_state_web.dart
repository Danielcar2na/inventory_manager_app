part of 'product_bloc_web.dart';

abstract class ProductStateWeb extends Equatable {
  const ProductStateWeb();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductStateWeb {}

class ProductLoading extends ProductStateWeb {}

class ProductLoaded extends ProductStateWeb {
  final List<ProductModel> products;

  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductStateWeb {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

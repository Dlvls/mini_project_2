import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_2/data/services/cart/cart_repository.dart';
import 'package:mini_project_2/data/services/product/product_repository.dart';
import 'package:mini_project_2/resources/colors.dart';
import 'package:mini_project_2/resources/styles.dart';
import 'package:mini_project_2/utility/checkbox.dart';

import '../data/bloc/cart/cart_bloc.dart';
import '../data/bloc/cart/cart_event.dart';
import '../data/bloc/cart/cart_state.dart';
import '../data/bloc/product/products_bloc.dart';
import '../data/bloc/product/products_event.dart';
import '../data/bloc/product/products_state.dart';
import '../data/models/cart/cart_model.dart';
import '../data/models/cart/quantity_cart_model.dart';
import '../data/models/product/product_model.dart';
import '../utility/counter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<int, bool> _checkedItems = {};
  double _totalPrice = 0.0;

  void _onItemChecked(
      int productId, bool isChecked, double productPrice, int quantity) {
    setState(() {
      _checkedItems[productId] = isChecked;
      if (isChecked) {
        _totalPrice += productPrice * quantity;
      } else {
        _totalPrice -= productPrice * quantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (BuildContext context) =>
              CartBloc(CartRepository())..add(LoadCartEvent()),
        ),
        BlocProvider<ProductsBloc>(
          create: (BuildContext context) =>
              ProductsBloc(ProductRepository())..add(LoadProductsEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Cart',
            style: Styles.appbarText.copyWith(color: primaryText),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<CartBloc, CartState>(
                    listener: (context, state) {
                      if (state is CartErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Failed to load cart: ${state.error}')),
                        );
                      }
                    },
                  ),
                  BlocListener<ProductsBloc, ProductsState>(
                    listener: (context, state) {
                      if (state is ProductsErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Failed to load products: ${state.error}')),
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    if (cartState is CartLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (cartState is CartErrorState) {
                      return const Center(child: Text("Error"));
                    }
                    if (cartState is CartLoadedState) {
                      const int specificCartId = 2;
                      final cart = cartState.carts.firstWhere(
                        (cart) => cart.id == specificCartId,
                        orElse: () => Cart(
                          id: 0,
                          userId: 0,
                          date: DateTime.now(),
                          products: [],
                        ),
                      );

                      if (cart.id == 0) {
                        return const Center(child: Text("Cart not found"));
                      }

                      return BlocBuilder<ProductsBloc, ProductsState>(
                        builder: (context, productState) {
                          if (productState is ProductsLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (productState is ProductsErrorState) {
                            return const Center(
                                child: Text("Error loading products"));
                          }
                          if (productState is ProductsLoadedState) {
                            List<ProductQuantity> quantity = cart.products;

                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: quantity.length,
                                    itemBuilder: (context, index) {
                                      ProductQuantity cartProduct =
                                          quantity[index];
                                      final product =
                                          productState.products.firstWhere(
                                        (prod) =>
                                            prod.id == cartProduct.productId,
                                        orElse: () => const ProductModel(
                                          id: 0,
                                          title: 'Unknown',
                                          price: 0.0,
                                          description: '',
                                          category: '',
                                          image: '',
                                          rating:
                                              RatingCart(rate: 0.0, count: 0),
                                        ),
                                      );

                                      return ListTile(
                                        title: DefaultTextStyle(
                                          style: Styles.title
                                              .copyWith(color: primaryText),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CheckboxApp(
                                                onChanged: (isChecked) {
                                                  _onItemChecked(
                                                    cartProduct.productId,
                                                    isChecked,
                                                    product.price,
                                                    cartProduct.quantity,
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              // Add some space between the two containers
                                              Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: product
                                                          .image.isNotEmpty
                                                      ? Image.network(
                                                          product.image,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : Image.asset(
                                                          "assets/images/shirt.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // Add space between the image container and text
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(product.title,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(height: 8),
                                                    Text(product.category,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '\$${product.price}',
                                                            style: const TextStyle(
                                                                color:
                                                                    primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                        const Spacer(),
                                                        // Takes up the remaining space
                                                        CounterWidget(
                                                            initialQuantity:
                                                                cartProduct
                                                                    .quantity),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Total Price',
                                            style: Styles.title.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: secondaryText,
                                            ),
                                          ),
                                          Text(
                                            '\$${_totalPrice.toStringAsFixed(2)}',
                                            style: Styles.title.copyWith(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context.push('/checkout',
                                                extra: _totalPrice);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            minimumSize:
                                                const Size(double.infinity, 45),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            'Checkout',
                                            style: Styles.title
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Center(
                              child: Text("Failed to load products"));
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

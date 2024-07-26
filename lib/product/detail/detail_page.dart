import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/bloc/product/products_bloc.dart';
import '../../data/bloc/product/products_state.dart';
import '../../data/models/product/product_model.dart';
import '../../resources/colors.dart';
import '../../resources/styles.dart';

class DetailPage extends StatelessWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: primaryText,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/cart');
            },
            icon: const Icon(Icons.shopping_cart),
            color: primaryText,
          ),
          PopupMenuTheme(
            data: const PopupMenuThemeData(
              color: secondaryColor,
              textStyle: TextStyle(color: primaryText),
            ),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'profile') {
                  context.push('/profile');
                }
              },
              icon: const Icon(Icons.more_vert),
              color: secondaryColor,
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Text(
                    'Profile',
                    style: Styles.title.copyWith(color: primaryText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: secondaryColor,
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsLoadedState) {
              final product = state.products
                  .firstWhere((product) => product.id == productId);
              return _buildProductDetail(product);
            } else if (state is ProductsErrorState) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductDetail(ProductModel product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Image.network(
              product.image,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Text(product.title, style: Styles.appbarText),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Row(
              children: [
                Text(
                  product.rating.rate.toString(),
                  style: Styles.title,
                ),
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8.0),
                Text(
                  '|',
                  style: Styles.title,
                ),
                const SizedBox(width: 8.0),
                Text(
                  '${product.rating.count} Sold',
                  style: Styles.title,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            product.description,
            style: Styles.title.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 32),
          Text(
            '\$${product.price}',
            style: Styles.appbarText.copyWith(
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        context.push('/checkout');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Buy',
                        style: Styles.title.copyWith(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0), // Space between buttons
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      context.push('/cart');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../data/bloc/product/products_bloc.dart';
import '../data/bloc/product/products_state.dart';
import '../data/models/product/product_model.dart';

class PopularProduct extends StatelessWidget {
  const PopularProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsLoadedState) {
          List<ProductModel> popularProducts =
              _filterPopularProducts(state.products);
          return _buildContent(context, popularProducts);
        } else if (state is ProductsErrorState) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }

  List<ProductModel> _filterPopularProducts(List<ProductModel> products) {
    return products.where((product) => product.rating.rate >= 4).toList();
  }

  Widget _buildContent(BuildContext context, List<ProductModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular',
          style: Styles.title
              .copyWith(fontWeight: FontWeight.w600, color: secondaryText),
        ),
        const SizedBox(
          height: 16,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return _buildGridItem(context, products[index]);
          },
          itemCount: products.length,
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, ProductModel product) {
    return InkWell(
      onTap: () {
        // Navigate to the detail page with the product ID
        context.push('/detail/${product.id}');
      },
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(40.0),
              ),
            ),
            child: Center(
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                width: 150.0,
                height: 150.0,
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            top: 16.0,
            right: 16.0,
            child: Text(
              product.title,
              style: Styles.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: Text(
              '\$${product.price}',
              style: Styles.title,
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: primaryText,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(40.0),
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                ),
              ),
              child: const Icon(
                Icons.navigate_next,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trucky/presentation/products/provider/product_provider.dart';

/// Simple products screen backed by [productsProvider] (Riverpod).
class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          _SummaryCard(total: products.length),
          Expanded(
            child: products.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _ProductTile(
                        product: product,
                        onDelete: () => ref
                            .read(productsProvider.notifier)
                            .remove(product.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(productsProvider.notifier).add(),
        tooltip: 'Add product',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.inventory_2),
        title: const Text('Total products'),
        trailing: Text(
          '$total',
          style: theme.textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.onDelete});

  final Product product;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(product.name[0])),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64),
          SizedBox(height: 12),
          Text('No products yet'),
          Text('Tap + to add one'),
        ],
      ),
    );
  }
}

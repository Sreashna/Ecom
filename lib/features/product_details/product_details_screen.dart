import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/product.dart';
import '../../domain/models/review.dart';
import 'product_details_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blue = Colors.blue;
    return ChangeNotifierProvider<ProductDetailsProvider>(
      create: (_) => ProductDetailsProvider(
        repo: Provider.of(context, listen: false),
        product: product,
      )..fetchReviews(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: blue.shade700,
          title: Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Consumer<ProductDetailsProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https://picsum.photos/600/300?random=${product.id}",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.title,
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      product.body,
                      style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Reviews",
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    provider.reviews.isEmpty
                        ? Center(
                      child: Text(
                        'No reviews yet.',
                        style: TextStyle(color: blue.shade300),
                      ),
                    )
                        : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.reviews.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final review = provider.reviews[index];
                        return Card(
                          color: blue.shade50,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.name,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: blue.shade700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  review.body,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    AddReviewSection(productDetailsProvider: provider),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AddReviewSection extends StatefulWidget {
  final ProductDetailsProvider productDetailsProvider;
  const AddReviewSection({Key? key, required this.productDetailsProvider}) : super(key: key);

  @override
  _AddReviewSectionState createState() => _AddReviewSectionState();
}

class _AddReviewSectionState extends State<AddReviewSection> {
  final _nameController = TextEditingController();
  final _bodyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitReview() {
    if (!_formKey.currentState!.validate()) return;

    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch,
      postId: widget.productDetailsProvider.product.id,
      name: _nameController.text.trim(),
      body: _bodyController.text.trim(),
    );

    widget.productDetailsProvider.addReview(newReview);

    _nameController.clear();
    _bodyController.clear();

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Review added")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blue = Colors.blue;
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add a Review",
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: blue.shade700,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  labelStyle: TextStyle(color: blue.shade400),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blue.shade700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blue.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: "Your Review",
                  labelStyle: TextStyle(color: blue.shade400),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blue.shade700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blue.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Please enter a review' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _submitReview,
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

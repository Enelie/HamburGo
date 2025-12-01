import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final reviews = app.repo.getReviews();
    return Scaffold(
      appBar: AppBar(title: const Text('Reseñas')),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (c,i) {
          final r = reviews[i];
          return ListTile(
            title: Text('⭐ ${r.rating}'),
            subtitle: Text(r.comment),
            trailing: Text(r.date.toLocal().toString().split(' ').first),
          );
        },
      ),
    );
  }
}

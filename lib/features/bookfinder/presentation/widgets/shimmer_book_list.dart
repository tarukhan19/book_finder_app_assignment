
import 'package:book_finder_app_assignment/features/bookfinder/presentation/widgets/shimmer_book_item.dart';
import 'package:flutter/cupertino.dart';

class ShimmerLoadingList extends StatelessWidget {
  final int itemCount;

  const ShimmerLoadingList({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ShimmerBookItem();
      },
    );
  }
}
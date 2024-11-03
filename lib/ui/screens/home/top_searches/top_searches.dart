import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/publication_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/home/top_searches/top_searches_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class TopSearches extends StatefulWidget {
  const TopSearches({super.key});

  @override
  State<TopSearches> createState() => _TopSearchesState();
}

class _TopSearchesState extends State<TopSearches> {
  late TopSearchesViewModel viewModel;
  late Future? myFuture;
  List<PublicationModel> _searches = [];

  @override
  void initState() {
    viewModel = Provider.of<TopSearchesViewModel>(context, listen: false);
    myFuture = _fetchItems();
    super.initState();
  }

  _fetchItems() async {
    TopPublicationState state = await viewModel.fetchTopPublications();
    if (state.isSuccess) {
      setState(() {
        _searches = state.publications;
      });
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingView());
          } else if (snapshot.hasData) {
            return _searches.isEmpty
                ? const EmptyViewElement()
                : ListView.builder(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _searches.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _searches[index];

                      return PublicationItem(
                        isVerticalItem: false,
                        model: item,
                        onClick: () {
                          Provider.of<PublicationDetailViewModel>(context,
                                  listen: false)
                              .setCurrentPublication(item);
                          context.pushNamed(publicationDetail, extra: item);
                        },
                      );
                    },
                  );
            // return const Text('Data has been got');
          } else if (snapshot.hasError) {
            return Text(context.localized.errorOccurred);
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

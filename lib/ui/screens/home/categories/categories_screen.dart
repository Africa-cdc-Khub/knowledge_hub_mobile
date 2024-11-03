import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/resource_model.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/home/categories/categories_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/publications_list_screen.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late CategoriesViewModel viewModel;
  late Future? myFuture;
  List<ResourceTypeModel> _categories = [];

  @override
  void initState() {
    viewModel = Provider.of<CategoriesViewModel>(context, listen: false);
    myFuture = _fetchItems();
    super.initState();
  }

  _fetchItems() async {
    CategoriesState state = await viewModel.getCategories();
    if (state.isSuccess) {
      setState(() {
        _categories = state.categories;
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
            return _categories.isEmpty
                ? const EmptyViewElement()
                : ListView.builder(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _categories[index];

                      return InkWell(
                        onTap: () => _onCategorySelected(item),
                        child: SizedBox(
                          width: 140,
                          child: Card(
                            elevation: 0,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.categoryName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
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

  _onCategorySelected(ResourceTypeModel item) {
    context.pushNamed(publicationList,
        extra: PublicationListScreenState(
            listType: 3, title: item.categoryName, categoryId: item.id));
  }
}

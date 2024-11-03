import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/search_type_enum.dart';
import 'package:khub_mobile/ui/screens/search/search_screen.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';

class AppSearchBar extends StatelessWidget {
  final SearchType searchType;

  const AppSearchBar({super.key, required this.searchType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          context.pushNamed(search,
              extra: SearchScreenState(searchType: searchType, target: 1));
        },
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.localized.search,
                      style: const TextStyle(color: Colors.grey)),
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

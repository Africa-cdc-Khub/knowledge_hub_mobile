import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khub_mobile/models/preference_model.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/preferences/preferences_search_view_model.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PreferencesListSearch extends StatefulWidget {
  final void Function(PreferenceModel)? onPreferenceSelected;

  const PreferencesListSearch({super.key, this.onPreferenceSelected});

  @override
  State<PreferencesListSearch> createState() => _PreferencesListSearchState();
}

class _PreferencesListSearchState extends State<PreferencesListSearch> {
  final TextEditingController _searchController = TextEditingController();
  final _searchStreamController = StreamController<String>();
  late PreferencesSearchViewModel preferencesViewModel;

  @override
  void initState() {
    preferencesViewModel =
        Provider.of<PreferencesSearchViewModel>(context, listen: false);
    preferencesViewModel.fetchInitialPreferences();

    // Listen to the stream with debounce
    _searchStreamController.stream
        .debounceTime(
            const Duration(milliseconds: 500)) // Use RxDart's debounceTime
        .listen((searchQuery) {
      preferencesViewModel.searchPreferences(searchQuery);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            EditTextField(
              textHint: context.localized.search,
              textController: _searchController,
              borderRadius: 8,
              onChanged: (value) {
                if (value != null) {
                  _searchStreamController.add(value); // Add value to the stream
                }
              },
            ),
            Expanded(
              child: Consumer<PreferencesSearchViewModel>(
                  builder: (context, provider, child) {
                if (provider.state.list.isEmpty) {
                  return Center(
                      child: EmptyViewElement(
                          message: context.localized.noRecordsFound));
                }

                return ListView.builder(
                  itemCount: provider.state.list.length,
                  itemBuilder: (context, index) {
                    final preference = provider.state.list[index];

                    return InkWell(
                      onTap: () {
                        if (widget.onPreferenceSelected != null) {
                          widget.onPreferenceSelected!(preference);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 12),
                        child: Text(preference.name),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ));
  }
}

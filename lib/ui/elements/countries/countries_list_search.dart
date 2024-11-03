import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/ui/elements/countries/countries_search_view_model.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class CountriesListSearch extends StatefulWidget {
  final void Function(CountryModel)? onCountrySelected;

  const CountriesListSearch({super.key, this.onCountrySelected});

  @override
  State<CountriesListSearch> createState() => _CountriesListSearchState();
}

class _CountriesListSearchState extends State<CountriesListSearch> {
  final TextEditingController _searchController = TextEditingController();
  final _searchStreamController = StreamController<String>();
  late CountriesSearchViewModel countriesViewModel;

  @override
  void initState() {
    countriesViewModel =
        Provider.of<CountriesSearchViewModel>(context, listen: false);
    countriesViewModel.fetchInitialCountries();

    // Listen to the stream with debounce
    _searchStreamController.stream
        .debounceTime(
            const Duration(milliseconds: 500)) // Use RxDart's debounceTime
        .listen((searchQuery) {
      countriesViewModel.searchCountries(searchQuery);
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
              child: Consumer<CountriesSearchViewModel>(
                  builder: (context, provider, child) {
                if (provider.state.list.isEmpty) {
                  return Center(
                      child: EmptyViewElement(
                          message: context.localized.noCountriesFound));
                }

                return ListView.builder(
                  itemCount: provider.state.list.length,
                  itemBuilder: (context, index) {
                    final country = provider.state.list[index];

                    return InkWell(
                      onTap: () {
                        if (widget.onCountrySelected != null) {
                          widget.onCountrySelected!(country);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 12),
                        child: Text(country.name),
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

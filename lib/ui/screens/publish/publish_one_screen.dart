import 'package:flutter/material.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/countries/countries_list_search.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/dropdowns/custom_card_dropdown.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/ui/screens/publish/publish_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/validator.dart';
import 'package:provider/provider.dart';

class PublishOneScreen extends StatefulWidget {
  final Function() onNext;

  const PublishOneScreen({super.key, required this.onNext});

  @override
  State<PublishOneScreen> createState() => _PublishOneScreenState();
}

class _PublishOneScreenState extends State<PublishOneScreen> {
  final _publishOneFormKey = GlobalKey<FormState>();
  late PublishViewModel viewModel;

  late TextEditingController _titleController;
  OptionItemModel? _selectedCountry;
  String _errors = '';

  @override
  void initState() {
    viewModel = Provider.of<PublishViewModel>(context, listen: false);
    _titleController =
        TextEditingController(text: viewModel.state.publicationRequest.title);

    if (viewModel.state.publicationRequest.country != null) {
      setState(() {
        _selectedCountry = viewModel.state.publicationRequest.country;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _publishOneFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Consumer<PublishViewModel>(
                      builder: (context, publishProvider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localized.startHere,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                        ySpacer(16),
                        editTextLabel(context.localized.title),
                        EditTextField(
                          textController: _titleController,
                          validator: (value) {
                            return Validator.required(value);
                          },
                        ),
                        ySpacer(16),
                        editTextLabel(context.localized.memberState),
                        CustomCardDropdown(
                          containerColor: MainTheme.appColors.onPrimary,
                          onTap: () {
                            _showCountries();
                          },
                          value: _selectedCountry?.name ?? '',
                        ),
                        _errors.isNotEmpty
                            ? Column(
                                children: [
                                  ySpacer(14),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(_errors,
                                        style: TextStyle(
                                            color: MainTheme.appColors.red400,
                                            fontSize: 14)),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: MediaQuery.of(context).size.width / 2,
                      onPressed: () {
                        if (_publishOneFormKey.currentState?.validate() ??
                            false) {
                          if (_selectedCountry == null) {
                            setState(() {
                              _errors = context.localized.pleaseSelectACountry;
                            });
                          } else {
                            viewModel.setRequest(
                              title: _titleController.text,
                              country: _selectedCountry,
                            );
                            widget.onNext();
                          }
                        }
                      },
                      child: Text(
                        context.localized.next,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountries() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: CountriesListSearch(
                onCountrySelected: (CountryModel country) {
                  setState(() {
                    _selectedCountry =
                        OptionItemModel(country.id.toString(), country.name);
                  });
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}

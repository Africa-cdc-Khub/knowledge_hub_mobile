import 'package:flutter/material.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/models/resource_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/dropdowns/custom_drop_down.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/publish/publish_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/validator.dart';
import 'package:provider/provider.dart';

class PublishTwoScreen extends StatefulWidget {
  final Function() onNext;
  final Function() onBack;

  const PublishTwoScreen(
      {super.key, required this.onNext, required this.onBack});

  @override
  State<PublishTwoScreen> createState() => _PublishTwoScreenState();
}

class _PublishTwoScreenState extends State<PublishTwoScreen> {
  final _publishTwoFormKey = GlobalKey<FormState>();
  late TextEditingController _linkController;
  late PublishViewModel viewModel;
  List<ResourceTypeModel> _resourceTypes = [];
  List<ResourceCategoryModel> _resourceCategories = [];
  OptionItemModel? _selectedResourceType;
  OptionItemModel? _selectedResourceCategory;
  OptionItemModel? _selectedTheme;
  OptionItemModel? _selectedSubTheme;
  String _errors = '';

  _onThemeSelected(String themeId) {
    viewModel.fetchSubThemes(themeId: int.parse(themeId));
  }

  @override
  void initState() {
    viewModel = Provider.of<PublishViewModel>(context, listen: false);
    _fetchResourceTypes();
    _fetchResourceCategories();

    _linkController =
        TextEditingController(text: viewModel.state.publicationRequest.link);

    if (viewModel.state.publicationRequest.theme != null) {
      setState(() {
        _selectedTheme = viewModel.state.publicationRequest.theme;
      });
    }

    if (viewModel.state.publicationRequest.subTheme != null) {
      setState(() {
        _selectedSubTheme = viewModel.state.publicationRequest.subTheme;
      });
    }

    if (viewModel.state.publicationRequest.resourceType != null) {
      setState(() {
        _selectedResourceType = viewModel.state.publicationRequest.resourceType;
      });
    }

    if (viewModel.state.publicationRequest.resourceCategory != null) {
      setState(() {
        _selectedResourceCategory =
            viewModel.state.publicationRequest.resourceCategory;
      });
    }

    super.initState();
  }

  Future<void> _fetchResourceTypes() async {
    final resourceTypes =
        await Provider.of<MainViewModel>(context, listen: false)
            .getResourceTypes();
    setState(() {
      _resourceTypes = resourceTypes;
    });
  }

  Future<void> _fetchResourceCategories() async {
    final resourceCategories =
        await Provider.of<MainViewModel>(context, listen: false)
            .getResourceCategories();
    setState(() {
      _resourceCategories = resourceCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Form(
              key: _publishTwoFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Consumer<PublishViewModel>(
                  builder: (context, publishProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localized.resourceCategorization,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    ySpacer(16),
                    editTextLabel(context.localized.resourceType),
                    _resourceTypes.isNotEmpty
                        ? CustomDropDown(
                            options: _resourceTypes
                                .map((item) => OptionItemModel(
                                    item.id.toString(), item.categoryName))
                                .toList(),
                            initialSelectedItem: publishProvider
                                .state.publicationRequest.resourceType,
                            onItemSelected: (item) {
                              setState(() {
                                _selectedResourceType = item;
                              });
                            })
                        : const SizedBox.shrink(),
                    ySpacer(16),
                    editTextLabel(context.localized.resourceCategory),
                    _resourceCategories.isNotEmpty
                        ? CustomDropDown(
                            options: _resourceCategories
                                .map((item) => OptionItemModel(
                                    item.id.toString(), item.categoryName))
                                .toList(),
                            initialSelectedItem: publishProvider
                                .state.publicationRequest.resourceCategory,
                            onItemSelected: (item) {
                              setState(() {
                                _selectedResourceCategory = item;
                              });
                            })
                        : const SizedBox.shrink(),
                    ySpacer(16),
                    editTextLabel(context.localized.thematicArea),
                    Consumer<PublishViewModel>(
                        builder: (context, provider, child) {
                      if (provider.state.themeList.isNotEmpty) {
                        return CustomDropDown(
                            options: provider.state.themeList,
                            initialSelectedItem:
                                publishProvider.state.publicationRequest.theme,
                            onItemSelected: (item) {
                              setState(() {
                                _selectedTheme = item;
                              });
                              _onThemeSelected(item.id);
                            });
                      }

                      return const SizedBox.shrink();
                    }),
                    ySpacer(16),
                    editTextLabel(context.localized.subTheme),
                    Consumer<PublishViewModel>(
                        builder: (context, provider, child) {
                      if (provider.state.subThemeList.isNotEmpty) {
                        return CustomDropDown(
                            options: provider.state.subThemeList,
                            initialSelectedItem: publishProvider
                                .state.publicationRequest.subTheme,
                            onItemSelected: (item) {
                              setState(() {
                                _selectedSubTheme = item;
                              });
                            });
                      }

                      return const SizedBox.shrink();
                    }),
                    ySpacer(16),
                    editTextLabel(context.localized.publicationURL),
                    EditTextField(
                      textController: _linkController,
                      validator: (value) {
                        return Validator.required(value);
                      },
                    ),
                    ySpacer(5),
                    _errors.isNotEmpty
                        ? Column(
                            children: [
                              ySpacer(14),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                        onPressed: () {
                          widget.onBack();
                        },
                        containerColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        child: Text(
                          context.localized.previous,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                  ),
                  xSpacer(10),
                  Expanded(
                    child: CustomButton(
                        onPressed: () {
                          _validate();
                        },
                        child: Text(
                          context.localized.next,
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _validate() {
    if (_publishTwoFormKey.currentState?.validate() ?? false) {
      if (_selectedResourceType == null) {
        setState(() {
          _errors = context.localized.selectAResourceType;
        });
      } else if (_selectedTheme == null) {
        setState(() {
          _errors = context.localized.selectATheme;
        });
      } else if (_selectedSubTheme == null) {
        setState(() {
          _errors = context.localized.selectASubTheme;
        });
      } else {
        viewModel.setRequest(
          resourceType: _selectedResourceType,
          resourceCategory: _selectedResourceCategory,
          theme: _selectedTheme,
          subTheme: _selectedSubTheme,
          link: _linkController.text,
        );
        widget.onNext();
      }
    }
  }
}

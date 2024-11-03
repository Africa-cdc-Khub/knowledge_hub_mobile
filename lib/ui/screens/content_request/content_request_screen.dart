import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/dialogs/success_dialog.dart';
import 'package:khub_mobile/ui/elements/dropdowns/custom_drop_down.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/content_request/content_request_view_model.dart';
import 'package:khub_mobile/utils/alert_utils.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:khub_mobile/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class ContentRequestScreen extends StatefulWidget {
  const ContentRequestScreen({super.key});

  @override
  State<ContentRequestScreen> createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<ContentRequestScreen> {
  late ContentRequestViewModel viewModel;
  late AuthViewModel authViewModel;

  List<CountryModel> _countries = [];
  OptionItemModel? _selectedCountry;
  String _errors = '';
  String _countryError = '';
  bool _loading = false;
  late TextEditingController _emailController;
  late TextEditingController _titleController;
  late QuillEditorController _detailsController;
  final _contentRequestFormKey = GlobalKey<FormState>();

  // Rich editor toolbar options
  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal);
  final _hintTextStyle = const TextStyle(
      fontSize: 16, color: Colors.black38, fontWeight: FontWeight.normal);

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ContentRequestViewModel>(context, listen: false);
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    _emailController = TextEditingController();
    _titleController = TextEditingController();
    _detailsController = QuillEditorController();

    _getCountries();
    authViewModel.checkLoginStatus();
  }

  Future<void> _getCountries() async {
    final countries =
        await Provider.of<MainViewModel>(context, listen: false).getCountries();
    setState(() {
      _countries = countries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: Text(
          context.localized.contentRequest,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MainTheme.appColors.white200,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _contentRequestFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.localized.submitAContentRequest,
                          style: const TextStyle(color: Colors.grey)),
                      ySpacer(18),
                      Consumer<AuthViewModel>(
                        builder: (context, provider, child) {
                          if (!provider.state.isLoggedIn) {
                            return Builder(builder: (context) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  editTextLabel(context.localized.email),
                                  EditTextField(
                                    textController: _emailController,
                                    validator: (value) {
                                      return Validator.validateEmail(value);
                                    },
                                  ),
                                ],
                              );
                            });
                          }
                          return const SizedBox();
                        },
                      ),
                      _countries.isNotEmpty
                          ? Consumer<AuthViewModel>(
                              builder: (context, provider, child) {
                                if (!provider.state.isLoggedIn) {
                                  return Builder(builder: (context) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        editTextLabel(
                                            context.localized.country),
                                        CustomDropDown(
                                            options: _countries
                                                .map((item) => OptionItemModel(
                                                    item.id.toString(),
                                                    item.name))
                                                .toList(),
                                            initialSelectedItem:
                                                _selectedCountry,
                                            onItemSelected: (item) {
                                              setState(() {
                                                _countryError = '';
                                                _selectedCountry = item;
                                              });
                                            }),
                                        _countryError.isNotEmpty
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: Text(_countryError,
                                                    style: TextStyle(
                                                        color: MainTheme
                                                            .appColors.red400,
                                                        fontSize: 14)),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    );
                                  });
                                }
                                return const SizedBox();
                              },
                            )
                          : const SizedBox.shrink(),
                      ySpacer(14),
                      editTextLabel(context.localized.subject),
                      EditTextField(
                        textController: _titleController,
                        validator: (value) {
                          return Validator.required(value);
                        },
                      ),
                      ySpacer(14),
                      editTextLabel(context.localized.details),
                      _editorToolbar(context),
                      ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 400.0),
                          child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: MainTheme.appColors.white900,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0))),
                              child: _richTextEditor(context))),
                      ySpacer(4),
                      _errors.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(_errors,
                                  style: TextStyle(
                                      color: MainTheme.appColors.red400,
                                      fontSize: 14)),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: MainTheme.appColors.white900,
                  child: CustomButton(
                    onPressed: () {
                      _validate();
                    },
                    loading: _loading,
                    child: Text(
                      context.localized.submit,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _validate() async {
    if (_contentRequestFormKey.currentState?.validate() ?? false) {
      String htmlText = await _detailsController.getText();

      if (!authViewModel.state.isLoggedIn && _selectedCountry == null) {
        setState(() {
          _countryError = context.localized.pleaseSelectACountry;
        });
      } else if (htmlText.isEmpty) {
        setState(() {
          _errors = context.localized.addDetails;
        });
      } else {
        _submit();
      }
    }
  }

  void _submit() async {
    String htmlText = await _detailsController.getText();
    setState(() {
      _loading = true;
    });

    final state = await viewModel.submitRequest(
      title: _titleController.text,
      description: htmlText,
      countryId:
          _selectedCountry != null ? int.parse(_selectedCountry!.id) : null,
      email: _emailController.text.isNotEmpty ? _emailController.text : null,
    );

    setState(() {
      _loading = false;
    });

    if (!state.isSuccess && mounted) {
      AlertUtils.showError(context: context, errorMessage: state.errorMessage);
    } else if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SuccessDialog(
          title: context.localized.success,
          message: context.localized.contentRequestSubmittedSuccessfully,
          onOkPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            context.go('/$account'); // Navigate to the forums page
          },
        ),
      );
    }
  }

  Widget _richTextEditor(BuildContext context) {
    return QuillHtmlEditor(
      controller: _detailsController,
      isEnabled: true,
      ensureVisible: true,
      minHeight: 500,
      autoFocus: false,
      textStyle: _editorTextStyle,
      hintTextStyle: _hintTextStyle,
      hintTextAlign: TextAlign.start,
      padding: const EdgeInsets.only(top: 10),
      hintTextPadding: const EdgeInsets.only(left: 20),
      backgroundColor: _backgroundColor,
      inputAction: InputAction.newline,
      loadingBuilder: (context) {
        return const Center(child: LoadingView());
      },
    );
  }

  Widget _editorToolbar(BuildContext context) {
    return ToolBar(
      toolBarColor: _toolbarColor,
      padding: const EdgeInsets.all(4),
      iconSize: 25,
      iconColor: _toolbarIconColor,
      activeIconColor: Theme.of(context).primaryColor,
      controller: _detailsController,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      customButtons: const [],
    );
  }
}

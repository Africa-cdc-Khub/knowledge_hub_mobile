import 'package:flutter/material.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/screens/publish/publish_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class PublishThreeScreen extends StatefulWidget {
  final Function() onNext;
  final Function() onBack;

  const PublishThreeScreen(
      {super.key, required this.onNext, required this.onBack});

  @override
  State<PublishThreeScreen> createState() => _PublishThreeScreenState();
}

class _PublishThreeScreenState extends State<PublishThreeScreen> {
  late QuillEditorController _controller;
  final _publishThreeFormKey = GlobalKey<FormState>();
  late PublishViewModel viewModel;
  String _errors = '';
  String _defaultDesc = '';

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
      fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal);
  final _hintTextStyle = const TextStyle(
      fontSize: 14, color: Colors.black38, fontWeight: FontWeight.normal);

  @override
  void initState() {
    viewModel = Provider.of<PublishViewModel>(context, listen: false);
    if (viewModel.state.publicationRequest.description != null) {
      _controller = QuillEditorController();
      _setHtmlText(viewModel.state.publicationRequest.description!);
      setState(() {
        _defaultDesc = viewModel.state.publicationRequest.description!;
      });
    } else {
      _controller = QuillEditorController();
    }
    super.initState();
  }

  void _setHtmlText(String text) async {
    LOGGER.d(text);
    await _controller.setText(text);
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
            child: Consumer<PublishViewModel>(
                builder: (context, publishProvider, child) {
              return Form(
                key: _publishThreeFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localized.publicationInfo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    ySpacer(16),
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
                ),
              );
            }),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 16.0),
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

  void _validate() async {
    if (_publishThreeFormKey.currentState?.validate() ?? false) {
      String htmlText = await _controller.getText();

      if (htmlText.isEmpty) {
        setState(() {
          _errors = context.localized.addPublicationInfo;
        });
      } else {
        viewModel.setRequest(description: htmlText);
        widget.onNext();
      }
    }
  }

  Widget _richTextEditor(BuildContext context) {
    return QuillHtmlEditor(
      text: _defaultDesc,
      hintText: '',
      controller: _controller,
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
      controller: _controller,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      customButtons: const [],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/search_type_enum.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/publication_compare_chooser.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/ui/screens/ai/compare/compare_view_model.dart';
import 'package:khub_mobile/ui/screens/search/search_screen.dart';
import 'package:khub_mobile/utils/alert_utils.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final _promptController = TextEditingController();
  String _content = '';
  bool _isLoading = false;
  bool _showAdditionalInstructions = false;
  bool _isLongLoading = false;
  Timer? _loadingTimer;

  @override
  void dispose() {
    _promptController.dispose();
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          shadowColor: MainTheme.appColors.neutralBg,
          elevation: 1,
          centerTitle: true,
          title: appBarText(context, context.localized.aiComparePublications)),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child:
                  Consumer<CompareViewModel>(builder: (context, value, child) {
                return PublicationCompareChooser(
                  publicationOne: value.state.publicationOne,
                  publicationTwo: value.state.publicationTwo,
                  onTapPublicationOne: () => {},
                  onTapPublicationTwo: () => {_pickPublicationTwo()},
                );
              }),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.localized.comparingPublications,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isLongLoading) ...[
                            const SizedBox(height: 8),
                            Text(
                              context.localized.thisMayTakeALittleWhile,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  if (_content.isEmpty && !_isLoading) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info, color: Colors.grey[600]),
                        Text('Click the button below to compare',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w400))
                      ],
                    ));
                  }

                  return SingleChildScrollView(
                    child: Html(data: _content),
                  );
                },
              ),
            ),
            if (_content.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: _copyContent,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                  xSpacer(8),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: _shareContent,
                    icon: const Icon(Icons.share),
                    label: Text(context.localized.share),
                  ),
                ],
              ),
            ],
            InkWell(
              onTap: () {
                setState(() {
                  _showAdditionalInstructions = !_showAdditionalInstructions;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _showAdditionalInstructions
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  xSpacer(8),
                  Text(
                    _showAdditionalInstructions
                        ? context.localized.hideAdditionalInstructions
                        : context.localized.addAdditionalInstructions,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (_showAdditionalInstructions) ...[
              ySpacer(10),
              editTextLabel(context.localized.additionalInstructions),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: EditTextField(
                  textController: _promptController,
                  minLines: 3,
                ),
              ),
            ],
            ySpacer(12),
            CustomButton(
                onPressed: () {
                  _submit();
                },
                loading: _isLoading,
                loadingText: context.localized.comparing,
                child: Text(
                  context.localized.compare,
                  style: const TextStyle(color: Colors.white),
                )),
            ySpacer(12)
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (mounted) {
      final compareViewModel =
          Provider.of<CompareViewModel>(context, listen: false);

      if (compareViewModel.state.publicationOne != null &&
          compareViewModel.state.publicationTwo != null) {
        setState(() {
          _isLoading = true;
          _isLongLoading = false;
          _showAdditionalInstructions = false;
        });

        _loadingTimer = Timer(const Duration(seconds: 6), () {
          if (mounted) {
            setState(() {
              _isLongLoading = true;
            });
          }
        });
        final state = await compareViewModel.comparePublications(
            prompt: _promptController.text);

        _loadingTimer?.cancel();

        if (!state.isSuccess && mounted) {
          setState(() {
            _isLoading = false;
          });
          AlertUtils.showError(
              context: context, errorMessage: state.errorMessage);
        } else {
          setState(() {
            _isLoading = false;
            _content = state.content;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(context.localized.pleaseSelectTwoPublicationsToCompare)),
        );
      }
    }
  }

  _pickPublicationTwo() {
    if (mounted) {
      context.pushNamed(search,
          extra:
              SearchScreenState(searchType: SearchType.publication, target: 2));
    }
  }

  void _copyContent() {
    Clipboard.setData(
        ClipboardData(text: _content.replaceAll(RegExp(r'<[^>]*>'), '')));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.localized.contentCopiedToClipboard)),
    );
  }

  void _shareContent() {
    Share.share(_content.replaceAll(RegExp(r'<[^>]*>'), ''),
        subject: context.localized.aiComparePublications);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/dropdowns/dropdown_field.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/ui/screens/ai/ai_view_model.dart';
import 'package:khub_mobile/utils/alert_utils.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';

class AiSummarizeScreen extends StatefulWidget {
  final int type;
  final int resourceId;

  const AiSummarizeScreen(
      {super.key, required this.type, required this.resourceId});

  @override
  State<AiSummarizeScreen> createState() => _AiSummarizeScreenState();
}

class _AiSummarizeScreenState extends State<AiSummarizeScreen> {
  final _promptController = TextEditingController();
  String _selectedLanguage = 'English';
  String _content = '';
  bool _isLoading = false;
  bool _showAdditionalInstructions = false;
  bool _isLongLoading = false;
  Timer? _loadingTimer;

  final languages = [
    OptionItemModel('English', 'English'),
    OptionItemModel('Arabic', 'Arabic'),
    OptionItemModel('French', 'French'),
    OptionItemModel('Spanish', 'Spanish'),
    OptionItemModel('Portuguese', 'Portuguese'),
    OptionItemModel('Swahili', 'Swahili'),
  ];

  @override
  void dispose() {
    _promptController.dispose();
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.localized.aiSummarizer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50,
                    height: 50,
                    child: InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: Card(
                          elevation: 0,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.close,
                                color: Theme.of(context).primaryColor,
                                size: 20),
                          )),
                    ))
              ],
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
                            context.localized.summarizingContent,
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
                        Text(context.localized.clickButtonBelowToSummarize,
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
                    label: Text(context.localized.copy),
                  ),
                  xSpacer(8),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: _shareContent,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
            editTextLabel(context.localized.language),
            DropdownField(
              itemList: languages,
              initialSelectedItem: OptionItemModel('English', 'English'),
              onItemSelected: (value) {
                setState(() {
                  _selectedLanguage = value.id;
                });
              },
            ),
            ySpacer(10),
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
              EditTextField(
                textController: _promptController,
                minLines: 3,
              ),
            ],
            ySpacer(12),
            CustomButton(
                onPressed: () {
                  _submit();
                },
                loading: _isLoading,
                loadingText: context.localized.summarizing,
                child: Text(
                  context.localized.summarize,
                  style: const TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }

  void _submit() async {
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

    final state = await Provider.of<AiViewModel>(context, listen: false)
        .summarizePublication(
            resourceId: widget.resourceId,
            type: widget.type,
            prompt: _promptController.text,
            language: _selectedLanguage);

    _loadingTimer?.cancel();

    if (!state.isSuccess && mounted) {
      setState(() {
        _isLoading = false;
      });
      AlertUtils.showError(context: context, errorMessage: state.errorMessage);
    } else {
      setState(() {
        _isLoading = false;
        _content = state.content;
      });
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
        subject: context.localized.aiSummarizer);
  }
}

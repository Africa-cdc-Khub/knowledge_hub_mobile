import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/dialogs/success_dialog.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/screens/forums/create/create_forum_view_model.dart';
import 'package:khub_mobile/utils/alert_utils.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:khub_mobile/utils/validator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CreateForumScreen extends StatefulWidget {
  const CreateForumScreen({super.key});

  @override
  State<CreateForumScreen> createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<CreateForumScreen> {
  final TextEditingController _titleController = TextEditingController();

  final _forumCreateFormKey = GlobalKey<FormState>();

  late CreateForumViewModel viewModel;
  late QuillEditorController _storyController;

  String _errors = '';
  final String _defaultDesc = '';
  File? _pickedImageFile;
  bool _loading = false;

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
    viewModel = Provider.of<CreateForumViewModel>(context, listen: false);
    _storyController = QuillEditorController();
    super.initState();
  }

  Future<bool> requestPermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    // Check for storage permission
    var status = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    // Check if the permission was granted
    if (status.isGranted) {
      return Future.value(true);
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      return Future.value(false);
    }

    return Future.value(true);
  }

  Future<XFile?> pickXImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() {
        _errors = '';
        _pickedImageFile = file;
      });
      // LOGGER.d('Selected file: $pickedFile');
    }
    return pickedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: appBarText(
          context,
          context.localized.newDiscussion,
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
                  key: _forumCreateFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localized.startNewDiscussion,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      ySpacer(18),
                      editTextLabel(context.localized.forumTitle),
                      EditTextField(
                        textController: _titleController,
                        validator: (value) {
                          return Validator.required(value);
                        },
                      ),
                      ySpacer(14),
                      editTextLabel(context.localized.forumImage),
                      InkWell(
                        onTap: pickXImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              color: MainTheme.appColors.white900,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: SizedBox(
                            height: 150,
                            width: double.maxFinite,
                            child: _pickedImageFile != null
                                ? Image.file(
                                    _pickedImageFile!,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(context.localized.addImage,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      ySpacer(14),
                      editTextLabel(context.localized.forumStory),
                      _editorToolbar(context),
                      ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 200.0),
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
    if (_forumCreateFormKey.currentState?.validate() ?? false) {
      String htmlText = await _storyController.getText();

      if (_pickedImageFile == null) {
        setState(() {
          _errors = context.localized.addForumImage;
        });
      } else if (htmlText.isEmpty) {
        setState(() {
          _errors = context.localized.addForumStory;
        });
      } else {
        _submit();
      }
    }
  }

  void _submit() async {
    String htmlText = await _storyController.getText();
    setState(() {
      _loading = true;
    });

    final state = await viewModel.submitRequest(
        title: _titleController.text,
        description: htmlText,
        image: _pickedImageFile);

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
          message: context.localized.forumDiscussionSubmittedSuccessfully,
          onOkPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            context.go('/$forums',
                extra: {'refresh': true}); // Navigate to the forums page
          },
        ),
      );
    }
  }

  Widget _richTextEditor(BuildContext context) {
    return QuillHtmlEditor(
      text: _defaultDesc,
      hintText: '',
      controller: _storyController,
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
      controller: _storyController,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      customButtons: const [],
    );
  }
}

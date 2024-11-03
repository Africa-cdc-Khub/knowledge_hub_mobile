import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/community_model.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/dialogs/success_dialog.dart';
import 'package:khub_mobile/ui/elements/dropdowns/drop_down_with_chips.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/publish/publish_view_model.dart';
import 'package:khub_mobile/utils/alert_utils.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PublishFourScreen extends StatefulWidget {
  final Function() onBack;

  const PublishFourScreen({super.key, required this.onBack});

  @override
  State<PublishFourScreen> createState() => _PublishFourScreenState();
}

class _PublishFourScreenState extends State<PublishFourScreen> {
  final _publishFourFormKey = GlobalKey<FormState>();
  late PublishViewModel viewModel;
  List<CommunityModel> _communities = [];
  List<OptionItemModel> _selectedCommunities = [];
  String _errors = '';
  bool _loading = false;
  File? _pickedCoverImageFile;
  String _pickedCoverPath = '';

  @override
  void initState() {
    viewModel = Provider.of<PublishViewModel>(context, listen: false);
    if (viewModel.state.publicationRequest.cover != null) {
      setState(() {
        _pickedCoverImageFile = viewModel.state.publicationRequest.cover;
      });
    }

    if (viewModel.state.publicationRequest.communities.isNotEmpty) {
      setState(() {
        _selectedCommunities = viewModel.state.publicationRequest.communities;
      });
    }

    _fetchCommunities();
    super.initState();
  }

  Future<void> _fetchCommunities() async {
    final communities = await Provider.of<MainViewModel>(context, listen: false)
        .getCommunities();
    setState(() {
      _communities = communities;
    });
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
      LOGGER.d('Storage permission granted');
      return Future.value(true);
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      LOGGER.e('Storage permission denied');
      return Future.value(false);
    }

    return Future.value(true);
  }

  Future<XFile?> pickXImage() async {
    final isPermitted = await requestPermission();
    if (!isPermitted) await requestPermission();

    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      viewModel.setRequest(cover: file);

      setState(() {
        _errors = '';
        _pickedCoverImageFile = file;
      });
      // LOGGER.d('Selected file: $pickedFile');
    }
    return pickedFile;
  }

  Future<void> pickImage() async {
    LOGGER.d('Picking image');
    // Request permissions before picking an image
    final isPermitted = await requestPermission();
    if (!isPermitted) await requestPermission();

    // Open the file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      // Set to true if you want to allow multiple file selection
      type: FileType.image, // Specify the type of files you want to pick
    );

    if (result != null && result.files.isNotEmpty) {
      // Get the selected file
      String? filePath = result.files.single.path;

      if (filePath != null) {
        // Use the file path as needed
        setState(() {
          _pickedCoverImageFile = File(filePath);
          _pickedCoverPath = filePath;
        });
        LOGGER.d('Selected file: $filePath');
      }
    } else {
      // User canceled the picker
      LOGGER.e('No file selected');
    }
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
                key: _publishFourFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localized.attachments,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    ySpacer(16),
                    editTextLabel('Cover Image'),
                    InkWell(
                      onTap: pickXImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: MainTheme.appColors.white900,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0))),
                        child: SizedBox(
                          height: 150,
                          width: double.maxFinite,
                          child: _pickedCoverImageFile != null
                              ? Image.file(
                                  _pickedCoverImageFile!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Text('Add image',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor))
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                    // ySpacer(16),
                    // editTextLabel('Publication Attachment'),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.all(14.0),
                    //       child: const Text('No file chosen'),
                    //     ),
                    //     SizedBox(
                    //       width: 70,
                    //       child: CustomButton(
                    //           containerColor: Theme.of(context)
                    //               .primaryColor
                    //               .withOpacity(0.2),
                    //           onPressed: () {},
                    //           child: Icon(
                    //             Icons.add,
                    //             color: Theme.of(context).primaryColor,
                    //           )),
                    //     )
                    //   ],
                    // ),
                    ySpacer(16),
                    editTextLabel(
                        context.localized.targetAudienceCommunitiesOfPractice),
                    _communities.isNotEmpty
                        ? DropDownWithChips(
                            options: _communities
                                .map((item) => OptionItemModel(
                                    item.id.toString(), item.name))
                                .toList(),
                            initialSelectedItems: publishProvider
                                .state.publicationRequest.communities,
                            itemsSelected: (items) {
                              setState(() {
                                _selectedCommunities = items;
                              });
                            })
                        : const SizedBox.shrink(),
                    // ySpacer(16),
                    // editTextLabel('Source'),
                    // EditTextField(
                    //   textController: _authorController,
                    // ),
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
                        loading: _loading,
                        child: Text(
                          context.localized.submit,
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
    if (_publishFourFormKey.currentState?.validate() ?? false) {
      if (_pickedCoverImageFile == null) {
        setState(() {
          _errors = context.localized.selectCoverPhoto;
        });
      } else {
        viewModel.setRequest(
          communities: _selectedCommunities,
        );

        _submit();
      }
    }
  }

  void _submit() async {
    setState(() {
      _loading = true;
    });

    final state = await viewModel.submitRequest();

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
          message: context.localized.yourPublicationIsPendingApproval,
          titleBackgroundColor: Theme.of(context).primaryColor,
          onOkPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            viewModel.resetRequest();
            context.go('/$home');
          },
        ),
      );
    }
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/models/job_model.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/models/preference_model.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/dialogs/success_dialog.dart';
import 'package:khub_mobile/ui/elements/dropdowns/custom_drop_down.dart';
import 'package:khub_mobile/ui/elements/dropdowns/drop_down_with_chips.dart';
import 'package:khub_mobile/ui/elements/jobs/job_list_search.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/not_logged_in_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/account/profile/profile_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/utils/alert_utils.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  List<PreferenceModel> _preferences = [];
  List<OptionItemModel> _selectedPreferences = [];
  File? _profilePicture;
  String _profilePictureUrl = '';
  List<CountryModel> _countries = [];
  String _selectedJob = '';
  OptionItemModel? _selectedCountryModel;
  // String _selectedCountry = '';
  // String _errors = '';
  bool _loading = false;

  late ProfileViewModel viewModel;
  late AuthViewModel authViewModel;
  UserModel? _currentUser;

  @override
  void initState() {
    viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    viewModel.getCurrentUser();

    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

    if (viewModel.state.currentUser != null) {
      _profilePictureUrl = viewModel.state.currentUser?.photo ?? '';
      _emailController.text = viewModel.state.currentUser?.email ?? '';
      _phoneNumberController.text =
          viewModel.state.currentUser?.phoneNumber ?? '';
      _firstNameController.text = viewModel.state.currentUser?.firstName ?? '';
      _lastNameController.text = viewModel.state.currentUser?.lastName ?? '';
      _selectedPreferences = viewModel.state.currentUser?.preferences
              ?.map((e) => OptionItemModel(e.id.toString(), e.description))
              .toList() ??
          [];
      _selectedJob = viewModel.state.currentUser?.jobTitle ?? '';
      _selectedCountryModel = OptionItemModel(
          viewModel.state.currentUser?.country?.id.toString() ?? '',
          viewModel.state.currentUser?.country?.name ?? '');
    }
    _fetchPreferences();
    _getCountries();
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

      setState(() {
        // _errors = '';
        _profilePicture = file;
      });
      // LOGGER.d('Selected file: $pickedFile');
    }
    return pickedFile;
  }

  Future<void> _fetchPreferences() async {
    final preferences = await Provider.of<MainViewModel>(context, listen: false)
        .getPreferences();
    setState(() {
      _preferences = preferences;
    });
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
          context.localized.myProfile,
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
          child: Consumer<AuthViewModel>(builder: (context, provider, child) {
            if (!provider.state.isLoggedIn) {
              return NotLoggedInView(
                title: context.localized.youNeedToBeLoggedInToViewYourProfile,
              );
            }

            // Move the user assignment outside of setState
            _currentUser = provider.state.currentUser;
            return _profileContent();
          })),
    );
  }

  Widget _profileContent() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ySpacer(16),
                Center(
                  child: _profilePictureWidget(),
                ),
                // ySpacer(16),
                // editTextLabel('Language'),
                // DropdownField(
                //   itemList: const [],
                //   initialSelectedItem: ,
                //  onItemSelected: (value) {}
                //  ),
                ySpacer(5),
                editTextLabel(context.localized.email),
                EditTextField(
                  textController: _emailController,
                  isEditable: false,
                ),
                ySpacer(5),
                editTextLabel(context.localized.firstName),
                EditTextField(textController: _firstNameController),
                ySpacer(5),
                editTextLabel(context.localized.lastName),
                EditTextField(textController: _lastNameController),
                ySpacer(5),
                editTextLabel(context.localized.phoneNumber),
                EditTextField(textController: _phoneNumberController),
                ySpacer(5),
                editTextLabel(context.localized.country),
                CustomDropDown(
                    // containerColor: MainTheme.appColors.white200,
                    options: _countries
                        .map((item) =>
                            OptionItemModel(item.id.toString(), item.name))
                        .toList(),
                    initialSelectedItem: _selectedCountryModel,
                    onItemSelected: (item) {
                      setState(() {
                        _selectedCountryModel = item;
                      });
                    }),
                ySpacer(14),
                editTextLabel(context.localized.jobTitle),
                InkWell(
                  onTap: () {
                    _showJobs();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedJob,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 24, color: Colors.grey)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                ySpacer(5),
                editTextLabel(context.localized.preferences),
                DropDownWithChips(
                    options: _preferences
                        .map((e) => OptionItemModel(
                              e.id.toString(),
                              e.name,
                            ))
                        .toList(),
                    initialSelectedItems: _currentUser?.preferences
                            ?.map((e) => OptionItemModel(
                                  e.id.toString(),
                                  e.description,
                                ))
                            .toList() ??
                        [],
                    itemsSelected: (items) {
                      setState(() {
                        _selectedPreferences = items;
                      });
                    },
                    placeholder: context.localized.choosePreferences),
                // ySpacer(5),
                // editTextLabel('Communities'),
                // DropDownWithChips(
                //     options: const [],
                //     itemsSelected: (items) {},
                //     placeholder: 'Choose Community')
              ],
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
                loading: _loading,
                loadingText: context.localized.updating,
                onPressed: () {
                  _updateProfile();
                },
                child: Text(
                  context.localized.update,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )),
      ],
    );
  }

  void _showJobs() {
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
              child: JobListSearch(
                onJobSelected: (JobModel job) {
                  setState(() {
                    _selectedJob = job.name;
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

  Widget _profilePictureWidget() {
    return Stack(
      children: [
        SizedBox(
            width: 100,
            height: 100,
            child: ClipOval(
              child: Builder(builder: (context) {
                if (_profilePicture != null) {
                  return Image.file(
                    _profilePicture!,
                    fit: BoxFit.cover,
                  );
                } else if (_profilePictureUrl.isNotEmpty) {
                  return CachedNetworkImage(
                    imageUrl: _profilePictureUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => SizedBox(
                      height: 5,
                      width: 5,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/default_user.jpg'),
                  );
                }
                return Image.asset('assets/images/default_user.jpg');
              }),
            )),
        Positioned(
            bottom: -5,
            right: -5,
            child: IconButton(
                onPressed: () => pickXImage(),
                icon: Icon(Icons.camera_alt,
                    color: Theme.of(context).primaryColor, size: 25)))
      ],
    );
  }

  void _updateProfile() async {
    setState(() {
      _loading = true;
    });

    LOGGER.d({
      'id': _currentUser?.id,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'country_id': _selectedCountryModel?.id,
      'job': _selectedJob,
      'phone_number': _phoneNumberController.text,
      'preferences':
          _selectedPreferences.map((item) => int.parse(item.id)).toList(),
      'email': _emailController.text,
    });

    if (_currentUser == null) return;

    ProfileState state = await viewModel.updateProfile(
        id: _currentUser!.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        job: _selectedJob,
        countryId: int.parse(_selectedCountryModel?.id ?? ''),
        preferences:
            _selectedPreferences.map((item) => int.parse(item.id)).toList(),
        profilePhoto: _profilePicture);

    if (!state.isSuccess && mounted) {
      setState(() {
        _loading = false;
      });
      AlertUtils.showError(context: context, errorMessage: state.errorMessage);
    } else {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        Provider.of<ProfileViewModel>(context, listen: false).getCurrentUser();
        showDialog(
            context: context,
            builder: (context) => SuccessDialog(
                  title: context.localized.success,
                  message: context.localized.profileUpdatedSuccessfully,
                  onOkPressed: () {
                    Navigator.pop(context);
                  },
                ));
      }
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/file_type_model.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/comment/left_comment_item.dart';
import 'package:khub_mobile/ui/elements/comment/right_comment_item.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/ui/screens/ai/ai_summarize_screen.dart';
import 'package:khub_mobile/ui/screens/ai/compare/compare_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/viewer/web_viewer.dart';
import 'package:khub_mobile/utils/fontawesome_utils.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PublicationDetailScreen extends StatefulWidget {
  const PublicationDetailScreen({super.key});

  @override
  State<PublicationDetailScreen> createState() =>
      _PublicationDetailScreenState();
}

class _PublicationDetailScreenState extends State<PublicationDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late PublicationDetailViewModel viewModel;
  bool isExpanded = false;

  @override
  void initState() {
    viewModel = Provider.of<PublicationDetailViewModel>(context, listen: false);
    viewModel.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final description = publication.description;
    // final author = publication.author;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: appBarText(context, "Publication Detail"),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MainTheme.appColors.white900,
          padding: const EdgeInsets.all(16.0),
          child: Consumer<PublicationDetailViewModel>(
              builder: (context, provider, child) {
            final publication = provider.state.publication;
            if (publication == null) return const SizedBox.shrink();

            final authorImage = publication.author?.logo ?? '';

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: ClipOval(
                                child: authorImage.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: authorImage,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                Theme.of(context).primaryColor),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/default_user.jpg'),
                                      )
                                    : Image.asset(
                                        'assets/images/default_user.jpg')),
                          ),
                          xSpacer(8),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  publication.author?.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  timeago.format(
                                      Helpers.parseDate(publication.updatedAt)),
                                  style: TextStyle(
                                      color: MainTheme.appColors.neutral600,
                                      fontSize: 10),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      publication.isApproved == 0 &&
                              authViewModel.state.currentUser?.authorId ==
                                  publication.authorId
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    size: 14,
                                    Icons.schedule,
                                    color: MainTheme.appColors.yellow500,
                                  ),
                                  xSpacer(4),
                                  Text(
                                    'Pending Approval',
                                    style: TextStyle(
                                      color: MainTheme.appColors.yellow500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      ySpacer(14),
                      Image.network(
                        publication.cover,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Image.asset('assets/images/placeholder.jpg',
                                height: 200, fit: BoxFit.cover);
                          }
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // Display a placeholder image when the remote image fails to load
                          return Image.asset('assets/images/placeholder.jpg',
                              height: 200, fit: BoxFit.cover);
                        },
                      ),
                      ySpacer(14),
                      Html(data: publication.title, style: {
                        'body': Style(
                          fontWeight: FontWeight.w700,
                          fontSize: FontSize.large,
                        )
                      }),
                      // Text(publication.title),
                      ySpacer(8.0),
                      Html(
                        data: isExpanded
                            ? publication.description
                            : Helpers.truncateHtmlText(
                                publication.description, 5),
                        style: {
                          "body": Style(
                            maxLines: isExpanded ? null : 5,
                            textOverflow:
                                isExpanded ? null : TextOverflow.ellipsis,
                          ),
                        },
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded
                              ? context.localized.readLess
                              : context.localized.readMore,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      ySpacer(8),
                      Consumer<AuthViewModel>(
                          builder: (context, provider, child) {
                        if (provider.state.isLoggedIn) {
                          return _summarizeView(publication, context, 1);
                        }
                        return const SizedBox.shrink();
                      }),

                      Consumer<AuthViewModel>(
                          builder: (context, provider, child) {
                        if (provider.state.isLoggedIn) {
                          return _summarizeView(publication, context, 2);
                        }
                        return const SizedBox.shrink();
                      }),

                      ySpacer(2),
                      _publicationResource(publication, context),
                      ySpacer(16),
                      _infoView(publication),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      _commentView(publication, provider.state)
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Consumer<AuthViewModel>(
                        builder: (context, provider, child) {
                      if (provider.state.isLoggedIn) {
                        return Container(
                          padding: const EdgeInsets.only(top: 16.0),
                          color: MainTheme.appColors.white900,
                          child: Row(children: [
                            Expanded(
                              child: EditTextField(
                                textHint: context.localized.enterComment,
                                textController: _commentController,
                                borderRadius: 50.0,
                                containerColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                              ),
                            ),
                            xSpacer(10.0),
                            SizedBox(
                              width: 64.0,
                              height: 64.0,
                              child: InkWell(
                                onTap: () {
                                  _addComment(_commentController.text);
                                },
                                child: Card(
                                    elevation: 0,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.send,
                                          color: Colors.white, size: 20),
                                    )),
                              ),
                            )
                          ]),
                        );
                      }

                      return const SizedBox.shrink();
                    })),
              ],
            );
          })),
    );
  }

  Widget _summarizeView(
      PublicationModel model, BuildContext context, int type) {
    return InkWell(
      onTap: () {
        type == 1
            ? _showAISummarize(model, context, type)
            : _goToCompareScreen(model, context);
      },
      child: Card(
          elevation: 0,
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.robot,
                          size: 16, color: Theme.of(context).primaryColor),
                      xSpacer(12),
                      Text(
                        type == 1
                            ? context.localized.aiSummarizer
                            : context.localized.aiCompare,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward,
                      size: 16, color: Theme.of(context).primaryColor),
                ],
              ))),
    );
  }

  Widget _publicationResource(PublicationModel model, BuildContext context) {
    IconData? iconData = iconClassToIcon[model.fileType?.icon];
    FileTypeModel? fileType = model.fileType;

    return InkWell(
      onTap: () {
        if (fileType != null && fileType.name.isNotEmpty) {
          model.publication.contains('.pdf')
              ? context.pushNamed(publicationPdfViewer,
                  extra: model.publication)
              : context.pushNamed(webViewer,
                  extra: WebViewerState(
                      linkUrl: model.publication,
                      title: context.localized.viewPublicationLink));
        }
      },
      child: Card(
          elevation: 0,
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(iconData,
                          size: 16, color: Theme.of(context).primaryColor),
                      xSpacer(12),
                      Text(
                        context.localized.viewPublication,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward,
                      size: 16, color: Theme.of(context).primaryColor),
                ],
              ))),
    );
  }

  Widget _commentView(PublicationModel model, PublicationDetailState state) {
    final items = model.comments;

    if (items == null) {
      return const SizedBox.shrink();
    } else if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Icon(
                Icons.wechat_sharp,
                color: Colors.grey,
              ),
              Text(context.localized.noComments,
                  style: const TextStyle(color: Colors.grey))
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

        return SizedBox(
            width: double.infinity,
            child: state.currentUser != null &&
                    state.currentUser!.id == item.userId
                ? RightCommentItem(comment: item)
                : LeftCommentItem(comment: item));
      },
    );
  }

  Widget _infoView(PublicationModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconDescriptionView(
            icon: FontAwesomeIcons.buildingColumns,
            size: 14,
            description: model.author?.name ?? ''),
        ySpacer(4),
        _iconDescriptionView(
            icon: FontAwesomeIcons.briefcase,
            size: 14,
            description: model.theme?.description ?? ''),
        ySpacer(4),
        _iconDescriptionView(
            icon: FontAwesomeIcons.boxArchive,
            size: 14,
            description: model.subTheme?.description ?? ''),
        ySpacer(4),
        _iconDescriptionView(
            icon: FontAwesomeIcons.file,
            size: 14,
            description: model.category?.categoryName ?? ''),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(),
        ),
        _bottomInfo(model)
      ],
    );
  }

  Widget _bottomInfo(PublicationModel model) {
    final comments = model.comments?.where((item) => item.status == 'approved');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.visibility,
              size: 16,
            ),
            xSpacer(4.0),
            Text('${model.visits} ${context.localized.views}')
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.wechat_sharp,
              size: 16,
            ),
            xSpacer(4.0),
            Text('${comments?.length} ${context.localized.comments}')
          ],
        ),
        InkWell(
          onTap: () {
            _likePublication(model.id);
          },
          child: Row(
            children: [
              Icon(
                model.isFavourite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline,
                size: 18,
              ),
              xSpacer(4.0),
              Text(model.isFavourite
                  ? context.localized.unlike
                  : context.localized.like)
            ],
          ),
        )
      ],
    );
  }

  Widget _iconDescriptionView(
      {required IconData icon, required String description, double? size}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: size ?? 12,
        ),
        xSpacer(4.0),
        Flexible(
          child: Text(
            description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: size ?? 12.0),
          ),
        ),
      ],
    );
  }

  _addComment(String comment) async {
    if (comment.isNotEmpty) {
      _commentController.text = '';
      await viewModel.addComment(comment);
    }
  }

  _likePublication(int publicationId) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (authViewModel.state.isLoggedIn) {
      await viewModel.addFavorite(publicationId);
    }
  }

  void _showAISummarize(
      PublicationModel model, BuildContext context, int type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Start just below the AppBar
          minChildSize: 0.5, // Minimum height (half screen)
          maxChildSize: 0.9, // Maximum height (90% of screen)
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: AiSummarizeScreen(
                type: 0,
                resourceId: model.id,
              ),
            );
          },
        );
      },
    );
  }

  _goToCompareScreen(PublicationModel model, BuildContext context) {
    Provider.of<CompareViewModel>(context, listen: false)
        .setPublicationOne(model);
    Provider.of<CompareViewModel>(context, listen: false)
        .setPublicationTwo(null);
    context.pushNamed(aiComparePublications);
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;

class PublicationListItem extends StatelessWidget {
  final PublicationModel model;
  final bool isVerticalItem;
  final VoidCallback? onClick;
  final double? borderRadius;
  final bool? isMyPublication; // New parameter

  const PublicationListItem({
    super.key,
    required this.model,
    this.onClick,
    required this.isVerticalItem,
    this.borderRadius,
    this.isMyPublication, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    final author = model.author;
    final authorImage = author?.logo ?? '';

    return InkWell(
      onTap: onClick,
      child: SizedBox(
        width: 240.0,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
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
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              SizedBox(
                                            height: 5,
                                            width: 5,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Theme.of(context)
                                                          .primaryColor),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/images/default_user.jpg'),
                                        )
                                      : Image.asset(
                                          'assets/images/default_user.jpg'))),
                          xSpacer(8),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  author?.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  timeago.format(
                                      Helpers.parseDate(model.updatedAt)),
                                  style: TextStyle(
                                      color: MainTheme.appColors.neutral600,
                                      fontSize: 10),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // if (isMyPublication == true &&
                    //     authViewModel.state.currentUser?.authorId ==
                    //         model.authorId)
                    //   IconButton(
                    //     icon: Icon(Icons.edit,
                    //         color: Theme.of(context).primaryColor),
                    //     onPressed: () {
                    //       // TODO: Implement navigation to edit publication screen
                    //     },
                    //   ),
                  ],
                ),
                ySpacer(8),
                Text(
                  model.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isVerticalItem ? 16 : 14,
                  ),
                ),
                ySpacer(4),
                Flexible(
                    child: _iconDescriptionView(context,
                        isVertical: isVerticalItem,
                        icon: FontAwesomeIcons.briefcase,
                        description: model.theme?.description ?? '')),
                ySpacer(4),
                Flexible(
                    child: _iconDescriptionView(context,
                        isVertical: isVerticalItem,
                        icon: FontAwesomeIcons.boxArchive,
                        description: model.subTheme?.description ?? '')),
                ySpacer(4),
                Flexible(
                    child: _iconDescriptionView(context,
                        isVertical: isVerticalItem,
                        icon: FontAwesomeIcons.file,
                        description: model.category?.categoryName ?? '')),
                // ySpacer(10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(
                    color: MainTheme.appColors.neutral300,
                    thickness: 0.5,
                  ),
                ),
                Flexible(child: _bottomInfo(model, isVerticalItem)),
                isMyPublication == true && model.isApproved == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              size: 14,
                              Icons.schedule,
                              color: MainTheme.appColors.yellow400,
                            ),
                            xSpacer(4),
                            Text(
                              'Pending Approval',
                              style: TextStyle(
                                color: MainTheme.appColors.yellow400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomInfo(PublicationModel model, bool isVerticalItem) {
    final double defaultSize = isVerticalItem ? 20 : 20;
    final comments = model.comments?.where((item) => item.status == 'approved');

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility,
                    size: defaultSize,
                    color: MainTheme.appColors.neutral700,
                  ),
                  xSpacer(4.0),
                  Text('${model.visits}')
                ],
              ),
              xSpacer(16),
              Row(
                children: [
                  Icon(
                    Icons.wechat_sharp,
                    size: defaultSize,
                    color: MainTheme.appColors.neutral700,
                  ),
                  xSpacer(4.0),
                  Text('${comments?.length}')
                ],
              ),
            ],
          ),
          isVerticalItem
              ? Row(
                  children: [
                    Icon(
                      model.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: defaultSize,
                      color: MainTheme.appColors.neutral700,
                    ),
                    xSpacer(4.0),
                    Text(model.isFavourite ? 'Unlike' : 'Like')
                  ],
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _iconDescriptionView(BuildContext context,
      {required bool isVertical,
      required IconData icon,
      required String description,
      double? size}) {
    double defaultSize = isVertical ? 14 : 11;

    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: size ?? defaultSize,
        ),
        xSpacer(4.0),
        Flexible(
          child: Text(
            description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: size ?? defaultSize),
          ),
        ),
      ],
    );
  }
}

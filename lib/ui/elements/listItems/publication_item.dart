import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;

class PublicationItem extends StatelessWidget {
  final PublicationModel model;
  final bool isVerticalItem;
  final VoidCallback? onClick;
  final double? borderRadius;
  final bool? isMyPublication; // New parameter

  const PublicationItem({
    super.key,
    required this.model,
    this.onClick,
    required this.isVerticalItem,
    this.borderRadius,
    this.isMyPublication, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final shortestSide = screenSize.shortestSide;
    final isTablet = shortestSide >= 600;

    return InkWell(
      onTap: onClick,
      child: SizedBox(
        width: 280.0,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Builder(builder: (context) {
                if (isTablet && isVerticalItem) {
                  return _tabletItem(context, isTablet);
                } else if (isTablet && !isVerticalItem) {
                  return _normalItem(context, isTablet);
                } else {
                  return _normalItem(context, isTablet);
                }
              })),
        ),
      ),
    );
  }

  Widget _tabletItem(BuildContext context, bool isTablet) {
    return Row(
      children: [
        SizedBox(
          width: 280,
          child: _coverPhoto(context, isTablet),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _authorInfo(context),
              ySpacer(8),
              _publicationContent(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _normalItem(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _authorInfo(context),
        ySpacer(8),
        _coverPhoto(context, isTablet),
        ySpacer(8),
        _publicationContent(context),
      ],
    );
  }

  Widget _publicationContent(BuildContext context) {
    return Column(
      children: [
        Html(data: model.title, style: {
          'body': Style(
              fontWeight: FontWeight.w500,
              fontSize: FontSize(isVerticalItem ? 14 : 12),
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              padding: HtmlPaddings.zero)
        }),
        Html(
          data: Helpers.truncateHtmlText(model.description, 4),
          style: {
            "body": Style(
                maxLines: 3,
                fontSize: FontSize(isVerticalItem ? 14 : 12),
                textOverflow: TextOverflow.ellipsis,
                padding: HtmlPaddings.zero),
          },
        ),
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
        Builder(builder: (context) {
          if (isVerticalItem) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(
                    color: MainTheme.appColors.neutral300,
                    thickness: 0.5,
                  ),
                ),
                _bottomInfo(model, isVerticalItem)
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _authorInfo(BuildContext context) {
    final author = model.author;
    final authorImage = author?.logo ?? '';

    return Row(
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
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
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
                          )
                        : Image.asset('assets/images/default_user.jpg')),
              ),
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
                      timeago.format(Helpers.parseDate(model.updatedAt)),
                      style: TextStyle(
                          color: MainTheme.appColors.neutral600, fontSize: 10),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _coverPhoto(BuildContext context, bool isTablet) {
    final height = _getCoverPhotoHeight(isTablet, isVerticalItem);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      child: Image.network(
        model.cover,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Image.asset('assets/images/placeholder.jpg',
                height: height, width: double.infinity, fit: BoxFit.cover);
          }
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          // Display a placeholder image when the remote image fails to load
          return Image.asset('assets/images/placeholder.jpg',
              height: height, width: double.infinity, fit: BoxFit.cover);
        },
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

  double _getCoverPhotoHeight(bool isTablet, bool isVerticalItem) {
    if (!isVerticalItem) {
      return 90.0;
    }
    return isTablet ? 200.0 : 160.0;
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/models/forum_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumListItem extends StatelessWidget {
  final ForumModel model;
  final VoidCallback? onClick;
  final double? borderRadius;

  const ForumListItem(
      {super.key, required this.model, this.onClick, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final author = model.user;
    final comments = model.comments?.where((item) => item.status == 'approved');
    final authorImage = author?.photo ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: InkWell(
        onTap: onClick,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
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
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
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
                                      Image.asset(
                                          'assets/images/default_user.jpg'),
                                )
                              : Image.asset('assets/images/default_user.jpg')),
                    ),
                    xSpacer(8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(author?.name ?? ''),
                        Text(
                          timeago.format(Helpers.parseDate(model.createdAt)),
                          style: TextStyle(
                              color: MainTheme.appColors.neutral600,
                              fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
                ySpacer(8),
                _coverPhoto(context),
                ySpacer(4),
                Html(
                  data: Helpers.truncateHtmlText(model.description, 5),
                  style: {
                    "body": Style(
                      maxLines: 5,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  },
                ),
                ySpacer(8),
                _iconDescriptionView(
                    context: context,
                    icon: Icons.wechat_sharp,
                    description: '${comments?.length} comments')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _coverPhoto(BuildContext context) {
    const height = 160.0;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      child: Image.network(
        model.image,
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

  Widget _iconDescriptionView(
      {required IconData icon,
      required String description,
      double? size,
      required BuildContext context}) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        model.isApproved == 0 &&
                authViewModel.state.currentUser?.id == model.user?.id
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
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                icon,
                color: MainTheme.appColors.neutral700,
                size: 22,
              ),
              xSpacer(4.0),
              Flexible(
                child: Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: size ?? 14,
                      color: MainTheme.appColors.neutral800),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

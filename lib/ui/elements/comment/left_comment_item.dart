import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/models/comment_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;

class LeftCommentItem extends StatelessWidget {
  final CommentModel comment;
  const LeftCommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final userImage = comment.user?.logo ?? '';
    return comment.status == 'approved'
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16, // You can
                      child: ClipOval(
                        child: userImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: userImage,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const SizedBox(
                                  height: 5,
                                  width: 5,
                                  child: LoadingView(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'assets/images/default_user.jpg'),
                              )
                            : Image.asset('assets/images/default_user.jpg'),
                      ),
                    ),
                    xSpacer(6),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: MainTheme.appColors.neutral200,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              margin: const EdgeInsets.only(right: 50),
                              padding: const EdgeInsets.all(16),
                              child: Html(
                                data: comment.comment,
                              )),
                          Text(
                            timeago
                                .format(Helpers.parseDate(comment.createdAt)),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                            maxLines: null,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

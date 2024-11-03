import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:khub_mobile/models/comment_model.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;

class RightCommentItem extends StatelessWidget {
  final CommentModel comment;
  const RightCommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final userImage = comment.user?.logo ?? '';
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0)),
                      ),
                      margin: const EdgeInsets.only(left: 50),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Html(
                          data: comment.comment,
                          style: {
                            "body": Style(
                              color: Colors.white,
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                          },
                        ),
                        //  Text(
                        //   comment.comment,
                        //   style: const TextStyle(color: Colors.white),
                        //   maxLines: null,
                        //   softWrap: true,
                        // ),
                      )),
                ],
              ),
            ),
            xSpacer(6),
            CircleAvatar(
              radius: 16, // You can
              child: ClipOval(
                child: userImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: comment.user?.logo ?? '',
                        imageBuilder: (context, imageProvider) => Container(
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
                            Image.asset('assets/images/default_user.jpg'),
                      )
                    : Image.asset('assets/images/default_user.jpg'),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              comment.status == 'pending'
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Pending approval',
                          style: TextStyle(color: Colors.orange, fontSize: 12)),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  timeago.format(Helpers.parseDate(comment.createdAt)),
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        ySpacer(8.0)
      ],
    );
  }
}

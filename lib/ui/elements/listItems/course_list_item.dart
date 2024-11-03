import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/course_model.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';

class CourseListItem extends StatelessWidget {
  final CourseModel model;
  final VoidCallback? onClick;
  final bool isVerticalItem;
  final double? borderRadius;

  const CourseListItem(
      {super.key,
      required this.model,
      this.onClick,
      required this.isVerticalItem,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
          onTap: onClick,
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _coverPhoto(context),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 12, right: 12),
                  child: _courseInfo(context),
                ),
              ],
            ),
          )),
    );
  }

  Widget _coverPhoto(BuildContext context) {
    const height = 170.0;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.network(
          model.coverImage,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Image.asset('assets/images/placeholder.jpg',
                  height: height, fit: BoxFit.cover);
            }
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            // Display a placeholder image when the remote image fails to load
            return Image.asset('assets/images/placeholder.jpg',
                height: height, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }

  Widget _courseInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(model.fullname,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Html(
          data: Helpers.truncateHtmlText(model.summary, 4),
          style: {
            "body": Style(
                maxLines: 3,
                fontSize: FontSize(15),
                textOverflow: TextOverflow.ellipsis,
                padding: HtmlPaddings.zero),
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(context.localized.viewCourse,
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () => {
                context.pushNamed(courseDetail, extra: model),
              },
            )
          ],
        )
      ],
    );
  }
}

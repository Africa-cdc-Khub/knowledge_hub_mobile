import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/course_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool isExpanded = false;

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
            context.localized.courseDetail,
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MainTheme.appColors.white900,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _coverPhoto(),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12, top: 14),
                child: _content(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 17.0),
                child: _openCourseButton(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverPhoto() {
    return Image.network(
      widget.course.coverImage,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Image.asset('assets/images/placeholder.jpg',
              height: 200, width: double.infinity, fit: BoxFit.cover);
        }
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Display a placeholder image when the remote image fails to load
        return Image.asset('assets/images/placeholder.jpg',
            height: 200, width: double.infinity, fit: BoxFit.cover);
      },
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Html(data: widget.course.fullname, style: {
          'body': Style(
            fontWeight: FontWeight.w700,
            fontSize: FontSize.large,
          )
        }),
        ySpacer(8.0),
        Html(
          data: isExpanded
              ? widget.course.summary
              : Helpers.truncateHtmlText(widget.course.summary, 5),
          style: {
            "body": Style(
              maxLines: isExpanded ? null : 5,
              textOverflow: isExpanded ? null : TextOverflow.ellipsis,
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
      ],
    );
  }

  Widget _openCourseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchCourse(context, widget.course.courseLink);
      },
      child: Card(
          elevation: 0,
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.book,
                          size: 16, color: Theme.of(context).primaryColor),
                      xSpacer(12),
                      Text(
                        context.localized.gotToCourse,
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

  void _launchCourse(BuildContext context, String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      LOGGER.e('Could not launch $url');
    }
  }
}

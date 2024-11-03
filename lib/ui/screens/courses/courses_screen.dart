import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/course_list_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/courses/courses_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late ScrollController _scrollController;
  late CoursesViewModel viewModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    viewModel = Provider.of<CoursesViewModel>(context, listen: false);
    _fetchCourses();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      viewModel.loadMore();

      if (mounted) {
        setState(() {});
      }
    }
  }

  _fetchCourses() async {
    await viewModel.fetchCourses();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          shadowColor: MainTheme.appColors.neutralBg,
          elevation: 1,
          centerTitle: true,
          title: appBarText(context, context.localized.courses),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child:
                Consumer<CoursesViewModel>(builder: (context, provider, child) {
              if (provider.state.loading && provider.state.courses.isEmpty) {
                return const Center(child: LoadingView());
              }

              if (provider.state.courses.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyViewElement(),
                  ],
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.state.courses.length +
                    (provider.state.loading ? 1 : 0),
                itemBuilder: (context, index) {
                  final item = provider.state.courses[index];

                  if (index == provider.state.courses.length) {
                    return provider.state.loading
                        ? const Center(child: LoadingView())
                        : const SizedBox.shrink();
                  }

                  return CourseListItem(
                    isVerticalItem: true,
                    borderRadius: 8,
                    model: item,
                    onClick: () {
                      context.pushNamed(courseDetail, extra: item);
                    },
                  );
                },
              );
            })));
  }
}

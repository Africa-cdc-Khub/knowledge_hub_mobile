import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khub_mobile/models/job_model.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/jobs/jobs_view_model.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class JobListSearch extends StatefulWidget {
  final void Function(JobModel)? onJobSelected;

  const JobListSearch({super.key, this.onJobSelected});

  @override
  State<JobListSearch> createState() => _JobListSearchState();
}

class _JobListSearchState extends State<JobListSearch> {
  final TextEditingController _searchController = TextEditingController();
  final _searchStreamController = StreamController<String>();
  late JobsViewModel jobsViewModel;

  @override
  void initState() {
    jobsViewModel = Provider.of<JobsViewModel>(context, listen: false);
    jobsViewModel.fetchInitialJobs();

    // Listen to the stream with debounce
    _searchStreamController.stream
        .debounceTime(
            const Duration(milliseconds: 500)) // Use RxDart's debounceTime
        .listen((searchQuery) {
      jobsViewModel.searchJobs(searchQuery);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            EditTextField(
              textHint: context.localized.search,
              textController: _searchController,
              borderRadius: 8,
              onChanged: (value) {
                if (value != null) {
                  _searchStreamController.add(value); // Add value to the stream
                }
              },
            ),
            Expanded(
              child:
                  Consumer<JobsViewModel>(builder: (context, provider, child) {
                if (provider.state.list.isEmpty) {
                  return Center(
                      child: EmptyViewElement(
                          message: context.localized.noJobsFound));
                }

                return ListView.builder(
                  itemCount: provider.state.list.length,
                  itemBuilder: (context, index) {
                    final job = provider.state.list[index];

                    return InkWell(
                      onTap: () {
                        if (widget.onJobSelected != null) {
                          widget.onJobSelected!(job);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 12),
                        child: Text(job.name),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ));
  }
}

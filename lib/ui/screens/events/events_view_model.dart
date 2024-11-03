import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/models/event_model.dart';
import 'package:khub_mobile/repository/event_repository.dart';

class EventsState {
  bool isSuccess = false;
  String errorMessage = '';
  List<EventModel> events = [];

  EventsState();
  EventsState.success(this.isSuccess, this.events);
  EventsState.error(this.isSuccess, this.errorMessage);
}

class EventsViewModel extends ChangeNotifier {
  final EventRepository eventRepository;
  final EventsState state = EventsState();

  EventsViewModel({required this.eventRepository});

  Future<EventsState> getEvents() async {
    final result = await eventRepository.getEvents();

    if (result is DataSuccess) {
      final list = result.data?.data
              ?.map((item) => EventModel.fromApiModel(item))
              .toList() ??
          [];
      return EventsState.success(true, list);
    }

    if (result is DataError) {
      return EventsState.error(false, result.error ?? 'Error occurred');
    }

    return EventsState();
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/event_model.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/events/events_view_model.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late EventsViewModel viewModel;
  List<EventModel> _events = [];
  late Future? myFuture;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<EventsViewModel>(context, listen: false);
    myFuture = _fetchItems();
  }

  _fetchItems() async {
    EventsState state = await viewModel.getEvents();
    if (state.isSuccess) {
      setState(() {
        _events = state.events;
      });
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingView());
          } else if (snapshot.hasData) {
            return _events.isEmpty
                ? const SizedBox.shrink()
                : EventsCarousel(events: _events);
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class EventsCarousel extends StatefulWidget {
  final List<EventModel> events;

  const EventsCarousel({super.key, required this.events});

  @override
  State<EventsCarousel> createState() => _EventsCarouselState();
}

class _EventsCarouselState extends State<EventsCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.events.length,
          options: CarouselOptions(
            height: 170,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
            scrollDirection: Axis.horizontal,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final item = widget.events[index];
            return InkWell(
              onTap: () {
                context.pushNamed(eventDetail, extra: item);
              },
              child: Image.network(
                item.bannerImage,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Image.asset('assets/images/placeholder.jpg',
                        fit: BoxFit.cover);
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/images/placeholder.jpg',
                      fit: BoxFit.cover);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.events.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

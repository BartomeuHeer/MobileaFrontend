import 'dart:async';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import '../models/location.dart';
import '../models/search.dart';
import '../models/suggestion.dart';
import '../services/search_service.dart';
import '../utils/icon_url.dart';

class LocationSearchDelegate extends SearchDelegate {
  final SearchService searchService = SearchService();
  final String apiKey;
  final LatLng? mapCenter;
  final Function? onSearchResults;
  final Function? onClear;

  Completer<List> _completer = Completer();
  late final debouncer = Debouncer<String>(
    const Duration(milliseconds: 300),
    initialValue: '',
    onChanged: (value) => _completer.complete(_doQuery()),
  );

  LocationSearchDelegate({
    required this.apiKey,
    this.mapCenter,
    this.onSearchResults,
    this.onClear,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.black38,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
            headline6: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
          onClear!();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    debouncer.value = query;
    _completer = Completer();

    return FutureBuilder(
        future: _completer.future,
        builder: ((BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            Iterable items = (snapshot.data as List);
            return ListView.separated(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items.elementAt(index);
                return ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: item.type == 'location'
                              ? Colors.grey
                              : Colors.amber,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Svg(
                              iconUrl(item.type, item.data.id),
                              size: const Size(24, 24),
                            ),
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: item.buildTitle(context),
                  subtitle:
                      (item.hasSubtitle ? item.buildSubtitle(context) : null),
                  onTap: () => _onItemTap(context, item),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 1);
              },
            );
          } else if (query.isNotEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  void showResults(BuildContext context) async {
    super.showResults(context);

    close(context, null);

    var results = await searchService.fuzzySearch(apiKey, query, {
      'limit': 10,
      'lat': mapCenter?.latitude,
      'lon': mapCenter?.longitude,
    });

    var search = Search(
      type: 'location',
      query: query,
      results: results,
    );

    onSearchResults!(search);
  }

  Future<List> _doQuery() async {
    var combinedResults = await Future.wait([
      searchService.autocomplete(apiKey, query, {
        'limit': 3,
        'lat': mapCenter?.latitude,
        'lon': mapCenter?.longitude,
      }),
      searchService.fuzzySearch(apiKey, query, {
        'limit': 7,
        'lat': mapCenter?.latitude,
        'lon': mapCenter?.longitude,
      })
    ]);
    var results = combinedResults.expand(((element) => element)).toList();

    return _buildItems(results);
  }

  List _buildItems(results) {
    return results.map((result) {
      switch (result?.type) {
        case 'category':
          return SuggestionItem('category', result);
        case 'brand':
          return SuggestionItem('brand', result);
        case 'POI':
        case 'Street':
        case 'Geography':
        case 'Point Address':
        case 'Address Range':
        case 'Cross Street':
          return LocationItem('location', result);
        default:
          return Container();
      }
    }).toList();
  }

  void _onItemTap(BuildContext context, dynamic item) async {
    close(context, null);

    var results = <Location>[];
    var options = {
      'limit': 7,
      'lat': mapCenter!.latitude,
      'lon': mapCenter!.longitude,
    };

    if (item.type == 'brand') {
      results = await searchService
          .fuzzySearch(apiKey, '', {...options, 'brandSet': item.data.value});
    } else if (item.type == 'category') {
      results = await searchService
          .fuzzySearch(apiKey, '', {...options, 'categorySet': item.data.id});
    } else {
      results = <Location>[item.data];
    }

    var search = Search(
      type: item.type,
      query: item.type == 'location' ? item.data.primaryText : item.data.value,
      category: item.type == 'category' ? item.data.id : null,
      results: results,
    );

    onSearchResults!(search);
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);

  bool get hasSubtitle => false;
}

class SuggestionItem implements ListItem {
  final String type;
  final Suggestion data;

  SuggestionItem(this.type, this.data);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(data.value);
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text('Search ${data.type}');
  }

  @override
  bool get hasSubtitle => true;
}

class LocationItem implements ListItem {
  final String type;
  final Location data;

  LocationItem(this.type, this.data);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(data.primaryText);
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(
      data.secondaryText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  bool get hasSubtitle => data.addressLines[1] != null;
}
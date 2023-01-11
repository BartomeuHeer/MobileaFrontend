import './location.dart';

class Search {
  final String type;
  final String query;
  final String? category;
  final List<Location> results;

  Search({
    required this.type,
    required this.query,
    this.category,
    required this.results,
  });
}
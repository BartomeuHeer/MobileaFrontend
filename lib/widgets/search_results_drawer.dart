import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:recase/recase.dart';
import '../models/location.dart';
import '../models/search.dart';
import '../utils/icon_url.dart';

class SearchResultsDrawer extends StatelessWidget {
  final BottomDrawerController controller;
  final Search search;
  final String? selectedId;
  final Function onItemTap;
  final Function onClear;

  const SearchResultsDrawer({
    Key? key,
    required this.controller,
    required this.search,
    this.selectedId,
    required this.onItemTap,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return BottomDrawer(
        header: _buildBottomDrawerHeader(context),
        body: _buildBottomDrawerBody(context),
        headerHeight: 160,
        drawerHeight: 420,
        color: Colors.white,
        controller: controller,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ]);
  }

  Widget _buildBottomDrawerHeader(BuildContext context) {
    String name = search.query;
    String title = name.length > 22 ? '${name.substring(0, 22)}...' : name;

    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.only(
          top: 8,
          right: 8,
          bottom: 8,
          left: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey[300]!,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: search.type == 'location' ? Colors.grey : Colors.amber,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: Svg(
                    iconUrl(search.type, search.category),
                    size: const Size(24, 24),
                  ),
                ),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (search.type != 'location')
                Text(
                  search.type.titleCase,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    height: 1.3,
                  ),
                ),
            ]),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.clear),
              iconSize: 24,
              onPressed: () {
                onClear();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    return Material(
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 0),
        itemCount: search.results.length,
        itemBuilder: (BuildContext context, int index) {
          final Location result = search.results[index];
          return Ink(
            color: selectedId != null && selectedId! == result.id
                ? Colors.black12
                : Colors.transparent,
            child: ListTile(
              title: Text(result.primaryText),
              subtitle: Text(
                result.secondaryText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                onItemTap(result);
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
          );
        },
      ),
    );
  }
}
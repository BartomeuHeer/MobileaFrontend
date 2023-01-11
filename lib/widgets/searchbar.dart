import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function? onTap;
  final String? query;

  const SearchBar({
    Key? key,
    this.query,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = query ?? 'Search';
    text = text.length > 22 ? '${text.substring(0, 28)}...' : text;

    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        boxShadow: ([
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ]),
      ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: InkWell(
          onTap: () => onTap!(context),
          child: Container(
            padding: const EdgeInsets.only(left: 14),
            child: Row(
              children: <Widget>[
                const Icon(Icons.search, color: Colors.black87, size: 26),
                Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: query != null ? Colors.black87 : Colors.black38,
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
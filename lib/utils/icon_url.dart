import 'map_category_to_icon.dart';

String iconUrl(type, id) {
  var iconUrl = 'assets/images/marker.svg';

  if (type == 'category') {
    var icon = mapCategoryToIcon(id);
    if (icon.isNotEmpty) {
      iconUrl = 'assets/images/poi/$icon.svg';
    }
  } else if (type == 'brand') {
    iconUrl = 'assets/images/tag.svg';
  }

  return iconUrl;
}
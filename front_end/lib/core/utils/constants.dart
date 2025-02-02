

import 'package:flutter/material.dart';

class AppImage {

  static const String homeUnselected = 'asset/image/home_page_unselected.png';
  // static const String homeSelected = 'front_end/asset/image/home_page_selected.png';

  static const String qaUnselected = 'asset/image/qa_page_unselected.png';
  // static const String qaSelected = 'asset/image/qa_page_selected.png';

  static const String resourceUnselected = 'asset/image/resource_unselected.png';
  // static const String resourceSelected = 'asset/image/resource_selected.png';

  // static const String chatUnselected = 'asset/image/chat_room_unselected.png';
  static const String chatSelected = 'asset/image/chat_room_selected.png';
  
  static const String logoutsvg = 'asset/svg/logout.svg';
  static const dashIcon = 'asset/svg/dash.svg';
  static const themeIcon = 'asset/svg/theme_icon.svg';


    static const loadingPlaceholder =
      "asset/gif/cupertino_activity_indicator_square_large.gif";

}

class AppColor {

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

}
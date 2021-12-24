import 'package:flutter/cupertino.dart';
import 'package:namkaran_app/models/names.dart';

class Same {
  List<String> images = [
    'assets/background/boyname_background.png', //0
    'assets/background/home_background.png', //1
    'assets/images/home_boy.png', //2
    'assets/images/home_fav.png', //3
    'assets/images/home_girl.png', //4
    'assets/images/home_logo.png', //5
    'assets/images/header_back.png', //6
    'assets/images/header_logo.png', //7
    'assets/images/header_girl.png', //8
    'assets/images/header_boy.png', //9
    'assets/images/header_fav.png', //10
    'assets/images/search.png', //11
    'assets/images/blue_share.png', //12
    'assets/images/blue_heart.png', //13
    'assets/images/blue_copy.png', //14
  ];
  myImage({required String path, required BoxFit type}) {
    return Image.asset(
      path,
      fit: type,
    );
  }

  setbackGround(bool isMale) {
    return isMale
        ? myImage(path: images[0], type: BoxFit.fill)
        : myImage(path: images[1], type: BoxFit.fill);
  }
}

List<Names> favList = [];

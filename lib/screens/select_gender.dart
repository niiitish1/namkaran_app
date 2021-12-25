import 'package:flutter/material.dart';
import 'package:namkaran_app/const/same_method.dart';
import 'package:namkaran_app/screens/favourite.dart';
import 'package:namkaran_app/screens/home_name.dart';

class SelectGender extends StatelessWidget {
  SelectGender({Key? key}) : super(key: key);
  final method = Same();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              child: method.myImage(path: method.images[1], type: BoxFit.fill)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              method.myImage(path: method.images[5], type: BoxFit.none),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Home(false)));
                      },
                      child: method.myImage(
                          path: method.images[4], type: BoxFit.none),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Home(true)));
                      },
                      child: method.myImage(
                          path: method.images[2], type: BoxFit.none),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const FavouriteScreen()));
                },
                child:
                    method.myImage(path: method.images[3], type: BoxFit.none),
              ),
            ],
          )
        ],
      ),
    );
  }
}

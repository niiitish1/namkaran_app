import 'package:flutter/material.dart';
import 'package:namkaran_app/const/same_method.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite')),
      body: SafeArea(
        child: ListView.builder(
          itemCount: favList.length,
          itemBuilder: (_, index) {
            if (favList.isEmpty) {
              return const Center(
                child: Text('no favourite added'),
              );
            } else {
              return ListTile(
                title: Text(favList[index].name),
              );
            }
          },
        ),
      ),
    );
  }
}

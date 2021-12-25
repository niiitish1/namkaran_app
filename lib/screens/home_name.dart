import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namkaran_app/const/same_method.dart';
import 'package:http/http.dart' as http;
import 'package:namkaran_app/models/category.dart';
import 'package:namkaran_app/models/names.dart';
import 'package:namkaran_app/screens/favourite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  bool isMale;

  Home(this.isMale, {Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<CasteCategory> casteCategory = [];
  List<Names> nameList = [];
  final method = Same();
  int gender = 0;
  late String link;
  late SharedPreferences preferences;

  @override
  void initState() {
    widget.isMale ? gender = 1 : gender = 2;
    super.initState();
    init();
    callCasteCategoryApi();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            child: method.setbackGround(widget.isMale),
          ),
          if (casteCategory.isEmpty) ...[
            const Center(
              child: CircularProgressIndicator(),
            )
          ],
          DefaultTabController(
            length: casteCategory.length,
            child: Builder(builder: (context) {
              final tabController = DefaultTabController.of(context)!;
              tabController.addListener(() {
                switch (tabController.index) {
                  case 0:
                    callNameListApi(3, gender);
                    break;
                  case 1:
                    callNameListApi(8, gender);
                    break;
                  case 2:
                    callNameListApi(10, gender);
                    break;
                }
              });
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: buildAppbar(),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TabBarView(
                    children: List.generate(
                      casteCategory.length,
                      (index) {
                        if (nameList.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: nameList.length,
                          itemBuilder: (context, nameIndex) {
                            return buildName(nameIndex);
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  callCasteCategoryApi() {
    casteCategory.clear();
    http
        .get(Uri.parse(
            'http://mapi.trycatchtech.com/v1/naamkaran/category_list'))
        .then((resp) {
      var jsonResp = jsonDecode(resp.body) as List;
      for (var itemDict in jsonResp) {
        casteCategory.add(CasteCategory.fromJson(itemDict));
      }
      setState(() {});
      callNameListApi(3, gender);
    });
  }

  callNameListApi(int category, int gender) async {
    List<Names> temp = [];
    link =
        'https://mapi.trycatchtech.com/v1/naamkaran/post_list_by_cat_and_gender?category_id=$category&gender=$gender';

    http.get(Uri.parse(link)).then((resp) {
      var jsonResp = jsonDecode(resp.body) as List;
      for (var item in jsonResp) {
        temp.add(Names.fromJson(item));
      }
      setState(() {
        nameList.clear();
        nameList.addAll(temp);
        temp.clear();
      });
    });
  }

  Widget buildName(int index) {
    final data = nameList[index];
    bool isContain = false;
    for (var i = 0; i < favList.length; i++) {
      if (favList[i].name.contains(data.name)) {
        isContain = true;
        break;
      }
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  data.meaning,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                int favListIndexNo = -1;
                mainLoop:
                for (var i = 0; i < favList.length; i++) {
                  if (favList[i].name.contains(data.name)) {
                    favListIndexNo = i;
                    break mainLoop;
                  }
                }
                if (favListIndexNo == -1) {
                  favList.add(data);
                  preferences.setString('data', jsonEncode(favList));
                } else {
                  favList.removeAt(favListIndexNo);
                  preferences.setString('data', jsonEncode(favList));
                }
              });
            },
            child: isContain
                ? const Icon(
                    Icons.check,
                    color: Colors.red,
                  )
                : Image.asset(
                    method.images[13],
                    scale: 2,
                  ),
          ),
          GestureDetector(
            onTap: () async {
              Clipboard.setData(ClipboardData(text: nameList[index].name));
              Clipboard.getData(Clipboard.kTextPlain).then((value) {
                if (value != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Text cpoied.. ${value.text}')));
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Image.asset(
                method.images[14],
                scale: 2,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              method.images[12],
              scale: 2,
            ),
          ),
        ],
      ),
    );
  }

  init() async {
    preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('data');
    if (data != null) {
      var jsnString = jsonDecode(data) as List;
      for (var item in jsnString) {
        favList.add(Names.fromJson(item));
      }
    } else {
      print('data is not there in sharedprefrence');
    }
  }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            method.images[6],
            scale: 3,
          ),
        ),
      ),
      title: Image.asset(
        method.images[7],
      ),
      actions: [
        Image.asset(
          method.images[8],
          width: 44,
        ),
        Image.asset(
          method.images[9],
          width: 44,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FavouriteScreen()));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Image.asset(
              method.images[10],
              width: 25,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showSearch(
                context: context, delegate: CustomSearchDelegate(nameList));
          },
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              method.images[11],
              width: 25,
            ),
          ),
        )
      ],
      bottom: TabBar(
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onTap: (index) {},
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              width: 5.0,
              color:
                  widget.isMale ? Colors.blue.shade900 : Colors.pink.shade900),
          insets: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: List.generate(
            casteCategory.length,
            (index) => GestureDetector(
                  onTap: () {},
                  child: Text(
                    '${casteCategory[index].catName}',
                  ),
                )),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<Names> nameList;
  CustomSearchDelegate(this.nameList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Names> searchQuery = [];
    for (var item in nameList) {
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        searchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: searchQuery.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(searchQuery[index].name),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Names> searchQuery = [];
    for (var item in nameList) {
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        searchQuery.add(item);
      }
    }
    if (searchQuery.isEmpty) {
      return const Center(child: Text('No data Found'));
    } else {
      return ListView.builder(
        itemCount: searchQuery.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(searchQuery[index].name),
          );
        },
      );
    }
  }
}

import 'package:clone_pinterest/models/pinterest_model.dart';
import 'package:clone_pinterest/services/detail_service_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../services/http_service.dart';

class SearchPage extends StatefulWidget {
  static const String id = "search_page";

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<PinterestModel> pinteresModel = [];
  int pageNumber = 0;
  bool isLoading = false;
  bool typing = false;
  String search = "";

  void searchPost() async {
    if (search.isEmpty) {
      search = "All";
      _controller.text = " ";
    }
    pageNumber += 1;

    String? response = await Network.GET(
        Network.API_SEARCH, Network.paramsSearch(search, pageNumber));
    List<PinterestModel> newPinterestModel =
    Network.parseSearchParse(response!);
    setState(() {
      if (pageNumber == 1) {
        pinteresModel = newPinterestModel;
      } else {
        pinteresModel.addAll(newPinterestModel);
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        searchPost();
      }
    });
  }

  late int selectedBottomIcon = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          margin: const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              Flexible(
                  child: TextField(
                    onTap: () {
                      setState(() {
                        typing = true;
                      });
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        isLoading = true;
                        if (search != _controller.text.trim()) pageNumber = 0;
                        search = _controller.text.trim();
                      });
                      searchPost();
                    },
                    style: const TextStyle(fontSize: 20),
                    controller: _controller,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.only(left: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(50),

                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: Colors.white)
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        hintText: "Search",
                        hintStyle: TextStyle(
                            fontSize: 18, color: Colors.grey.shade500),
                        prefixIcon: const Icon(
                          Icons.youtube_searched_for, color: Colors.black, size: 30,),
                        suffixIcon: const Icon(Icons.linked_camera,
                          color: Colors.black,
                          size: 28,)
                    ),
                  )),
              typing ? InkWell(onTap: () {
                setState(() {
                  typing = false;
                  pinteresModel.clear();
                  _controller.clear();
                  pageNumber = 0;
                });
              },
                child: const Text("", style: TextStyle(fontSize: 17),),)
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
      body: Container(padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isLoading ? const CupertinoActivityIndicator()
                : const SizedBox.shrink(),
            Expanded(
                child: MasonryGridView.count(
                  itemCount: pinteresModel.length,
                    crossAxisSpacing: 8,
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    itemBuilder: (context, index){
                    return GridWidget(pinterestModel: pinteresModel[index], search: search,);
                    }
                ))

          ],
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                splashRadius: 1,
                onPressed: () {
                  Navigator.of(context).pop(0);

                  setState(() {
                    selectedBottomIcon = 0;
                  });
                },
                iconSize: 35,
                icon: Icon(
                  Icons.home_filled,
                  color: (selectedBottomIcon == 0) ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                splashRadius: 1,
                onPressed: () {
                  setState(() {
                    selectedBottomIcon = 1;
                  });
                },
                iconSize: 35,
                icon: Icon(
                  Icons.search_sharp,
                  color: (selectedBottomIcon == 1) ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                splashRadius: 1,
                onPressed: () {
                  setState(() {
                    selectedBottomIcon = 2;
                  });
                },
                iconSize: 25,
                icon: Icon(
                  Icons.message_outlined,
                  color: (selectedBottomIcon == 2) ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBottomIcon = 3;
                  });
                },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 1,
                        color: (selectedBottomIcon == 3)
                            ? Colors.black
                            : Colors.transparent,
                      ),
                      image: const DecorationImage(
                        image: AssetImage(
                            "assets/images/image/img_emoji_boy.jpeg"),
                        fit: BoxFit.cover,
                      )),
                ),
              )
            ],
          )),
    );
  }
}

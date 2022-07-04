import 'package:clone_pinterest/functions/function.dart';
import 'package:clone_pinterest/models/pinterest_model.dart';
import 'package:clone_pinterest/pages/search_page.dart';
import 'package:clone_pinterest/services/http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  static const String id = "HomePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currenMax = 20;
  int selectIndex = 0;
  final PageController pageController = PageController();
  bool isLaoding = false;
  bool isLaodPage = false;
  List<PinterestModel> posts = [];
  int postLength = 0;
  int selectedBottomIcon = 0;
  final ScrollController _scrollController = ScrollController();

  void _apiLoadList() async {
    setState(() {
      isLaodPage = true;
    });
    await Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((respomse) => {_showRespomse(respomse!)});
  }

  void _showRespomse(String response) {
    setState(() {
      isLaodPage = false;
      posts = Network.parseResponse(response);
      posts.shuffle();
      postLength = posts.length;
    });
    print(posts);
  }

  void fetchPosts() async {
    setState(() {
      isLaoding = true;
    });
    int pageNumber = (posts.length ~/ postLength + 1);
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber));
    List<PinterestModel> newPosts = Network.parseResponse(response!);
    posts.addAll(newPosts);
    setState(() {
      isLaoding = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _apiLoadList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: MaterialButton(
          height: 45,
          minWidth: 100,
          onPressed: () {},
          shape: const StadiumBorder(),
          color: Colors.black,
          child: const Text(
            "Все пины",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),
        body: isLaodPage ? const Center(child: CupertinoActivityIndicator(),) : WillPopScope(
              onWillPop: () async {
                if (selectIndex != 0) {
                  setState(() {
                    selectIndex = 0;
                    pageController.jumpToPage(selectIndex);
                  });
                  return false;
                }
                return true;
              },
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.79,
                    child: MasonryGridView.count(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      crossAxisSpacing: 8,
                      itemCount: posts.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        if (index == posts.length) {
                          return const Align(
                            alignment: Alignment.topCenter,
                            child:  CircularProgressIndicator.adaptive()
                          );
                        }
                        return Functiont.userItem(
                            posts[index], posts[index].urls.regular, context);
                      },
                    ),
                  ),
                  if (isLaoding) const CupertinoActivityIndicator(),
                ],
              )),
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
                  setState(() {
                    selectedBottomIcon = 0;
                  });
                },
                iconSize: 35,
                 icon: Icon(Icons.home_filled, color: (selectedBottomIcon == 0) ? Colors.black : Colors.grey,),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                splashRadius: 1,
                onPressed: () async {
                  var result = await Navigator.of(context).pushNamed(SearchPage.id);
                  setState(() {
                    selectedBottomIcon = int.tryParse("$result") ?? 1;
                  });
                },
                iconSize: 35,
                icon: Icon(Icons.search_sharp, color: (selectedBottomIcon == 1) ? Colors.black : Colors.grey,),
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
                iconSize: 30,
                icon: Icon(Icons.message_outlined, color: (selectedBottomIcon == 2) ? Colors.black : Colors.grey,),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                 onTap: (){
                  setState(() {
                    selectedBottomIcon = 3;
                  });
                 },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(50),

                    border: Border.all(width: 1,color: (selectedBottomIcon == 3) ? Colors.black : Colors.transparent,),
                      image: const DecorationImage(
                    image:
                        AssetImage("assets/images/image/img_emoji_boy.jpeg"),
                    fit: BoxFit.cover,
                  )),
                ),
              )
            ],
          )),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_pinterest/models/pinterest_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../models/pinterest_model.dart';
import '../services/detail_service_page.dart';
import '../services/http_service.dart';

class DetailsPage extends StatefulWidget {
  static const String id = "details_page";
  PinterestModel? pinterestModel;
  String? search;

  DetailsPage({Key? key,  this.pinterestModel, this.search}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<PinterestModel> pinterestModels = [];
  int PinterestModelsLength = 0;
  final ScrollController _scrollController = ScrollController();
  int pageNumber = 0;
  bool isLoading = true;
  bool isLoadPage = false;

  void _apiLoadList() async {
    await Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {_showResponse(response!)});
  }

  void _showResponse(String response) {
    setState(() {
      isLoading = false;
      pinterestModels = Network.parseResponse(response);
      PinterestModelsLength = pinterestModels.length;
    });
  }

  void fetchPinterestModels() async {
    int pageNumber = (pinterestModels.length ~/ PinterestModelsLength + 1);
    String? response =
    await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber));
    List<PinterestModel> newPinterestModels = Network.parseResponse(response!);
    pinterestModels.addAll(newPinterestModels);
    setState(() {
      isLoadPage = false;
    });
  }

  void searchPinterestModel() async {
    pageNumber += 1;
    String? response = await Network.GET(
        Network.API_SEARCH, Network.paramsSearch(widget.search!, pageNumber));
    List<PinterestModel> newPinterestModels = Network.parseSearchParse(response!);
    setState(() {
      pinterestModels.addAll(newPinterestModels);
      isLoading = false;
      isLoadPage = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.search != null ? searchPinterestModel() : _apiLoadList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadPage = true;
        });
        widget.search != null ? searchPinterestModel() : fetchPinterestModels();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  ClipRRect(
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.pinterestModel!.urls.regular,
                          placeholder: (context, url) =>
                              Image.asset("assets/images/image/default.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/image/default.png"),
                        ),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        height: 50,
                        imageUrl: widget.pinterestModel!.user!.profileImage!.large!,
                        placeholder: (context, url) =>
                            Image.asset("assets/images/image/img_default.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/default.png"),
                      ),
                    ),
                    title: Text(widget.pinterestModel!.user!.name!),
                    subtitle:
                    Text(widget.pinterestModel!.likes.toString() + " followers"),
                    trailing: MaterialButton(
                      elevation: 0,
                      height: 40,
                      onPressed: () {},
                      color: Colors.grey.shade200,
                      shape: const StadiumBorder(),
                      child: const Text("Follow"),
                    ),
                  ),
                  widget.pinterestModel!.description != null
                      ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.pinterestModel!.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                      : const SizedBox.shrink(),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/image/message.svg",
                                  height: 30,
                                  color: Colors.black,
                                ),
                                MaterialButton(
                                  elevation: 0,
                                  height: 60,
                                  onPressed: () {},
                                  color: Colors.grey.shade200,
                                  shape: const StadiumBorder(),
                                  child: const Text("View", style: TextStyle(fontSize: 18),),
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  elevation: 0,
                                  height: 60,
                                  onPressed: () {},
                                  color: Colors.red,
                                  shape: const StadiumBorder(),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                const Icon(
                                  Icons.share,
                                  size: 30,
                                ),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                      child: Text(
                        "Comments",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Love this Pin? Let ",
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: widget.pinterestModel!.user!.name!,
                                style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: " know!")
                          ])),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/images/image/img_emoji_boy.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: "Add a comment",
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text("More like this",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: pinterestModels.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 11,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) {
                        return GridWidget(
                          pinterestModel: pinterestModels[index],
                          search: widget.search,
                        );
                      }),
                  isLoading || isLoadPage
                      ? Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black)),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_pinterest/models/pinterest_model.dart';
import 'package:clone_pinterest/pages/detail_page.dart';
import 'package:flutter/material.dart';

class Functiont{
 static PinterestModel? pinterestModel;
  static List bottomSheetText = [
    "Отправить",
    "Facebook",
    "Сообщения",
    "Messenger",
    "Gmail",
    "KaKaoTalk",
    "Telegram",
    "Копировать ссылку",
    "Ещё...",
  ];
  static List bottomSheetImg = [
    "assets/images/image/img_redTelegram.png",
    "assets/images/image/img_facebok_logo1.png",
    "assets/images/image/img_message_logo.jpeg",
    "assets/images/image/img_messenger_logo.jpeg",
    "assets/images/image/img_Gmail_round_logo.png",
    "assets/images/image/img_kakaotalk-logo.png",
    "assets/images/image/img_telegram_logo.png",
    "assets/images/image/img_copy_logo.png",
    "assets/images/image/img_more_logo.jpeg",

  ];

 static  userItem(PinterestModel pinterestModel, String image, BuildContext context,) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
         MaterialPageRoute(builder: (context) => DetailsPage(
         pinterestModel: pinterestModel,
         ))
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(

                imageUrl: pinterestModel.urls.regular,
              placeholder: (context,index) =>
                AspectRatio(
                    aspectRatio: pinterestModel.width!/pinterestModel.height!.toInt(),
                  child: Container(
                    color: Colors.black45,
                  ),
                )
                ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              pinterestModel.likes !=0 ?
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10,right: 5),
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/image/img_likeButton.png"),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
               Text(pinterestModel.likes!>1000 ?
                      (pinterestModel.likes!~/1000).toString()+"тыс."
                   :
               (pinterestModel.likes).toString()
               ) ],
              )
                  :
                  const SizedBox.shrink(),
              SizedBox(
                height: 40,
                width: 35,
                child: IconButton(
                    onPressed: () {
                      buttonBottomSheet(context);
                    },
                    icon: const Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.black,
                      size: 20,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
 //
  static buttonBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Padding(
            padding: const EdgeInsets.only(left: 15,right:15,top: 25),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                        image: DecorationImage(

                          image: AssetImage("assets/images/icons/ic_cancel.png"),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                    const SizedBox(width: 20,),
                    const Text("Поделиться",style: TextStyle(fontSize: 17),)
                  ],
                ),
                const SizedBox(height: 20,),
                //#ListView elements
                SizedBox(
                  height: 120,
                  child: makeListViewInBottomSheet(),
                ),
                const Divider(),
                //#Text
                const SizedBox(height: 15,),
                const Text("Скрыть пин",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                const SizedBox(height: 15,),
                const Text("Жалоба на пин",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
                const Text("Не соответствует правилам сообщества\nPinterest",style: TextStyle(fontSize: 16),),
                const SizedBox(height: 20,),
                const Divider(),
                const SizedBox(height: 20,),
                const Text("Этот пин похож на те, которые вы  недавно просматривали",style: TextStyle(fontSize: 16),)



              ],

            ),
          );
        });
  }
  static Widget makeListViewInBottomSheet() {
   return ListView.builder(
     scrollDirection: Axis.horizontal,
     itemCount: bottomSheetImg.length,
     itemBuilder: (BuildContext context, int index) {
       return SizedBox(
         height: 150,
         width: 100,
         child: Column(
           children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(50),
               child: Container(
                 height: 70,
                 width: 70,
                 decoration: BoxDecoration(
                   // border: Border(
                   //   top: 10
                   // ),
                     image: DecorationImage(
                         image: AssetImage(bottomSheetImg[index]),
                         fit: BoxFit.cover
                     )
                 ),
               ),
             ),
             const SizedBox(height: 10,),
             Text(bottomSheetText[index])
           ],
         ),
       );
     },

   );
  }



}
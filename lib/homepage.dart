import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gokul/drawer/drawer.dart';
import 'package:gokul/resources/color.dart';
import 'package:gokul/service/firbaseservice.dart';
import 'package:upgrader/upgrader.dart';
import 'config/config.dart';
import 'listPAge.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Color> colors = [Colors.blue, Colors.red, Colors.pink, Colors.orange];
  final random=Random();
  dynamic banner1;
  final FirebaseService _firebaseService = FirebaseService();
  // List<Category> category=[];
  //
  void setCategory()async{
    banner1=await _firebaseService.fetchDataFromFirestoreBanner();
  }
 @override
  void initState() {
   setCategory();
    print("lenght::::::${banner1?[0]["url"]}");
   // Category newCategory = Category(id: 'category_2', name: 'Rings');
   // _firebaseService.addCategory(newCategory);
   //
   // Product newProduct = Product(id: 'product_2', name: 'rouded', categoryID: 'category_2');
   // _firebaseService.addProduct(newProduct);
    // print(category.length);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          title: const Text("Gokul Jewellers",
              style: TextStyle(fontSize: 20)),
          actions: const [
            InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.shopping_cart,size: 30,),
              ),
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: Stack(
          children: [
            Opacity(
                opacity: MyConfig.opacity,
                child: Image.asset(MyConfig.bg,fit: BoxFit.fill,height: double.infinity )),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('Categories').get(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(banner1.length !=0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0, left: 5, right: 5),
                          child: Card(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 200.0,
                                aspectRatio: 16 / 5,
                                enableInfiniteScroll: true,
                                viewportFraction: 1,
                                enlargeCenterPage: false,
                                reverse: false,
                                autoPlay: true,
                                scrollPhysics: const NeverScrollableScrollPhysics(),
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                              ),
                              items: [
                                for (int i = 0; i < banner1.length; i++)
                                  CachedNetworkImage( imageUrl: banner1?[i]["url"],fit: BoxFit.fill,placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(color: Colors.grey),
                                  ),),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),

                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            itemCount: 3,
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 130,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColor.white,
                                        blurRadius: 0.6,
                                        spreadRadius: 0.9
                                      )
                                    ],
                                  color: AppColor.white,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 14.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Gap(20),
                                        Divider(
                                          color: AppColor.black,
                                          height: 2,
                                          thickness: 4,
                                          endIndent: 30,
                                        ),
                                        Gap(6),
                                        Text("Gold",style: TextStyle(
                                          color: AppColor.textDark,
                                           fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        ),),
                                        Gap(5),
                                        Text("24k(222)",style: TextStyle(
                                            color: AppColor.textDark,
                                            fontSize: 10
                                        ),),
                                        Gap(5),
                                        Text("₹ 60,000 /g",style: TextStyle(
                                            color: AppColor.textDark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19
                                        ),),
                                        Gap(9),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Last updated on",style: TextStyle(
                                              color: AppColor.textLight,
                                              fontSize: 12
                                            ),),

                                            Text("15 dec 2023, 12:56 PM",style: TextStyle(
                                              color: AppColor.textLight,
                                              fontSize: 12
                                            ),),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                          ),
                        ),
                        const SizedBox(height: 15,),
                        const Text("Category",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 7,),
                        Expanded(
                          child: ListView.builder(
                            itemCount:snapshot.data!.docs.length ?? 0,
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),
                            itemBuilder:(context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListWisePage(cat_id: snapshot.data!.docs[index].id.toString(),name: snapshot.data!.docs[index]['name']),));
                                  },
                                  child: Card(
                                    elevation: 5,
                                    //color: colors[random.nextInt(4)].withOpacity(0.4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child:  SizedBox(
                                      height: 140,width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            if(index % 2 ==0)...[
                                              Text(snapshot.data!.docs![index]['name'].toString() ?? " ",maxLines: 1,style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),),
                                              CachedNetworkImage(imageUrl: snapshot.data!.docs![index]['url'].toString(),width: 140,fit: BoxFit.cover,),
                                            ],
                                            if(index % 2 !=0)...[
                                              CachedNetworkImage(imageUrl: snapshot.data!.docs![index]['url'].toString(),width: 140,fit: BoxFit.cover,),
                                              Text(snapshot.data!.docs![index]['name'].toString() ?? " ",maxLines: 1,style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else{
                  return const Center(child: CircularProgressIndicator(color: Colors.grey,));
                }
              }
            ),
          ],
        )
      ),
    );
  }
}

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _userStore = Provider.of<UserStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tìm địa điểm gần bạn..."),
                      InkWell(
                          onTap: () {
                            _userStore.logout();
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.login);
                          },
                          child:
                              Image.asset("assets/images/bell.png", width: 28)),
                    ]),
              ),
              SizedBox(
                height: 30,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Tài khoản",
              //       style: TextStyle(
              //           fontSize: 16,
              //           color: Theme.of(context).primaryColor,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.voucher);
                          },
                          child: Text("3 Voucher",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.request);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/food.png",
                          scale: 0.8,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Mua sắm")
                      ],
                    ),
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/shop.png",
                          scale: 0.8,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Cửa hàng")
                      ],
                    ),
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/qr-code.png",
                          scale: 0.8,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Quét mã")
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/gift-card.png",
                          scale: 0.8,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Quà tặng")
                      ],
                    ),
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/tickets.png",
                          scale: 0.8,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Vé")
                      ],
                    ),
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/healthcare.png",
                          scale: 0.8,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Sức khoẻ")
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     InkWell(
              //       child: Column(
              //         children: [
              //           Image.asset(
              //             "assets/images/utility.png",
              //             scale: 0.8,
              //           ),
              //           SizedBox(
              //             height: 5,
              //           ),
              //           Text("Dịch vụ khác")
              //         ],
              //       ),
              //     ),
              //     Container(),
              //     Container()
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

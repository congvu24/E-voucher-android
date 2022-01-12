import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/data/network/apis/posts/general_api.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //text controllers:-----------------------------------------------------------
  late String name;
  late String identity;
  late String dob;
  late String email;
  late String password;
  late String job;
  late String address;
  late String phone;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    name = "";
    identity = "";
    dob = "";
    email = "";
    password = "";
    job = "";
    address = "";
    phone = "";
  }

  TextEditingController dob_controller = new TextEditingController();

  GeneralApi _api = getIt<GeneralApi>();

  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  void onSubmit() async {
    if (name.length == 0 ||
        identity.length == 0 ||
        dob_controller.text.length == 0 ||
        password.length == 0 ||
        job.length == 0 ||
        address.length == 0) {
      _showErrorMessage("Thông tin chưa đủ!");
    } else {
      try {
        setState(() {
          loading = true;
        });
        await _api.signup({
          "name": name,
          "identify": identity,
          "dob": dob_controller.text,
          "password": password,
          "job": job,
          "address": address,
          "email": email,
          "phone": phone
        });
        Navigator.of(context).pop();
        // FlushbarHelper.createSuccess(
        //   message: "Đăng ký thành công!",
        //   title: "Chào mừng",
        //   duration: Duration(seconds: 3),
        // )..show(context);

        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Đăng ký thành công'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text('Cảm ơn bạn đã đăng ký tài khoản'),
                      Text(
                          'Bạn cần kiểm tra email để xác thực email trước khi tiếp tục.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Đóng'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } catch (err) {
        _showErrorMessage("Có lỗi trong quá trình đăng ký");
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildLeftSide(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : Center(child: _buildRightSide()),
          Visibility(
            visible: loading,
            child: CustomProgressIndicatorWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIconWidget(image: 'assets/images/applogo.png'),
            SizedBox(height: 24.0),
            TextFieldWidget(
              hint: "Họ tên",
              inputType: TextInputType.text,
              icon: Icons.person,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              inputAction: TextInputAction.next,
              autoFocus: false,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextFieldWidget(
              hint: "CMND/CCCD",
              isObscure: false,
              icon: Icons.payment,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              onChanged: (value) {
                setState(() {
                  identity = value;
                });
              },
            ),
            TextFieldWidget(
              hint: "Ngày sinh",
              isObscure: false,
              icon: Icons.calendar_today,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              textController: dob_controller,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1800),
                  lastDate: DateTime(2022),
                );
                if (picked != null)
                  dob_controller.text = DateFormat('yyyy-MM-dd').format(picked);
              },
            ),
            TextFieldWidget(
              hint: "Email",
              isObscure: false,
              icon: Icons.email,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFieldWidget(
              hint: "Điện thoại",
              isObscure: false,
              icon: Icons.phone,
              inputType: TextInputType.phone,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
            ),
            TextFieldWidget(
              hint: "Password",
              isObscure: true,
              icon: Icons.lock,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            TextFieldWidget(
              hint: "Công việc",
              icon: Icons.card_travel_rounded,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              onChanged: (value) {
                setState(() {
                  job = value;
                });
              },
            ),
            TextFieldWidget(
              hint: "Địa chỉ",
              icon: Icons.home,
              padding: EdgeInsets.only(top: 16),
              iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              onChanged: (value) {
                setState(() {
                  address = value;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            _buildSignInButton(),
            SizedBox(
              height: 30,
            ),
            Center(
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Trở lại đăng nhập."))),
          ],
        ),
      ),
    );
  }

  // Widget _buildPasswordField() {
  //   return Observer(
  //     builder: (context) {
  //       return ;
  //     },
  //   );
  // }

  // Widget _buildUserPhoneField() {
  //   return Observer(
  //     builder: (context) {
  //       return ;
  //     },
  //   );
  // }

  Widget _buildSignInButton() {
    return RoundedButtonWidget(
      buttonText: "Đăng ký",
      buttonColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: onSubmit,
    );
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: "Lỗi",
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    super.dispose();
  }
}

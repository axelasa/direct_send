import 'package:direct_send/utill/app_button.dart';
import 'package:direct_send/utill/app_color.dart';
import 'package:direct_send/utill/app_input.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_share_plus/open.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController messagesController = TextEditingController();
  String cpp = '';
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    authenticateApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            IntlPhoneField(
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              languageCode: "en",
              initialCountryCode: 'KE',
              onChanged: (phone) {
                cpp = phone.completeNumber;
              },
              onCountryChanged: (country) {
                debugPrint('Country changed to: ${country.name}');
              },
            ),
            AppInput(
              label: 'Enter your text',
              type: TextInputType.multiline,
              controller: messagesController,
            ),
            AppButton(
              textColor: Colors.white,
              backgroundColor: AppColors.mainColor,
              borderColor: AppColors.mainColor,
              text: 'Send Message',
              onClicked: () async {
                Open.whatsApp(whatsAppNumber: cpp, text:messagesController.text);
              },
            )
          ],
        ),
       ),),
    );
  }
  authenticateApp()async{
    if (!_isAuthenticated){
      final bool canAuthenticateWithBiometrics =
      await _auth.canCheckBiometrics;
      if(canAuthenticateWithBiometrics){
       try{
         final bool didAuthenticate = await _auth.authenticate(
           localizedReason: 'Please Authenticate to proceed',
           options: const AuthenticationOptions(
             biometricOnly: false,
             useErrorDialogs:true,
             stickyAuth: true,
           ),
         );
         setState(() {
           _isAuthenticated = didAuthenticate;
         });
       }catch(e){
         debugPrint(e.toString());
       }
      }
      debugPrint('$canAuthenticateWithBiometrics');
    }else{
      _isAuthenticated = false;
    }
  }
}
//
// await LaunchApp.openApp(
// androidPackageName:'https://wa.me/+254794227892?text=hello' ,
// iosUrlScheme: 'whatsapp'
// );
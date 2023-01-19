import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/core/resources/styles.dart';
import 'package:earnlia/core/utils/button.dart';
import 'package:earnlia/core/utils/extentions.dart';
import 'package:earnlia/core/utils/textformfield.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:earnlia/features/login/domain/entities/login_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:info_popup/info_popup.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/home/domain/entities/reword.dart';
import '../services/cache.dart';

class C {
  static Future<void> share(
      {required String title,
      required String text,
      required String link}) async {
    await FlutterShare.share(
      title: title,
      text: text,
      linkUrl: link,
    );
  }

  static snackBar(context, {required String message, Color? color}) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void toast({required String text, Color? color}) {
    Fluttertoast.showToast(msg: text, backgroundColor: color);
  }

  static String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  static earnDialog(
    context,
    RewordEntity reword, {
    int? index,
  }) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    GlobalKey<FormState> form = GlobalKey();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    String capatcha = getRandomString(5);
    Dialog dialog = Dialog(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(reword.name,
                  style: AppStyles.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Text(
                reword.description,
                style: AppStyles.normal(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please write again this char',
                        style: AppStyles.normal(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Transform.rotate(
                              angle: 0.2 * index - 0.3,
                              filterQuality: FilterQuality.high,
                              child: Text(
                                capatcha.split('')[index],
                                style: AppStyles.medium(),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: capatcha.split('').length,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: DefTextformfield(
                    hintText: 'Code',
                    icon: const Icon(Icons.verified_outlined),
                    validator: (String? val) {
                      if (val!.toLowerCase() != capatcha.toLowerCase()) {
                        return 'Not similar';
                      }
                      return null;
                    },
                    controller: TextEditingController()),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0a1e67),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11))),
                      onPressed: () async {
                        if (form.currentState!.validate()) {
                          if (await canLaunchUrl(Uri.parse(reword.adUrl))) {
                            Navigator.pop(context);
                            launchUrl(
                              Uri.parse(reword.adUrl),
                              mode: LaunchMode.externalApplication,
                            );
                            Future.delayed(
                                const Duration(
                                  minutes: 1,
                                ), () async {
                              HomeCubit.get(context).updateBalance(
                                amount: reword.amount,
                              );
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(Cache.getData(key: 'uId'))
                                  .collection('rewords')
                                  .doc(HomeCubit.get(context).id[index!])
                                  .delete();
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Go',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd9d9d9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
    showCupertinoDialog(
      context: context,
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: dialog,
      ),
    );
  }

  static appSheet(context, GameEntity gameEntity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                gameEntity.gameImage,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(gameEntity.gameName,
                  style: AppStyles.copyWith(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to get the reword?',
                          style:
                              AppStyles.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        gameEntity.description,
                        style: AppStyles.normal(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Prize',
                                  style: AppStyles.copyWith(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              color: Colors.grey,
                              height: 40,
                              width: 1,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  gameEntity.amount.toString(),
                                  style: AppStyles.normal(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  AppAssets.C,
                                  width: 20,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80.h,
                      ),
                      DefButton(
                        label: 'Play',
                        onPressed: () async {
                          if (await canLaunchUrl(
                              Uri.parse(gameEntity.gameUrl))) {
                            launchUrl(Uri.parse(gameEntity.gameUrl),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        height: 45,
                      ),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }

  static ShaderMask sweetIcon(
      {required List<Color> iconColors,
      Alignment? begin,
      Alignment? end,
      required Widget icon}) {
    return ShaderMask(

        /// Creating a shader for the icon provided.
        shaderCallback: (rect) => LinearGradient(
                colors: iconColors,
                begin: begin ?? Alignment.topCenter,
                end: end ?? Alignment.bottomCenter)
            .createShader(rect),
        child: icon);
  }

  static void showPaypalDialog(BuildContext context,
      {required LogInEntity user}) {
    TextEditingController controller = TextEditingController();
    GlobalKey<FormState> form = GlobalKey();
    Dialog dialog = Dialog(
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: const [
                  Text('Paypal'),
                  SizedBox(
                    width: 10,
                  ),
                  InfoPopupWidget(
                    contentTitle:
                        'if this data is not true You will not be able to recevie your money',
                    arrowTheme: InfoPopupArrowTheme(
                      color: Colors.black,
                      arrowDirection: ArrowDirection.up,
                    ),
                    contentTheme: InfoPopupContentTheme(
                      infoContainerBackgroundColor: Colors.black,
                      infoTextStyle:
                          TextStyle(color: Colors.white, fontSize: 10),
                      contentPadding: EdgeInsets.all(8),
                      contentBorderRadius:
                          BorderRadius.all(Radius.circular(10)),
                      infoTextAlign: TextAlign.center,
                    ),
                    dismissTriggerBehavior:
                        PopupDismissTriggerBehavior.anyWhere,
                    areaBackgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (HomeCubit.get(context).balance.fromCtoUSD() >= 25)
                Form(
                  key: form,
                  child: Column(
                    children: <Widget>[
                      DefTextformfield(
                          hintText: 'Paypal account',
                          icon: const Icon(Icons.money),
                          validator: (String? value) {
                            if (controller.text.isEmpty) {
                              return 'Write your Paypal account Email';
                            }
                            return null;
                          },
                          controller: controller),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(100.w, 40.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22)),
                            ),
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                HomeCubit.get(context)
                                    .sendPaypalAccount(controller.text);
                                toast(text: 'Sent successfully');
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Send'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(100.w, 40.h),
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              if (HomeCubit.get(context).balance.fromCtoUSD() < 25)
                Column(
                  children: <Widget>[
                    const Icon(
                      Icons.lock,
                      size: 80,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        'You still need ${(25 - HomeCubit.get(context).balance.fromCtoUSD()).toStringAsFixed(2)} \$')
                  ],
                )
            ],
          ),
        ),
      ),
    );
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return dialog;
      },
    );
  }

  static void showBankDialog(context, {required LogInEntity user}) {
    Dialog dialog = Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: const [
                Icon(Icons.attach_money),
                SizedBox(
                  width: 10,
                ),
                Text('Bank'),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            if (HomeCubit.get(context).balance.fromCtoUSD() >= 25)
              Column(
                children: [
                  const Icon(
                    Icons.not_accessible,
                    size: 80,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Bank Transfer is not available now !',
                    style: AppStyles.normal(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            if (HomeCubit.get(context).balance.fromCtoUSD() < 25)
              Column(
                children: <Widget>[
                  const Icon(
                    Icons.lock,
                    size: 80,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      'You still need ${(25 - HomeCubit.get(context).balance.fromCtoUSD()).toStringAsFixed(2)} \$')
                ],
              )
          ],
        ),
      ),
    );
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return dialog;
      },
    );
  }
}

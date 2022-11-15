import 'dart:math';

import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/core/resources/styles.dart';
import 'package:earnlia/core/utils/button.dart';
import 'package:earnlia/core/utils/textformfield.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../features/home/domain/entities/reword.dart';

class C {
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
              //TODO: I'm not a Robot capatcha
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
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          print('Gone');
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
    GlobalKey<FormState> form = GlobalKey();

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
                        label: 'Download',
                        onPressed: () {},
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
}

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/custom_pet_modal.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void showTodoDoneModal(BuildContext context) {
  Size screen = MediaQuery.of(context).size;
  Item pet = context.read<UserInfo>().mainPet;

  Widget background = SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Lottie.asset(
      'assets/todo/confetti.json',
    ),
  );

  showCustomFullScreenModal(
    context: context,
    builder: (context) => MyPetModal(
      pet: pet,
      screen: screen,
      title: '오늘의 첫 할일 달성!',
      backgroud: background,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("남은 할일도 모두 달성해보자👊"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Lottie.asset(
                    'assets/todo/coin.json',
                    width: 40,
                    height: 40,
                  ),
                ),
                Text(
                  "+100",
                  style: TextStyle(
                    color: Color(0xfff08636),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
          MyButton(
            // full: true,
            onpressed: (_) => Navigator.pop(context),
            text: "닫기",
          ),
        ],
      ),
    ),
  );
}

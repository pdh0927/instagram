import 'package:flutter/material.dart';

var _var1;  // _를 붙이면 다른 파일에서 사용 x

var theme = ThemeData( // = style tag  // 모든 것들에 적용(통일성 good)
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey,
        )
    ),
    appBarTheme: AppBarTheme( // appbar 안에 아이콘 넣으면 appBarTheme이 가깝기 때문에 aooBarTheme을 따라감
      backgroundColor: Colors.white,
      elevation: 2, // 그림자 효과 같은거
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 25
      ),
      actionsIconTheme: IconThemeData(
        color:Colors.black,
        size: 30,
      ),
    ),

    textTheme: TextTheme(
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 2,
        selectedIconTheme: IconThemeData(
            color: Colors.black,
            size: 20
        ),
        unselectedIconTheme: IconThemeData(
            color: Colors.grey,
            size: 20
        )
    )

);
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance; // for 인증
final firestore = FirebaseFirestore.instance; // for data

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async{

    // 유저 가입
    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: "kim@test.com",
        password: "123456",
      );
      result.user?.updateDisplayName('donghwan');
      print(result.user);
    } catch (e) {
      print(e);
    }

    // user login
    try {
      await auth.signInWithEmailAndPassword(
          email: 'kim@test.com',
          password: '123456'
      );
    } catch (e) {
      print(e);
    }

    if(auth.currentUser?.uid == null){
      print('로그인 안된 상태군요');
    } else {
      print('로그인 하셨네');
    }


    // user logout
    await auth.signOut();

    if(auth.currentUser?.uid == null){
      print('로그인 안된 상태군요');
    } else {
      print('로그인 하셨네');
    }

    // var result=  await firestore.collection('product').doc('qt4BUz1Suna81vT96RFE').get();  // doc안의 document의 자료 가져오기
    var result =  await firestore.collection('product').get(); // 모든 자료 가져오기

    if(result.docs.isNotEmpty) {  // 중요한 예외처리(무조건 해야함)
      for(var doc in result.docs) {
        print(doc['name']);
      }

      print(result.docs[1]['price']);

      var result3 = await firestore.collection('product').where('price', isLessThan: 10000).get();
      for(var doc in result3.docs) {
        print(doc['name']);
        print(doc['price']);
      }

      // await firestore.collection('product').doc().delete();  // 고쳐야함
      // await firestore.collection('product').doc().update({'name' : '이름'}); // 고쳐야함
    }

    try{  // 예외처리 다른 방법
      var result2 =  await firestore.collection('product').get(); // 모든 자료 가져오기
      for(var doc in result2.docs) {
        print(doc['name']);
      }
    }catch(e) {
      print('에러남');
      print(e);
    }
  }

  saveData() async {
    // 저장 실패시 대비해서 얘외처리 해야함
    await firestore.collection('product').add({'name' : '빤스', 'price' : 5000});
    await firestore.collection('product').add({'name' : '맨투맨', 'price' : 22000});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Text('샵 페이지임!!'),
    );
  }
}

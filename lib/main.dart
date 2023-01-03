import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './style.dart' as style;  // ./ -> 현재 경로 // as 사용해서 변수 중복 피하기
import 'package:http/http.dart' as http;
import 'dart:convert';  // 여러 유용한 함수 많음
// import 'package:flutter/rendering.dart'; // 스크롤 관련 유용한 함수들이 들어있음
// for image upload
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'notification.dart';

void main() {
  runApp(
    // 2. store 원하는 위젯에 등록하기
    //   ChangeNotifierProvider(
    //     create: (c) => Store1(),
    //     child: MaterialApp(
    //         theme:style.theme,
    //         home:MyApp()
    //     ),
    //   )
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (c) => Store1()),
        ChangeNotifierProvider(create: (c) => Store2()),
      ],
          child: MaterialApp(
            theme: style.theme,
            home: MyApp(),
          ))
    // MaterialApp(
    //   initialRoute: '/',
    //   routes: {
    //     '/': (context) => Text('첫페이지'),
    //     '/detail': (context) => Text('둘째페이지'), // NAvigator.pushNamed(context, 'detail') --> /detail 페이지로 이동
    //   },
    // );
  );
}

var a = TextStyle();  // 변수에 넣어서 쓰기도 가능

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // 1. state tab 현재 상태 저장
  var tab = 0; // tab이 0이면 home, tab이 1이면 shop 등
  var content = [];
  var userImage;

  saveData() async {
    var storage = await SharedPreferences.getInstance();  // 저장공간 오픈
    storage.setString('name', 'donghwan'); // name이라는 이름으로 donghwan 값 저장
    storage.setBool('bool', true);

    var result = storage.getString('name');
    print(result);

    storage.remove('name');
    result = storage.getString('name'); // 자료 삭제
    print(result);

    // map 저장
    var map = {'age' : 26};
    storage.setString('map', jsonEncode(map));
    result = storage.getString('map');
    if(result != null) {
      print(jsonDecode(result));
    }

  }

  getData() async {
    var resultJson = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    print(resultJson.body); // 큰따옴표가 많으면 json

    var result = jsonDecode(resultJson.body);

    setState(() {
      content = result;
    });
  }

  addData(data){
    setState(() {
      content.add(data);
    });
  }

  post(data) {
    setState(() {
      content.insert(0, data);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    saveData();
    initNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'), onPressed: (){
        showNotification2();
      },),
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            icon:Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if(image != null) {
                setState(() {
                  userImage = File(image.path); // image 경로 저장
                });
              }

              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => Upload(userImage: userImage, post: post,))  // return 이랑 중괄호 생략해서 =>로 대체(Arrow Function)
              ); // MaterialApp에 들어있는 context
            },
          )
        ],
      ),


      body: [Home(content: content, addData: addData,), Text('샵페이지')][tab],  // 2. state에 따라 tab이 어떻게 보일지
      // body: Text('안녕', style: Theme.of(context).textTheme.bodyText2,)  // ThemeData() 찾아서 거기있던 textTheme > bodyText2 가져와 달라는 뜻
      // body: Theme(
      //   data: ThemeData( // 자식부터는 theme data의 style 적용
      //     textTheme:
      //   ),
      //   child: Container()
      // ),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){ // 3. 유저들도 state 조작 쉽게 버튼 기능 같은거 만들기  // i -> 지금 누른 버튼의 번호
          setState(() {
            tab = i;
          });
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.content, this.addData}) : super(key: key);
  final content;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();  // scroll에 관한 정보 변수

  getMoreData() async {
    var addContent = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));

    var result = jsonDecode(addContent.body);

    widget.addData(result);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() { // 왼쪽 변수가 변할 때 마다 괄호 안으 함수 실행
      print(scroll.position.pixels);  // 스크롤 관련 여러 변수로 정보 찾아서 활용
      if(scroll.position.pixels == scroll.position.maxScrollExtent) {
        print('같음');
        getMoreData();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if(widget.content.isNotEmpty) { // 부모에서 state 변수 가지고 올 때 widget. 붙여야함
      return ListView.builder(itemCount:widget.content.length, controller: scroll, itemBuilder: (c, i) {
        return Column(
          children: [
            widget.content[i]['image'].runtimeType == String
                ? Image.network(widget.content[i]['image']) //  = Image.network('웹사이트 주소')  // http부터 시작하는 이미지만 가능
                : Image.file(widget.content[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding:EdgeInsets.all(20),
              width:double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      child: Text(widget.content[i]['user']),
                      onTap: () {
                        Navigator.push(context,
                            // CupertinoPageRoute(builder: (c)=> Profile()));
                            // MaterialPageRoute(builder: (c)=> Profile()));
                            PageRouteBuilder(pageBuilder: (c, a1, a2)=> Profile(),
                                transitionsBuilder: (c, a1, a2, child) => // a1 : 새 페이지 전환이 얼마나 되었는지 0 ~ 1로 알려줌 // a2 : 기존 페이지 전환이 얼마나 되었는지 0~1로 알려줌
                                // FadeTransition(opacity:a1, child:child),  // PositionedTransition(), ScaleTransition(), RotationTransition(), SlideTransition()
                                // transitionDuration: Duration(milliseconds:500)  // 페이지 전환 애니메이션 속도조절
                                SlideTransition(position: Tween(
                                  begin: Offset(-1.0, 0.0), // 애니매이션 시작 좌표
                                  end: Offset(0.0, 0.0),  // 애니매이션 끝 좌표
                                ).animate(a1),
                                  child: child,
                                )
                            ));
                      }
                  ),
                  Text('좋아요 ${widget.content[i]['likes']}'), // 데이터가 들어오기도 전에 출력해서 약간 오류가 발생함
                  Text(widget.content[i]['date']),
                  Text(widget.content[i]['content']),
                ],
              ),
            )
          ],
        );
      }
      );
    } else {
      return Text('로딩 중');
    }
  }
}

class Upload extends StatelessWidget {
  Upload({Key? key, this.userImage, this.post}) : super(key: key);
  final userImage;
  final post;
  var inputContent;
  var newPost = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text('image upload page'),
          actions: [
            IconButton(
                icon:Icon(Icons.send),
                onPressed: () {
                  newPost['likes'] = 0;
                  newPost['date'] = "Jan 01";
                  newPost['liked'] = false;
                  newPost['user'] = 'dh';
                  newPost['content'] = inputContent;
                  newPost['image'] = userImage;
                  post(newPost);
                  Navigator.pop(context); // MaterialApp의 context 넣어야함
                }),
            IconButton(
                icon:Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context); // MaterialApp의 context 넣어야함
                }),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage, height: 150),
            TextField(onChanged: (text){inputContent = text; }),
          ],
        )
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Store1>().getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.watch<Store2>().name),
        ),
        // body: Column(
        //     children: [
        //       ProfileHeader()
        //     ]
        // )
        body:CustomScrollView(  // Column을 쓰면 gridView에만 스크롤이 생김
          slivers: [  // slivers 안에는 평소에 쓰던 위젯을 넣지 못함
            SliverToBoxAdapter(
              child: ProfileHeader(),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (c, i)=>Image.network(context.read<Store1>().profileImage[i]) ,
                childCount: context.watch<Store1>().profileImage.length
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            )

          ],
        )
        // body:GridView.builder(
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), // 가로로 몇 개 배치할지
        //   itemBuilder: (c, i){return Container(color: Colors.grey);},
        //   itemCount: 5,
        // )
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().numFollower}명'),
        ElevatedButton(child: Text('팔로우'), onPressed: (){
          context.read<Store1>().pressFollowButton();
        }, )

      ],
    );
  }
}

// 1. state 보관함(store) 만들기
// 이 state 쓰고 싶은 위젯들을 전부 ChangeNotifierProvider()로 감싸야함
class Store1 extends ChangeNotifier {

  var followFlag = false;
  var numFollower = 0;
  var profileImage = [];

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  pressFollowButton() {
    followFlag = !followFlag;
    if(followFlag == false) {
      numFollower--;
    } else {
      numFollower++;
    }
    notifyListeners();
  }

}

class Store2 extends ChangeNotifier {
  var name = 'john kim';
}


// Text()는 bodyText2 가져다 쓰고
// ListTile()은 subtitle1 가져다 쓰고
// TextButton()은 button 가져다 쓰고
// AppBar()는 headline6 가져다 쓰고
// ... 찾아가면서

// 동적 UI 만들기
// 1. state에 UI의 현재상태 저장
// 2. state에 따라서 tab이 어떻게 보일지 작성
// 3. 유저가 쉽게 state 조잘할 수 있게

// FutureBuilder -> 오래 걸리는 놈들 기다렸다가 하는놈 --> 예외처리 안해도됨
// but 한번 데이터 가져오고 끝나는 놈들만 쓰는게 낫지 데이터가 여러개면 좀 빡세다

// 데이터 보존방법
// 1. 서버로 보내서 DB에 저장
// 2. 폰 메모리카드에 저장(shared preferences 이용)
// 중요한건 DB, 덜 중요한건 메모리카드에 저장
// 수신완료한 게시물을 shared preferences에 저장하면 더빨리 load되고 db 부담도 적어짐




import 'package:flutter/material.dart';
import 'quiz_speed.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<String> images = [
    "images/py.png",
    "images/java.png",
    "images/js.png",
    "images/linux.png",
    "images/cpp.png",
  ];

  Widget customCard(String langName, String imageUrl) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GetJson(),
          ));
          //debugPrint('Card Tapped');
        },
        child: Material(
          color: Colors.indigoAccent,
          elevation: 10.0, // Material 의 명암, 그림자 조절
          borderRadius: BorderRadius.circular(25.0), // 레이아웃 둥글게 조정
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      child: ClipOval( // 타원을 이용해 자식을 자르는 클래스
                        child: Image(
                          fit: BoxFit.cover, // 부모 레이아웃에 맞게 이미지의 크기를 적절하게 확대? 축소 하는건데 이거는 사진 규격에 따라 확인해야할 듯
                          image: AssetImage(
                            imageUrl
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    langName,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w700, // font bold 값 조절
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Preparing Explain Text... Sorry :(",
                    style: TextStyle(
                      fontSize:  18.0,
                      color: Colors.white,
                      fontFamily: "Alike"
                    ),
                    maxLines: 5, // Text 가 차지 할 수 있는 최대 세로 길이, 예시로 /n 을 넣어서 6줄을 만들려고 하면 안됨
                    textAlign: TextAlign.justify, // justify 단어들 사이사이 공백을 조금 더 넓게?, center 가운데 정렬, end(right) 우측 정렬, start(left) 좌측 정렬
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown, DeviceOrientation.portraitUp
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QuizStar",
          style: TextStyle(
            fontFamily: "Quando",
          ),
        )
      ),
      body: ListView(
        children: <Widget>[
          customCard("Python", images[0]),
          customCard("Java", images[1]),
          customCard("JavaScript", images[2]),
          customCard("linux", images[3]),
          customCard("C++", images[4]),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'result_page.dart';

// assets 의 json 파일의 데이터를 가져오기 위한 class
class GetJson extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // TODO : dart 언어의 json 파싱 방법 및 list 에 대해 정리해 velog 에 올리기
      future: DefaultAssetBundle.of(context).loadString("assets/python.json"),
      builder: (context, snapshot) {
        List myData = json.decode(snapshot.data.toString());
        if(myData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return QuizPage(myData : myData);
        }
      },
    );
  }
}

// GetJson class 에서 가져온 데이터를 바탕으로 문제 화면을 띄워 주는 클리스
class QuizPage extends StatefulWidget {

  var myData;

  QuizPage({Key key, @required this.myData}) : super(key : key);

  @override
  _QuizPageState createState() => _QuizPageState(myData);
}

class _QuizPageState extends State<QuizPage> {

  int i = 1;
  int marks = 0;
  int timer = 30;
  String showTimer ="30";
  bool cancelTimer = false;

  var myData;
  _QuizPageState(this.myData);

  Color colorToShow = Colors.indigoAccent;
  Color colorRight = Colors.green;
  Color colorWrong = Colors.red;

  Map<String, Color> btnColor = {
    "a" : Colors.indigoAccent,
    "b" : Colors.indigoAccent,
    "c" : Colors.indigoAccent,
    "d" : Colors.indigoAccent,
  };
  
  Widget choiceButton(String key) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        // Todo : function 과 method 의 차이
        // 아마 지역과 전역의 차이 인거 같다.
        onPressed: ()  => checkAnswer(key),
        child: Text(
          myData[1][i.toString()][key],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btnColor[key],
        splashColor: Colors.indigoAccent[700], // 버튼이 touched 처음 눌러졌을 때 주위로 확산되는 색깔?
        highlightColor: Colors.indigo[700], // 버튼 눌렀을때(pressed) 색깔
        minWidth: 200.0,
        height: 45.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown, DeviceOrientation.portraitUp
    ]);
    return WillPopScope(
      onWillPop: (){
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                "QuizStar"
            ),
            content: Text(
              "You can't go back at this stage"
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  myData[0][i.toString()], // myData 는 List<E> 형식이기
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choiceButton('a'),
                    choiceButton('b'),
                    choiceButton('c'),
                    choiceButton('d'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showTimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
   void initState() {
      startTimer();
      super.initState();
   }

  // Todo: Timer class 도 정리하기
  // 메인 쓰레드 어쩌구 하는 거 보면 당연히 동기와 비동기와 관련 된 거 같다.
  // Timer class 에 대해서는 문서를 살펴봐야 하겠지만 (
  void startTimer() async {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextQuestion();
        } else if (cancelTimer) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showTimer = timer.toString();
      });
    });
  }

  // Quiz Page 넘기기
  void nextQuestion() {
    cancelTimer = false;
    timer = 30;
    setState(() {
      if (i < 10) {
        i++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ResultPage(marks : marks),
        ));
      }
      btnColor["a"] = Colors.indigoAccent;
      btnColor["b"] = Colors.indigoAccent;
      btnColor["c"] = Colors.indigoAccent;
      btnColor["d"] = Colors.indigoAccent;
    });
    startTimer();
  }

  // 정답 비교
  void checkAnswer(String key) {
    if (myData[2][i.toString()] == myData[1][i.toString()][key]) {
      marks = marks + 10;
      colorToShow = colorRight;
    } else {
      colorToShow = colorWrong;
    }

    setState(() {
      btnColor[key] = colorToShow;
      cancelTimer = true;
    });

    Timer(Duration(seconds : 2), nextQuestion);
  }
}


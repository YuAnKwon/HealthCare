import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사용자 기본 정보 입력',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('사용자 기본 정보 입력'),
          centerTitle: true,
        ),
        body: UserInfoForm(),
      ),
    );
  }
}

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).viewInsets.bottom 값을 사용하여
    // 키보드가 화면에 표시될 때 필요한 만큼의 하단 패딩을 추가합니다.
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      reverse: true, // 키보드가 열릴 때 입력 필드로 스크롤
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding), // 키보드 높이만큼 패딩 추가
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputBox(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '이름:', border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 10), // 간격 추가
                InputBox(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '나이:', border: InputBorder.none),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 10), // 간격 추가
                InputBox(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '키:', border: InputBorder.none),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 10), // 간격 추가
                InputBox(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '몸무게:', border: InputBorder.none),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 20), // 버튼 위의 간격 추가
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // 폼 제출 로직
                      if (_formKey.currentState?.validate() == true) {
                        // 유효성 검사를 통과하면 실행될 코드
                      }
                    },
                    child: Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class InputBox extends StatelessWidget {
  final Widget child;

  const InputBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}

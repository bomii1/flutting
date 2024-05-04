import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/counter.dart';

class HandleDialogPage extends StatefulWidget {
  const HandleDialogPage({super.key});

  @override
  State<HandleDialogPage> createState() => _HandleDialogPageState();
}

class _HandleDialogPageState extends State<HandleDialogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Be careful!'),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<Counter>().counter == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Count is 3'),
            );
          },
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Handle Dialog'),
      ),
      body: Center(
        child: Text(
          '${context.watch<Counter>().counter}',
          style: const TextStyle(fontSize: 40.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<Counter>().increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


/* 
class _HandleDialogPagesState extends State<HandleDialogPage> {
  @override
  void initState();
  super.initState();
  showDialog(
    context: context,
    builder: (context) {
      return AlerDialog(
        content: Text('Be careful!'),
      );
    }
  );
}

Exception caught by foundation library
-> inherited 위젯이 변경이 되면 디펜던트 위젯들도 리빌트 됨
만약 디펜던트 위젯에 inherited 위젯에 대한 레퍼런스가 컨스트럭터나 initState 
메소드에 있으면 리빌트 된 디펜던트 위젯은 인헤리티드 위젯에서의 변화를 반영 못함

인헤리티드 위젯에 대한 레퍼런스는 빌드 메소드 내에 있어야 함
대안으로 인헤리티드 위젯에 기반한 초기화는 체인지 디펜던시 메소드 내에 있을 수 있다

다이어로그는 오버레이 위젯, 오버레이 위젯은 다른 위젯 위에 표시되는 위젯
다른 위젯이 빌트 되지 않은 상태에서 다이어로그를 표시하라고 한 것
다이어로그 함수의 implemention 을 살펴보면 내부적으로 Navigator.of 함수를 호출함

Widget build(BuildContext context) {
  if (context.read<Counter>().counter == 3) { -> read 를 watch 로 바꾸면? read 와 같은 에러 발생
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog (
          content: Text('Count is 3');
        );
      }
    );
  }
}

Exception caught by foundation library
This Overlay widget cannot be marked as needing to build 
because the framework is already in the process of building widgets.
-> 이미 지금 한창 그리고 있는데 다시 그려달라고 하지 마라

Widget build(BuildContext context) {
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    if (context.read<Counter>().counter == 3) {
    showDialog(
      context: (context),
        builder: (context) {
          return AlertDialog(
            content: Text('count is 3'),
          );
        },
      );
    }
  });

-> context.read 와 context.watch 가 다 동작한 이유는?
build 에 들어오는 순간 값을 체크하는 용도로 사용했기 때문
-> 하지만 watch 는 에러가 남
-> 위젯트리 밖에서 리슨할 필요가 없다
-> 빌드에 진입할 때마다 콜백을 계속해서 레지스터, 별로 바람직한 방법은 아님

*/
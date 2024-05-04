import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int myCounter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Counter>().increment();
      myCounter = context.read<Counter>().counter + 10;
    });
    // Future.delayed(const Duration(seconds: 0), () {
    //   context.read<Counter>().increment();
    //   myCounter = context.read<Counter>().counter + 10;
    // });
    // Future.microtask(() {
    //   context.read<Counter>().increment();
    //   myCounter = context.read<Counter>().counter + 10;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Text(
          'counter: ${context.watch<Counter>().counter}\nmyCounter: $myCounter',
          textAlign: TextAlign.center,
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
setState() or markNeedsBuild() called during build
-> 프레임워크가 이미 위젯들을 빌딩하는 프로세스에 있는데 카운터체인지노티파이어에
카운터 벨류를 표시하는 위젯이 빌드될 필요가 있다고 표시될 수 없다
== 프레임워크가 현재 위젯들을 그리고 있는데 다른 위젯도 그려달라고 하면 안된다는 것

페이지를 렌더링하는 절차(프레임을 렌더링하는 프로세스)
1. BuildContext 를 만든다
2. initState
3. ChangeDependencies 
4. Build 호출
-> 페이지 완성

페이지가 완성되고 나면 다른 것을 그리게 할 수 있다
주의해야할 점
-> initState 가 호출되는 것은 페이지 렌더링 프로세스 도중이다
-> 그래서 컨텍스트를 이용해 화면에 무언가를 그리라고 할 수 없다
그래서 빌드가 완성되기 전에 다른 것을 다시 그리라고 하면 에러 마주침

이런 종류의 에러는 화면에 무언가르 그리라고 하면서 다른 화면으로 이동할 때도 나타남

위와 같은 케이스를 대비해서 사용할 수 있는 것?
addPostFrameCall 메소드
-> 현재 프레임이 완성된 후 등록된 콜백을 실행시켜라
-> ui 에 영향을 미치는 액션의 실행을 현재 프레임 이후로 진행시킴

Exception caught by foundation library
-> 위젯 트리 밖에서 벨류를 리슨하려고 함
-> Provider.of 를 사용할 때 리슨 폴스를 사용해라
*/
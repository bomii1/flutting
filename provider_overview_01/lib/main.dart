import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.blue[100],
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                'MyHomePage',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 20.0),
            CounterA(
              counter: counter,
              increment: increment,
            ),
            const SizedBox(height: 20.0),
            Middle(counter: counter),
          ],
        ),
      ),
    );
  }
}

class CounterA extends StatelessWidget {
  const CounterA({
    required this.counter,
    required this.increment,
    super.key,
  });

  final int counter;
  final void Function() increment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[100],
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            '$counter',
            style: const TextStyle(fontSize: 48.0),
          ),
          ElevatedButton(
            onPressed: increment,
            child: const Text(
              'Increment',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

class Middle extends StatelessWidget {
  const Middle({
    required this.counter,
    super.key,
  });

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CounterB(counter: counter),
          const SizedBox(width: 20.0),
          const Sibling(),
        ],
      ),
    );
  }
}

class CounterB extends StatelessWidget {
  const CounterB({
    required this.counter,
    super.key,
  });

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[100],
      padding: const EdgeInsets.all(10.0),
      child: Text(
        '$counter',
        style: const TextStyle(fontSize: 24.0),
      ),
    );
  }
}

class Sibling extends StatelessWidget {
  const Sibling({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      padding: const EdgeInsets.all(10.0),
      child: const Text(
        'Sibling',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}

/*
카운터 값이 변할때마다 setstate 를 호출 -> 위젯트리가 리빌드 -> 전체 앱 퍼포먼스가 떨어짐
함수에서 셋스테이드x? -> 카운터값만 바뀌고 화면은 바뀌지 x
ui 의 리빌딩 위젯이 실제 실행되는 위젯이 아닌 상위 위젯에 있기 때문에 track 하기 쉽지 x
(어디서 리빌딩이 일어나는지 알기 쉽지 않음)

state mangement -> 위젯에서 필요한 데이터를 쉽게 access 하는 기능과 변한 데이터에 맞춰 ui
를 다시 그리는 기능을 가져야 함
1. dependency injection-> 오브젝트를 위젯트리 상에서 쉽게 access 할 수 있게 해주는
2. synchronizing data and ui -> 데이터와 ui 를 동기화 시키는 것

provider
위젯에 위젯이 아닌 데이터와 메소드를 쉽게 access 하는 방법 제공
데이터가 변경되었을 때 데이터가 변했다는 사실을 데이터를 필요로하는 위젯에 제공하여 리빌딩 될 수 있도록
-> 비니스로직을 ui 와 분리햇다

특이한점: provider 자체가 위젯 -> 위젯 트리 상에 아무곳에나 provider 을 끼워넣을 수 있고 
dot 메소드를 쓸 수 있다
달리 이야기하면 provider 위젯이 아닌 상위 위젯이나 시블링 위젯에서는 provider 을 쓸 수 x

provider 은 플러터에 특화 되어 있어 리덕스와 같은 다른 곳에는 쓸 수 없다
*/
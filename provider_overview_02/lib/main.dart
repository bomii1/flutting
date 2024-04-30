import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      // Dog 인스턴스 create -> 하위 위젯에서 모두 Dog 인스턴스에 access 할 수 있음
      create: (context) => Dog(name: 'Sun', breed: 'Bulldog', age: 3),
      child: MaterialApp(
        title: 'Provider 02',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

// Provider 위젯의 하위 위젯이기 때문에 Dog 인스턴스에 access 할 수 있음
// Provider 에는 of 라는 static 함수가 존재 -> 위젯 트리를 traverse 하면서 원하는 타입의 인스턴스를 찾아서 주는 역할을 함
// 그렇기 때문에 of 함수에는 찾고자 하는 인스턴스의 타입을 줘야 함
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 02'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              // context 를 줘야 함 -> context 를 이용해 위젯 트리를 위로 탐색함
              // Provider.of -> Dog 의 인스턴스를 제공
              '- name: ${Provider.of<Dog>(context).name}',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            const BreedAndAge(),
          ],
        ),
      ),
    );
  }
}

class BreedAndAge extends StatelessWidget {
  const BreedAndAge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '- breed: ${Provider.of<Dog>(context).breed}',
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 10.0),
        const Age(),
      ],
    );
  }
}

class Age extends StatelessWidget {
  const Age({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '- age: ${Provider.of<Dog>(context).age}',
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 20.0),
        // 버튼은 어떤 값이 변한다고 해도 리빌드 될 필요 x -> listen 을 false 로 해서 리빌드를 막아라
        ElevatedButton(
          onPressed: () => Provider.of<Dog>(context, listen: false).grow(),
          child: const Text(
            'Grow',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ],
    );
  }
}

/*
Provider ({
  key? key,
  required Create<T> create, -> create 에 전달된 함수가 리턴하는 오브젝트를 provider 하위 위젯들이 access 할 수 있음
  Dispose<T>? dispose,
  bool? Lazy,
  TransitionBuilder? builder,
  Widget? child
});

Provider.of<type>(context).xx -> 위젯트리를 타고 올라가서 Dog 타입의 인스턴스를 찾아서 줘
Provider.of<T>(context) => T type instance
만약 같은 타입의 인스턴스가 위젯 트리 상에 2개 이상이라면? 
-> 위젯 트리 상 나에게 더 가까운 것을 줌

ChangeNotifier : void 함수
-> 플러터 위젯들은 hangeNotifier 를 extend 하거나 믹싱한 오브젝트 인스턴스를 listen 할 수 있다
-> ChangeNotifier 에는 notifyListeners() 라는 void 함수가 있는데, 이것을 호출하면 
ChangeNotifier 내 데이터에 변동이 생겼을 때 notifyListeners 를 호출하면
listen 하고 있는 모든 오브젝트들의 변동사항을 알려준다

어떻게 사용?
class Counter with ChangeNotifier {
  int counter = 0;

  void increment() {
    counter++;
    notifyListeners();
  }
}

final myCounter();

myCounter.addListener(() {
  print('counter: ${myCounter.counter}');
});
-> addListener 를 통해 callback 함수를 등록, notifierListener 가 실행될 때마다 콜백됨

addListener 를 사용할 때 주의사항
자동으로 dispose 되지 않으니 dispose 를 수동으로 해줘야 함

removeListener 를 사용해 더 이상 필요없는 리스너를 디스포스 시킴

*/
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
    // 하위 모든 위젯에서 Dog 인스턴스를 엑세스 가능 + age 가 변했을 때 ui 리빌드 가능
    return ChangeNotifierProvider<Dog>(
      create: (context) => Dog(name: 'dog04', breed: 'breed04'),
      child: MaterialApp(
        title: 'Provider 04',
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 04'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              // name 은 변하지 않기 때문에 listen 할 필요가 없다
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
          // breed 는 변하지 않기 때문에 listen 할 필요가 없다
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
         // listen: false 를 지운다면? 디버그 콘솔에 에러메세지 표시됨
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
Provider 은 위젯이기 때문에 다른 위젯에서 가능한 것은 가능하다

context.read<T> -> T
- Provider.of<T>(context, listen: false) 와 동일
- 타입 T 오브젝트를 찾아서 리턴해줌

context.watch<T>() -> T
- Provider.of<T>(context) 를 대체
- 타입 T 오브젝트를 찾아서 리턴 + value change 를 리슨

context.select<T, R>(R selector(T value)) -> R
- context.select<Dog, String>((Dog dog) => dog.name) -> 예시임, name 이 변할 때만 리빌드함 == 퍼포먼스 좋음
- 프로퍼티를 많이 가지고 있는 오브젝트의 특정 프로퍼티를 리슨하고 싶을 때 사용
- context.watch 는 오브젝트의 값 하나만 변해도 리빌드를 하는데, context.select 는 
리슨하고 싶은 것만 선별적으로 리슨 가능

*/
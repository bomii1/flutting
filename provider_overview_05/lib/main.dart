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
    return ChangeNotifierProvider<Dog>(
      create: (context) => Dog(name: 'dog05', breed: 'breed05', age: 3),
      child: MaterialApp(
        title: 'Provider 05',
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
        title: const Text('Provider 05'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              // 이 경우 watch 대신에 select 를 써도 무방함
              '- name: ${context.watch<Dog>().name}',
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
          // 엑세스하는 인스턴스의 타입인 Dog, 리턴 타입인 String / 콜백에서 dog.breed 를 리턴
          '- breed: ${context.select<Dog, String>((Dog dog) => dog.breed)}',
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
          // 엑세스하는 인스턴스의 타입인 Dog, 리턴 타입인 Int / 콜백에서 dog.age 를 리턴
          '- age: ${context.select<Dog, int>((Dog dog) => dog.age)}',
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => context.read<Dog>().grow(),
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
MultiProvider

ChangeNotifierProvider<T>(
  create: (context) => T(),
  child: ChangeNotifierProvider<S>(
    create: ChangeNotifierProvider<R>(
      create: (context) => R(),
      child: WidgetA(),
    ),
  ),
)

Syntactic Sugar -> 기능은 똑같은데 문법적으로 더 쉬운

MultiProvider(
  providers: [
    ChangeNotifierProvider<T>(
      create: (context) => T(),
    ),
    ChangeNotifierProvider<S>(
      create: (context) => S(),
    ),
    ChangeNotifierProvider<R>(
      create: (context) => R(),
    ),
  ],
  child: WidgetA(),
)

*/

/*
FutureProvider
-> 위젯트리는 이미 빌드되었는데, 사용하고자 하는 값이 아직 준비되지 않았을 때 사용하는 Provider
위젯트리가 값을 기다려야 한다는 의미

FutureProvider(
  Key? key,
  required Create<Future<T>?> create,
  required initialData,
)
-> 퓨쳐가 리저브 되길 기다릴 동안 이니셜 데이터가 표시되고, 퓨처가 리저브 되면 리빌드 됨
-> 이니셜 데이터로 한 번, 리저브 된 값으로 한 번 총 두번 리빌드 되고 끝
-> 에러가 발생할 수 있는 퓨처를 사용할 경우 캐치를 사용하여 에러를 잡아야 함

FutureBuilder
*/
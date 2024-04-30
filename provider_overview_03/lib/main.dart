import 'package:flutter/material.dart';

import 'models/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider 03',
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
  final dog = Dog(name: 'dog03', breed: 'breed03');

  @override
  void initState() {
    super.initState();
    dog.addListener(dogListener);
  }

  void dogListener() {
    print('age listener: ${dog.age}');
  }

  @override
  void dispose() {
    dog.removeListener(dogListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 03'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '- name: ${dog.name}',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            BreedAndAge(dog: dog),
          ],
        ),
      ),
    );
  }
}

class BreedAndAge extends StatelessWidget {
  const BreedAndAge({
    required this.dog,
    super.key,
  });

  final Dog dog;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '- breed: ${dog.breed}',
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 10.0),
        Age(dog: dog),
      ],
    );
  }
}

class Age extends StatelessWidget {
  const Age({
    required this.dog,
    super.key,
  });

  final Dog dog;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '- age: ${dog.age}',
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => dog.grow(),
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
ChangeNotifierProvider = ChangeNotifier + Provider
1. Create an instance of ChangeNotifier
2. Provide an easy way to access ChangeNotifier for widgets that
need it, and rebuilds the UI if necessary
-> ChangeNotifier 가 필요한 위젯에 쉽게 access 할 수 있는 수단을 제공하고, 
필요하면 UI 를 리빌드한다
1. ChangeNotifier 의 인스턴스를 필요할 때 만든다 -> override 될 수 있다
2. ChangeNotifier 가 필요없어지면 메모리에서 없애준다 -> dispose
1. construct 를 통해서 인스턴스를 전달할 필요없이 Provider.of 를 통해 인스턴스를 
쉽게 접근할 수 있다
2. Provider.of<T>(context) -> 변화를 리슨해서 변화가 있으면 ui 를 리빌드 할 수 있다
Provider.of<T>(context, listen:false) -> ChangeNotifier 의 접근만하고, 변화를 리슨하지 않는다
-> 두 가지의 경우가 필요, 변화를 리슨하는 것이 필요하긴 하지만 ui 를 리빌드하는 경우가 필요하지 않을 때도
있기 때문.
즉, 첫번째는 변화 리슨 + ui 리빌드 모두가 필요한 경우
두번째는 변화 리슨만 필요한 경우
*/
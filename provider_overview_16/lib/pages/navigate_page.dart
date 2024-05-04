import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/counter.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  @override
  Widget build(BuildContext context) {
    if (context.read<Counter>().counter == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OtherPage(),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate'),
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

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Page'),
      ),
      body: const Center(
        child: Text(
          'Other',
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }
}


/*
class _NavigatorPageState extends State<NavigatePage> {
  @Override
  Widget build(BuildContext context) {
    if (context.read<Counter>().counter == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtherPage(),
        ),
      );
    }
  }
}

-> 3이 되면 잠깐 붉은 화면(에러)이 나타났다가 Other 로 이동함

다이어로그를 표시할 때와 마찬가지로 오버레이 위젯이 프레임워크가 그리고 있는 와중에
또 그려달라고 했다는 에러 매세지

네비게이터 푸시도 현재 화면 위에 새로운 화면을 표시하는 거니 당연한 것
*/
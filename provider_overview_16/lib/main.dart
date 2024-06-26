import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/counter_page.dart';
import 'pages/handle_dialog_page.dart';
import 'pages/navigate_page.dart';
import 'providers/counter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      create: (_) => Counter(),
      child: MaterialApp(
        title: 'addPostFrameCallback',
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CounterPage(),
                  ),
                ),
                child: const Text(
                  'Counter Page',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HandleDialogPage(),
                  ),
                ),
                child: const Text(
                  'Handle Dialog Page',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NavigatePage(),
                  ),
                ),
                child: const Text(
                  'Navigate Page',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
ProviderNotFound Exception
-> 새로운 프로바이더를 add 했는데 핫 리스타트 시키지 않아서 에러 / 핫리스타트 시키면 해결됨
-> 라우트 관련
-> 잘못된 빌드 컨텍스트 사용
*/
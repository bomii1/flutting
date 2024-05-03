import 'package:flutter/material.dart';

import 'pages/chgnotiprov_chgnotiproxyprov.dart';
import 'pages/chgnotiprov_proxyprov.dart';
import 'pages/proxyprov_create_update.dart';
import 'pages/proxyprov_proxyprov.dart';
import 'pages/proxyprov_update.dart';
import 'pages/why_proxyprov.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProxyProvider Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
                    builder: (_) => const WhyProxyProv(),
                  ),
                ),
                child: const Text(
                  'Why\nProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProxyProvUpdate(),
                  ),
                ),
                child: const Text(
                  'ProxyProvider\nupdate',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProxyProvCreateUpdate(),
                  ),
                ),
                child: const Text(
                  'ProxyProvider\ncreate/update',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProxyProvProxyProv(),
                  ),
                ),
                child: const Text(
                  'ProxyProvider\nProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChgNotiProvChgNotiProxyProv(),
                  ),
                ),
                child: const Text(
                  'ChangeNotifierProvider\nChangeNotifierProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChgNotiProvProxyProv(),
                  ),
                ),
                child: const Text(
                  'ChangeNotifierProvider\nProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
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
ProxyProvider
-> 어떤 프로바이더에서 다른 프로바이더의 값이 필요할 떄
-> 다른 프로바이더들의 벨류에 의존, 다른 프로바이더들의 벨류가 변하면 새로 만들어야 함
그래서 create 는 한번만 update 는 여러 번 불릴 수 있는 것
-> create 는 옵셔널, 한번만 호출 가능 / update 는 여러 번 호출 가능
-> create 가 옵셔널이 이유는 자체적으로 핸들링을 할 오브젝트가 있을 경우 필요하지만
컴퓨티드 벨류만을 만드는 거라면 create 가 필요가 없음 (다른 프로바이더의 값에 의존해서 새로운 벨류를 만드는 경우가 있음)

update 가 호출되는 경우
1. 프록시 프로바이더가 의존하는 프로바이더의 값을 처음으로 획득했을 때
2. 프록시 프로바이더가 의존하는 프로바더의 값이 바뀔 때마다
3. 프록시 프로바이더가 리빌드 될 때마다

어떤 프로바이더가 변하는 값에 의존하는 경우에도 프록시 프로바이더를 씀
-> 값이 바뀔 때마다 새로운 값을 만들어내야 하기 때문

typeof ProxyProviderBuilder<T, R> = R Function(BuildContext context, T value, R? previous)
왜 R 이 널러블?
-> create 가 옵셔널이기 때문에 

ProxyProviderN 은 모두 ProxyProvider0 의 syntatic sugar

ChangeNotifierProxyProvider
-> 외부 ChangeNotifier 와 값을 싱크로나이즈하는 ChangeNotifierProvider 

인스턴스가 업데이트될 때마다 ChangeNotifier 가 업데이트 되는데 동일한 인스턴스가 계속 쓰이는 것
다시 create 되는 것이 아님

주의해야할 점
ChangeNotifier 를 업데이트해서 직접적으로 만들지 말라
-> 의존하고 있는 값이 업데이트될 때 state 가 로스트될 수 있음
-> 이전의 노티파이어를 dispose 하기 때문에 새로운 노티파이어를 create 하는 오버해드가 있음
-> ChangeNotifier 를 인스턴스가 변할 때마다 매번 create 하는 것은 ChangeNotifier 의 
디자인 원칙에도 반한다고 생각
-> 가능하면 ProxyProvider 를 써라 == immutable 한 오브젝트를 만드는 것을 선호
*/
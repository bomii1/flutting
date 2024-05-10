import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_provider.dart';
import 'success_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'addListener of ChangeNotifier',
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? searchTerm;
  late final AppProvider appProv;

  @override
  void initState() {
    super.initState();
    appProv = context.read<AppProvider>();
    appProv.addListener(appListener);
  }

  void appListener() {
    if (appProv.state == AppState.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return const SuccessPage();
        }),
      );
    } else if (appProv.state == AppState.error) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Something went wrong'),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    appProv.removeListener(appListener);
    super.dispose();
  }

  void submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
      // 일단 한번 폼이 submit 되고 나서는 모든 폼 인풋에 대해
      // 벨리데이션을 수행한다
    });

    final form = formKey.currentState;

    if (form == null || !form.validate()) return;
    // 널이면 리턴 아니면 폼을 세이브
    form.save();

    // to avoid async gap warning
    // original lint rule name is: use_build_context_synchronously
    // final navigator = Navigator.of(context);
    context.read<AppProvider>().getResult(searchTerm!);
    // navigator.push(
    //   MaterialPageRoute(builder: (context) {
    //     return const SuccessPage();
    //   }),
    // );

    // to avoid async gap warning
    // original lint rule name is: use_build_context_synchronously
    // if (!mounted) return;
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const AlertDialog(
    //       content: Text('Something went wrong'),
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppProvider>().state;

    // if (appState == AppState.success) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) {
    //         return const SuccessPage();
    //       }),
    //     );
    //   });
    // } else if (appState == AppState.error) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         return const AlertDialog(
    //           content: Text('Something went wrong'),
    //         );
    //       },
    //     );
    //   });
    // }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    autofocus: true, // 바로 입력할 수 있도록
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Search'),
                      prefixIcon: Icon(Icons.search),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Search term required';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      searchTerm = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: appState == AppState.loading ? null : submit,
                    child: Text(
                      appState == AppState.loading ? 'Loading...' : 'Get Result',
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
addListener 
state 의 값에 따라 액션을 처리할 보이드 콜백만듦
initState 메소드에서 ChangeNotifier 의 addListener 를 이용해 보이드 콜백 등록
리스너는 저절로 dispose 되지 않기 때문에 스테이트풀 위젯의 dispose 메소드에서
ChangeNotifier 의 리무스 리스너를 이용해 제거

에러발생시 rethrow 하지 않는 방식?
-> ui 에서 에러를 처리해야 함

app provider 가 앱 ui 와 관련된 많은 정보를 가짐
1. 빌드 컨텍스트를 가져와야 하고
2. 네비게이터.push 에서 이동할 화면을 import 해야 함

provider 와 ui 의 경계가 클리어 하지 않고 섞여 있음 -> 다른 개발자가 코드를 처음 보면 어려움

get 패키지를 사용하면 컨텍스트 없이 네비게이션한다던지 다이어로그를 표시할 수 있기 때문에
function argument 로 빌드 컨텍스트를 넘겨줄 필요 없음 -> 문제 완화가 가능하지만 여전히 
비즈니스 로직과 ui 가 섞여 있는 문제가 남음

state 의 value 가 변할 때
ui 를 변경시키는 것이 아닌, 다이로그를 보여준다거나 다른 페이지로 네이게이션을 하는 것과 같은 액션은 주의가 필요
각각 에러가 발생했을 때 다이어로그를 표시하는 경우로 가정하고 3가지 방법 리뷰
1. 에러가 발생한 시점에서 다이어로그를 표시 -> 비즈니스 로직과 ui 가 명확하게 구분되지 않음
2. 에러가 트리거 된 함수에서 다이어로그를 표시하는 방식 -> 관련된 로직을 한군데서 처리하는 방식으로
inparative 한 방식
3. ChangeNotifier 의 addListener 에서 처리하는 방식 -> 로직이 클리어하지만 리스너를 등록하고 dispose 하는
것과 같은 보일러플레이트 코드를 만들어야 함. 프로그램 로직상 리스너가 적절히 dispose 되지 않고 동일한 액션을 수행하는
여러 개의 리스너가 등록되는 경우가 있으니 주의하여 사용해야 함.

*/
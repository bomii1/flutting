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
*/
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
    });

    final form = formKey.currentState;

    if (form == null || !form.validate()) return;

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
                    autofocus: true,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Translations {
  late int _value; // -> 업데이트로 값이 주어질 것이기 때문에 late 로 선언

  void update(int newValue) {
    _value = newValue;
  }

  String get title => 'You clicked $_value times';
}

class ProxyProvCreateUpdate extends StatefulWidget {
  const ProxyProvCreateUpdate({super.key});

  @override
  State<ProxyProvCreateUpdate> createState() => _ProxyProvCreateUpdateState();
}

class _ProxyProvCreateUpdateState extends State<ProxyProvCreateUpdate> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
      print('counter: $counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProxyProvider create/update'),
      ),
      body: Center(
        child: ProxyProvider0<Translations>(
          create: (_) => Translations(),
          update: (_, Translations? translations) {
            translations!.update(counter);
            return translations;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: prefer_const_constructors
              ShowTranslations(),
              const SizedBox(height: 20.0),
              IncreaseButton(increment: increment),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowTranslations extends StatelessWidget {
  const ShowTranslations({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.watch<Translations>().title;

    return Text(
      title,
      style: const TextStyle(fontSize: 28.0),
    );
  }
}

class IncreaseButton extends StatelessWidget {
  final VoidCallback increment;
  const IncreaseButton({
    super.key,
    required this.increment,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: increment,
      child: const Text(
        'INCREASE',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}

/*
굳이 이렇게 할 필요없다
-> 
*/
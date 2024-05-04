import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'success_page.dart';

enum AppState {
  initial,
  loading,
  success,
  error,
}

class AppProvider with ChangeNotifier {
  AppState _state = AppState.initial;
  AppState get state => _state;

  Future<void> getResult(/*BuildContext context, */ String searchTerm) async {
    _state = AppState.loading;
    notifyListeners();

    // final navigator = Navigator.of(context);

    await Future.delayed(const Duration(seconds: 1));

    try {
      if (searchTerm == 'fail') {
        throw 'Something went wrong';
      }

      _state = AppState.success;
      notifyListeners();

      // navigator.push(
      //   MaterialPageRoute(builder: (context) {
      //     return const SuccessPage();
      //   }),
      // );
    } catch (e) {
      _state = AppState.error;
      notifyListeners();

      // if (!context.mounted) return;
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return const AlertDialog(
      //       content: Text('Something went wrong'),
      //     );
      //   },
      // );
    }
  }
}

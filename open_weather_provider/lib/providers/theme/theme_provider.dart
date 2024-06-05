import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../constants/constants.dart';
import '../providers.dart';

part 'theme_state.dart';

class ThemeProvider with ChangeNotifier {
  ThemeState _state = ThemeState.initial();
  ThemeState get state => _state;

  void update(WeatherProvider wp) {
    if (wp.state.weather.temp > kWarmOrNot) {
      _state = _state.copyWith(appTheme: AppTheme.light);
    } else {
      _state = _state.copyWith(appTheme: AppTheme.dark);
    }
    notifyListeners();
  }
}

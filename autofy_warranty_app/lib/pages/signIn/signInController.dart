import 'package:get/get.dart';

class SignInController extends GetxController {
  var _isLoading = false;
  var _isVisible = false;

  bool get isLoading => _isLoading;
  bool get isVisible => _isVisible;

  void updateVisible() {
    _isVisible = !_isVisible;
    update();
  }

  void updateLoading() {
    _isLoading = !_isLoading;
    update();
  }
}

import 'package:get/get.dart';

import '../controllers/cuci_controller.dart';

class CuciBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CuciController>(
      () => CuciController(),
    );
  }
}

import 'package:get/get.dart';

import '../../../data/data_endpoint/kendaraan.dart';
import '../../../data/data_endpoint/tipekendaraan.dart';
import 'package:dio/dio.dart' as dio;

import '../../../data/endpoint.dart';
class CuciController extends GetxController {
  //TODO: Implement SplashcreenController
  final dio.Dio _dio = dio.Dio();
  var futureMerek = Future<MerekKendaraan>.value(MerekKendaraan(datakendaraan: [])).obs;
  var futureTipeKendaraan = Future<TipeKendaraan>.value(TipeKendaraan(datatipe: [])).obs;
  var selectedMerek = ''.obs;
  var selectedTipe = ''.obs;
  var selectedVehicle = ''.obs;
  var selectedMerekId = 0.obs;
  var selectedTipeID = 0.obs;

  final count = 0.obs;

  void loadMerek() {
    futureMerek.value = API.merekid();
  }
  @override
  void onInit() {
    super.onInit();
    loadMerek();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

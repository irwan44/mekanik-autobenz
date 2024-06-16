import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../componen/color.dart';
import '../../../data/data_endpoint/data_dummy.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/data_endpoint/kendaraan.dart';
import '../../../data/data_endpoint/tipekendaraan.dart';
import '../../../data/endpoint.dart';
import '../../signin/common/common.dart';
import '../../signin/screens/fade_animationtest.dart';
import '../controllers/cuci_controller.dart';

class CuciView extends StatefulWidget {
  const CuciView({super.key});

  @override
  State<CuciView> createState() => _CuciViewState();
}

class _CuciViewState extends State<CuciView> {
  final CuciController controller = Get.put(CuciController());
  late String selectedVehicle;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Column(children: [
          Image.asset(
            'assets/icon_cuci.png',
            width: 200.0,
            fit: BoxFit.cover,
          ),
            ],
          ),
        SizedBox(width: 20,),
        Column(
          children: [
        Text('Car Wash', style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
        Text('Booking',  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        ],
        )
      ],
      ),
      Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            child: Column(
              children: [
                FadeInAnimation(
                  delay: 1.9,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    obscureText:false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.all(18),
                        hintStyle: Common().hinttext,
                        hintText: 'Masukkan Nomor Polisi'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FadeInAnimation(
                  delay: 1.8,
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: FutureBuilder<MerekKendaraan>(
                      future: controller.futureMerek.value,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.datakendaraan!.isEmpty) {
                          return Center(child: Text('No data available'));
                        } else {
                          List<DataKendaraan> merekList = snapshot.data!.datakendaraan!;
                          List<String> namaMerekList = merekList.map((merek) => merek.namaMerk!).toList();
                          print("Nama Merk List: $namaMerekList");

                          return CustomDropdown.search(
                            hintText: 'Pilih Merk kendaraan',
                            items: namaMerekList,
                            onChanged: (value) {
                              controller.selectedMerek.value = value!;
                              try {
                                controller.selectedMerekId.value =
                                merekList.firstWhere((merek) => merek.namaMerk == value).id!;
                                // Trigger load for dropdown 2
                                controller.futureTipeKendaraan.value =
                                    API.tipekendaraanID(id: controller.selectedMerekId.value);
                                print("Selected Merek ID: ${controller.selectedMerekId.value}");
                              } catch (e) {
                                print("Error: $e");
                                controller.selectedMerekId.value = 0;
                                controller.futureTipeKendaraan.value = Future<TipeKendaraan>.value(TipeKendaraan(datatipe: []));
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => controller.selectedMerekId.value == 0
                    ? Container() // Show nothing if no item is selected in dropdown 1
                    : FadeInAnimation(
                  delay: 1.8,
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: FutureBuilder<TipeKendaraan>(
                      future: controller.futureTipeKendaraan.value,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.datatipe!.isEmpty) {
                          return Center(child: Text('No data available'));
                        } else {
                          List<DataTipe> tipeList = snapshot.data!.datatipe!;
                          List<String> namaTipeList = tipeList.map((tipe) => tipe.namaTipe!).toList();
                          print("Nama Tipe List: $namaTipeList");

                          return CustomDropdown.search(
                            hintText: 'Pilih Tipe Kendaraan',
                            items: namaTipeList,
                            onChanged: (value) {
                              controller.selectedTipeID.value =
                              tipeList.firstWhere((merek) => merek.namaTipe == value).id!;
                              controller.selectedTipe.value = value!;
                            },
                          );
                        }
                      },
                    ),
                  ),
                )
                ),
            SizedBox(height: 10,),
            Container(
          padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child:
                CustomDropdown.search(
                  hintText: 'Pilih Vehicle Type',
                  items: dummyTipeKendaraan.map((vehicle) => vehicle['jenis'].toString()).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedVehicle = value;
                    });
                  },
                ),
                ),
                    ],
                  ),
                ),
              ),
            ]
          )
        )
        ],
      ),
    );
  }
}

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../componen/color.dart';
import '../../../componen/loading_cabang_shimmer.dart';
import '../../../data/data_endpoint/data_dummy.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/data_endpoint/kendaraan.dart';
import '../../../data/data_endpoint/profile.dart';
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Car Wash', style: TextStyle(color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold)),
            FutureBuilder<Profile>(
              future: API.profileiD(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const loadcabang();
                } else if (snapshot.hasError) {
                  return const loadcabang();
                } else {
                  if (snapshot.data != null) {
                    final cabang = snapshot.data!.data?.cabang ?? "";
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cabang,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const loadcabang();
                  }
                }
              },
            ),
        SizedBox(height: 10,),
        Container(
          width: double.infinity,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.appPrimaryBengkelly),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(Icons.search_rounded, color: MyColors.appPrimaryColor),
              const SizedBox(width: 10),
              Text('Cari berdasarkan Nomor Polisi kendaraan', style: GoogleFonts.nunito(color: Colors.grey,fontSize: 14)),
            ],
          ),
        ),
          ],
        ),
      ),
        body: SingleChildScrollView(
      child: Column(
        children: [

        ],
      ),
      ),
    );
  }
}

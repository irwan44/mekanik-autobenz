import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:mekanik/app/data/data_endpoint/update_keterangan.dart';
import 'package:mekanik/app/data/publik.dart';
import '../routes/app_pages.dart';
import 'data_endpoint/approve.dart';
import 'data_endpoint/boking.dart';
import 'data_endpoint/bookingmasuk.dart';
import 'data_endpoint/detailhistory.dart';
import 'data_endpoint/estimasi.dart';
import 'data_endpoint/gc_mekanik.dart';
import 'data_endpoint/general_chackup.dart';
import 'data_endpoint/history.dart';
import 'data_endpoint/kategory.dart';
import 'data_endpoint/kendaraan.dart';
import 'data_endpoint/login.dart';
import 'data_endpoint/mekanik.dart';
import 'data_endpoint/mekanik_pkb.dart';
import 'data_endpoint/mekanikpromekid.dart';
import 'data_endpoint/pkb.dart';
import 'data_endpoint/profile.dart';
import 'data_endpoint/promax.dart';
import 'data_endpoint/promekpkb.dart';
import 'data_endpoint/proses_promax.dart';
import 'data_endpoint/prosesspromaxpkb.dart';
import 'data_endpoint/servicedikerjakan.dart';
import 'data_endpoint/serviceselesai.dart';
import 'data_endpoint/submit_finish.dart';
import 'data_endpoint/submit_gc.dart';
import 'data_endpoint/tipekendaraan.dart';
import 'data_endpoint/unapprove.dart';
import 'localstorage.dart';
import 'package:http/http.dart' as http;

class API {
  static const _url = 'https://api.realautobenz.com';
  static const _baseUrl = '$_url/api';
  static const _getProfile = '$_baseUrl/mekanik/profile-karyawan';
  static const _getLogin = '$_baseUrl/mekanik/login';
  static const _getTooking = '$_baseUrl/mekanik/booking';
  static const _getGeneral = '$_baseUrl/mekanik/general-checkup';
  static const _getMekanik = '$_baseUrl/mekanik/get-mekanik';
  static const _postApprovek = '$_baseUrl/mekanik/approve-booking';
  static const _postUpprovek = '$_baseUrl/mekanik/unapprove-booking';
  static const _postSubmitGC = '$_baseUrl/mekanik/submit-general-checkup';
  static const _postestimasi = '$_baseUrl/mekanik/insert-estimasi';
  static const _postSubmitGCFinish = '$_baseUrl/mekanik/submit-general-checkup-finish';
  static const _gethistory = '$_baseUrl/mekanik/get-history-mekanik';
  static const _getKategory = '$_baseUrl/mekanik/kategori-kendaraan';
  static const _getGCMekanik = '$_baseUrl/mekanik/general-checkup-mekanik';
  static const _postpromek = '$_baseUrl/mekanik/insert-promek';
  static const _getprosespromek = '$_baseUrl/mekanik/get-proses-promek';
  static const _postprosespromek = '$_baseUrl/mekanik/update-keterangan-promek';
  static const _getBookingMasuk = '$_baseUrl/mekanik/get-booking-masuk';
  static const _getServiceSelesai = '$_baseUrl/mekanik/get-service-selesai';
  static const _getDikerjakan = '$_baseUrl/mekanik/get-dikerjakan';
  static const _getDetailhistory = '$_baseUrl/mekanik/get-detail-history';
  static const _getpkb = '$_baseUrl/mekanik/get-pkb';
  static const _getmekanikpkb = '$_baseUrl/mekanik/pkb/get-jasa-mekanik';
  static const _getInsetpromekpkb = '$_baseUrl/mekanik/pkb/insert-promek';
  static const _getPKBUpdateKeteranganStop = '$_baseUrl/mekanik/pkb/update-keterangan-promek';
  static const _getpRrosesPKB = '$_baseUrl/mekanik/pkb/get-proses-promek';
  static const _getpRrosesMekanikPKB = '$_baseUrl/mekanik/pkb/get-mekanik-promek';
  static const _getGendaraan = '$_baseUrl/merk';
  static const _getTipe = '$_baseUrl/tipe';

  static final _controller = Publics.controller;
//---------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
  static Future<MerekKendaraan> merekid() async {
    try {
      var response = await Dio().get(
        _getGendaraan,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 404) {
        return MerekKendaraan(status: false, message: "Tidak ada data booking untuk karyawan ini.");
      }

      final obj = MerekKendaraan.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda
  static Future<TipeKendaraan> tipekendaraanID({required int id}) async {
    try {
      var response = await Dio().get(
        '$_getTipe/$id', // Make sure this correctly formats the URL
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 404) {
        return TipeKendaraan(status: false, message: "Tidak ada data booking untuk karyawan ini.");
      }

      final obj = TipeKendaraan.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda
//---------------------------------------------------------------------------------------------------------

  static Future<Token> login({required String email, required String password}) async {
    final data = {
      "email": email,
      "password": password,
    };

    try {
      var response = await http.post(
        Uri.parse(_getLogin),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == false) {
          Get.snackbar('Error', responseData['message'],
              backgroundColor: const Color(0xffe5f3e7));
          return Token(status: false);
        } else {
          final obj = Token.fromJson(responseData);
          if (obj.token != null) {
            LocalStorages.setToken(obj.token!);
            Get.snackbar('Selamat Datang', 'Real AutoBenz',
                backgroundColor: Colors.green,
                colorText: Colors.white
            );
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.snackbar('Error', 'tidak ditemukan',
                backgroundColor: const Color(0xffe5f3e7));
          }
          print('Login successful. Response data: ${obj.toJson()}');
          return obj;
        }
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
        throw Exception('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw e;
    }
  }


//beda
  static Future<Profile> profileiD() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getProfile,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        return Profile(status: false, message: "Tidak ada data booking untuk karyawan ini.");
      }

      final obj = Profile.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      throw e;
    }
  }

//beda
  static Future<Boking> bokingid() async {
    try {
      final token = Publics.controller.getToken.value ?? '';
      var data = {"token": token};
      var response = await Dio().get(
        _getTooking,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        return Boking(status: false, message: "Tidak ada data booking untuk karyawan ini.");
      }

      final obj = Boking.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda
  static Future<general_checkup> GeneralID() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getGeneral,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = general_checkup.fromJson(response.data);

      if (obj.data == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }

  //Beda
  static Future<Approve> approveId({
    required String idkaryawan,
    required String kodeBooking,
    required String kodepelanggan,
    required String kodekendaraan,
    required String kategorikendaraan,
    required String tglBooking,
    required String jamBooking,
    required String odometer,
    required String pic,
    required String hpPic,
    required String kodeMembership,
    required String kodePaketmember,
    required String tipeSvc,
    required String tipePelanggan,
    required String referensi,
    required String referensiTmn,
    required String paketSvc,
    required String keluhan,
    required String perintahKerja,
    required int ppn,
  }) async {
    final data = {
      "id_karyawan": idkaryawan,
      "kode_booking": kodeBooking,
      "kode_pelanggan": kodepelanggan,
      "kode_kendaraan": kodekendaraan,
      "kategori_kendaraan": kategorikendaraan,
      "tgl_booking": tglBooking,
      "jam_booking": jamBooking,
      "odometer": odometer,
      "pic": pic,
      "hp_pic": hpPic,
      "kode_membership": kodeMembership,
      "kode_paketmember": kodePaketmember,
      "tipe_svc": tipeSvc,
      "tipe_pelanggan": tipePelanggan,
      "referensi": referensi,
      "referensi_teman": referensiTmn,
      "paket_svc": paketSvc,
      "keluhan": keluhan,
      "perintah_kerja": perintahKerja,
      "ppn": ppn,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().post(
        _postApprovek,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = Approve.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<Unapprove> unapproveId({
    required String catatan,
    required String kodeBooking,
  }) async {
    final data = {
      "catatan": catatan,
      "kode_booking": kodeBooking,

    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().post(
        _postUpprovek,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = Unapprove.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<Mekanik> MekanikID() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getMekanik,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = Mekanik.fromJson(response.data);

      if (obj.message == null) {
        throw Exception("Data Mekanik kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda

//Beda
  static Future<Estimasi> estimasiId({
    required String idkaryawan,
    required String kodeBooking,
    required String kodepelanggan,
    required String kodekendaraan,
    required String kategorikendaraan,
    required String tglBooking,
    required String jamBooking,
    required String odometer,
    required String pic,
    required String hpPic,
    required String kodeMembership,
    required String kodePaketmember,
    required String tipeSvc,
    required String tipePelanggan,
    required String referensi,
    required String referensiTmn,
    required String paketSvc,
    required String keluhan,
    required String perintahKerja,
    required int ppn,
  }) async {
    final data = {
      "id_karyawan": idkaryawan,
      "kode_booking": kodeBooking,
      "kode_pelanggan": kodepelanggan,
      "kode_kendaraan": kodekendaraan,
      "kategori_kendaraan": kategorikendaraan,
      "tgl_booking": tglBooking,
      "jam_booking": jamBooking,
      "odometer": odometer,
      "pic": pic,
      "hp_pic": hpPic,
      "kode_membership": kodeMembership,
      "kode_paketmember": kodePaketmember,
      "tipe_svc": tipeSvc,
      "tipe_pelanggan": tipePelanggan,
      "referensi": referensi,
      "referensi_teman": referensiTmn,
      "paket_svc": paketSvc,
      "keluhan": keluhan,
      "perintah_kerja": perintahKerja,
      "ppn": ppn,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().post(
        _postestimasi,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = Estimasi.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

//Beda
  static Future<SubmitGC> submitGCID({
    required Map<String, dynamic> generalCheckup,
  }) async {
    try {
      final token = await Publics.controller.getToken.value;
      print('Token: $token');

      final response = await Dio().post(
        _postSubmitGC,
        data: generalCheckup,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final submitGCData = SubmitGC.fromJson(data);
        return submitGCData;
      } else {
        throw Exception('Failed to submit general checkup');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<Gcfinish> submitGCFinishId({
    required String bookingId,
  }) async {
    final data = {
      "booking_id": bookingId,

    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().post(
        _postSubmitGCFinish,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = Gcfinish.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //beda
  static Future<History> HistoryID() async {
    final token = Publics.controller.getToken.value;
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _gethistory,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = History.fromJson(response.data);

      if (obj.dataHistory == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
//Beda
  static Future<Kategori> kategoriID() async {
    final token = Publics.controller.getToken.value;
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getKategory,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = Kategori.fromJson(response.data);

      if (obj.dataKategoriKendaraan == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda
  static Future<GCMekanik> GCMekanikID({
    required String kategoriKendaraanId,
  }) async {
    final token = Publics.controller.getToken.value;
    var data = {
      "kategori_kendaraan_id": kategoriKendaraanId,
    };
    try {
      var response = await Dio().get(
        _getGCMekanik,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = GCMekanik.fromJson(response.data);

      if (obj.dataGeneralCheckUp == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda
  static Future<MekanikPKB> MeknaikPKBID({
    required String kodesvc,
  }) async {
    final token = Publics.controller.getToken.value;
    var data = {
      "kode_svc": kodesvc,
    };
    try {
      var response = await Dio().get(
        _getmekanikpkb,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = MekanikPKB.fromJson(response.data);

      if (obj.dataJasaMekanik == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda
  static Future<MekanikPKB> InsertPromexID({
    required String kodesvc,
  }) async {
    final token = Publics.controller.getToken.value;
    var data = {
      "kode_svc": kodesvc,
    };
    try {
      var response = await Dio().get(
        _getmekanikpkb,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = MekanikPKB.fromJson(response.data);

      if (obj.dataJasaMekanik == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
//Beda
// Beda
  static Future<PromePKB> InsertPromexoPKBID({
    required String kodesvc,
    required String kodejasa,
    required String idmekanik,
    required String role,
  }) async {
    final token = Publics.controller.getToken.value;
    var data = {
      "kode_svc": kodesvc,
      "kode_jasa": kodejasa,
      "id_mekanik": idmekanik,
      "role": role,
    };

    print("Request Data: $data");

    try {
      var response = await Dio().post(
        _getInsetpromekpkb,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = PromePKB.fromJson(response.data);

      if (obj.status == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }
//Beda
  static Future<Promek> promekID({
    required String role,
    required String kodebooking,
    required String kodejasa,
    required String idmekanik,
  }) async {
    final data = {
      "role": role,
      "kode_booking": kodebooking,
      "kode_jasa": kodejasa,
      "id_mekanik": idmekanik,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().post(
        _postpromek,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = Promek.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<PromekProses> PromekProsesID({
    required String kodebooking,
    required String kodejasa,
    required String idmekanik,
  }) async {
    final data = {
      "kode_booking": kodebooking,
      "kode_jasa": kodejasa,
      "id_mekanik": idmekanik,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getprosespromek,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      print('Response: ${response.data}');

      final obj = PromekProses.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<ProsesPromex> PromekProsesPKBID({
    required String kodesvc,
    required String kodejasa,
    required String idmekanik,
  }) async {
    final data = {
      "kode_svc": kodesvc,
      "kode_jasa": kodejasa,
      "id_mekanik": idmekanik,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getpRrosesPKB,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      print('Response: ${response.data}');

      final obj = ProsesPromex.fromJson(response.data);

      if (obj.status == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.status.toString(),
          obj.status.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  //Beda
  static Future<MekanikPromekPKB>  MekanikPromekPKBID({
    required String kodesvc,
    required String kodejasa,
  }) async {
    final data = {
      "kode_svc": kodesvc,
      "kode_jasa": kodejasa,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getpRrosesMekanikPKB,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      print('Response: ${response.data}');

      final obj = MekanikPromekPKB.fromJson(response.data);

      if (obj.status == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.status.toString(),
          obj.status.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<UpdateKeterangan> updateketeranganID({
    required String promekid,
    required String keteranganpromek,
  }) async {
    final data = {
      "promek_id": promekid,
      "keterangan_promek": keteranganpromek,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().post(
        _postprosespromek,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      print('Response: ${response.data}');

      final obj = UpdateKeterangan.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda

  // Beda
  static Future<UpdateKeterangan> updateketeranganPKBID({
    required String kodesvc,
    required String kodejasa,
    required String idmekanik,
    required String keteranganpromek,
  }) async {
    final data = {
      "kode_svc": kodesvc,
      "kode_jasa": kodejasa,
      "id_mekanik": idmekanik,
      "keterangan_promek": keteranganpromek,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().post(
        _getPKBUpdateKeteranganStop,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      print('Response: ${response.data}');

      final obj = UpdateKeterangan.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  //Beda
  static Future<MasukBooking> BookingMasukID() async {
    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getBookingMasuk,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = MasukBooking.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<ServiceSelesaiHome> ServiceSelesaiID() async {
    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getServiceSelesai,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = ServiceSelesaiHome.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  } //Beda
  static Future<ServiceDikerjakan> DikerjakanID() async {
    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');
      var response = await Dio().get(
        _getDikerjakan,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      print('Response: ${response.data}');
      final obj = ServiceDikerjakan.fromJson(response.data);
      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<DetailHistory> DetailhistoryID({
    required String kodesvc,
  }) async {
    final data = {
      "kode_svc": kodesvc,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getDetailhistory,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = DetailHistory.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
//Beda
  static Future<PKB> PKBID() async {
    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getpkb,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');

      final obj = PKB.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  //Beda
  static Future<void> showBookingNotifications() async {
    try {
      final token = Publics.controller.getToken.value ?? '';
      var data = {"token": token};
      var response = await Dio().get(
        _getTooking,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        return;
      }

      final obj = Boking.fromJson(response.data);

      if (obj.status == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.status.toString(),
          obj.status.toString(),
        );
      }

      final bookings = obj.dataBooking ?? [];
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      for (final booking in bookings) {
        if (booking.bookingStatus == 'Booking') {
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            sound: RawResourceAndroidNotificationSound('sounds'),
          );
          const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(
            0,
            'Booking Masuk',
            booking.namaService ?? '',
            platformChannelSpecifics,
            payload: 'item x', // optional, used for onClick event
          );
        }
      }
    } catch (e) {
      throw e;
    }
  }

}

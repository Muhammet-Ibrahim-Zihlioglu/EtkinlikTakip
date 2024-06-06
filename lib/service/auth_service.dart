import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/screen/Home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<void> etkinlikEkle(String title, String description, DateTime date,
      GeoPoint geoPoint, String mapsInfo) async {
    await _firestore.collection("isyeriegitimiyonetici").add({
      'title': title,
      'description': description,
      'date': date,
      'konum': geoPoint,
      'konumBaslik': mapsInfo
    });
  }

  Future<void> etkinlikGuncelle(String id, String title, String description,
      DateTime date, GeoPoint geoPoint, String mapsInfo) async {
    try {
      var docRef = _firestore.collection("isyeriegitimiyonetici").doc(id);
      await docRef.update({
        'title': title,
        'description': description,
        'date': date,
        'konum': geoPoint,
        'konumBaslik': mapsInfo
      });
      print("Etkinlik başarıyla güncellendi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<Stream<QuerySnapshot>> tumEtkinlikler() async {
    return await _firestore.collection('isyeriegitimiyonetici').snapshots();
  }

  Future<Stream<QuerySnapshot>> tumKullaniciEtkinlikler() async {
    String? userId = await getUserId(); // Kullanıcı ID'sini al

    // Kullanıcının belgesine referans al
    var userDocRef = _firestore.collection('isyeriegitimi').doc(userId);

    // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur

    return userDocRef.collection('KatildigimEtkinlikler').snapshots();
  }

  Future<Stream<QuerySnapshot>> etkinligeKatilanKullanicilar(String id) async {
    // Kullanıcının belgesine referans al
    var userDocRef = _firestore.collection('isyeriegitimiyonetici').doc(id);
    // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur

    return userDocRef.collection('EtkinliğeKatılanKullanicilar').snapshots();
  }

  Future<void> kullaniciEtkinlikSil(DocumentReference docRef) async {
    try {
      await docRef.delete();
      print("Etkinlik başarıyla silindi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> etkinlikKullaniciSil(String etkinlikId) async {
    try {
      String? userId = await getUserId();
      var userDocref =
          _firestore.collection('isyeriegitimiyonetici').doc(etkinlikId);
      var katilanKullanici =
          userDocref.collection("EtkinliğeKatılanKullanicilar");
      katilanKullanici.doc(userId).delete();

      print("Etkinlik başarıyla silindi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> etkinlikKatil(
      String etkinlikId,
      String title,
      String description,
      DateTime date,
      GeoPoint geoPoint,
      String locationTitle) async {
    String? userId = await getUserId(); // Kullanıcı ID'sini al
    if (userId != null) {
      try {
        // Kullanıcının belgesine referans al
        var userDocRef = _firestore.collection('isyeriegitimi').doc(userId);

        // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur
        var katildigimEtkinliklerCollection =
            userDocRef.collection('KatildigimEtkinlikler');

        // Belge ekleyin
        await katildigimEtkinliklerCollection.doc(etkinlikId).set({
          'title': title,
          'description': description,
          'date': date,
          'konum': geoPoint,
          'konumBaslik': locationTitle
        });

        print("Etkinlik başarıyla eklendi");
      } catch (e) {
        print("Hata: $e");
      }
    } else {
      print("Kullanıcı ID'si bulunamadı.");
    }
  }

  Future<void> etkinligeKatilanKullanici(String kullaniciId, String id,
      String email, String username, String number) async {
    if (id != null) {
      try {
        // Kullanıcının belgesine referans al
        var userDocRef = _firestore.collection('isyeriegitimiyonetici').doc(id);

        // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur
        var katildigimEtkinliklerCollection =
            userDocRef.collection('EtkinliğeKatılanKullanicilar');

        // Belge ekleyin
        await katildigimEtkinliklerCollection.doc(kullaniciId).set({
          'email': email,
          'username': username,
          'number': number,
        });

        print("Etkinlik başarıyla eklendi");
      } catch (e) {
        print("Hata: $e");
      }
    } else {
      print("Kullanıcı ID'si bulunamadı.");
    }
  }

  Future<void> etkinlikSil(DocumentReference docRef) async {
    try {
      await docRef.delete();
      print("Etkinlik başarıyla silindi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  //Kullanıcıların hepsini çağıran fonksiyon.
  Future<Stream<QuerySnapshot>> tumKullanicilar() async {
    return await _firestore.collection('isyeriegitimi').snapshots();
  }

  Future<void> kullaniciGuncelle(
      DocumentReference docRef, Map<String, dynamic> guncelleSoruBilgi) async {
    try {
      await docRef.update(guncelleSoruBilgi);
      print("Kullanıcı başarıyla güncellendi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> kullaniciSil(DocumentReference docRef) async {
    try {
      await docRef.delete();
      print("Kullanıcı başarıyla silindi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  //giriş yap fonksiyonu
  Future<User?> signIn(
      String email, String password, BuildContext context) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = userCredential;

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
        return user.user;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('HATA'),
            content: const Text(
                'Lütfen Bilgilerinizi Kontrol Edip Tekrar Deneyiniz.E-Posta veya Şifre Hatalı'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
    return null;
  }

  //çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  //kayıt ol fonksiyonub
  Future<User?> createPerson(BuildContext context, String email, String name,
      String number, String password) async {
    try {
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection("isyeriegitimi")
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'username': name,
        'number': number,
        'password': password
      });

      return userCredential.user;
    } catch (error) {
      // Check if the error is due to email already in use
      if (error is FirebaseAuthException &&
          error.code == 'email-already-in-use') {
        // Display AlertDialog to notify the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('HATA'),
              content: const Text(
                  'Girilen Bilgiler Kayıtlı Bir Kullanıcıya Ait Olduğu İçin Yeni Kayıt Oluşturalamadı.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      } else {
        // For other errors, print the error message
        print("Error: $error");
      }
      return null; // Return null as user creation failed
    }
  }
}

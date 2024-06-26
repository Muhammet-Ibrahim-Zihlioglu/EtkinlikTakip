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

  //ACTİVİYT SERVICE
  Future<void> etkinlikEkle(
      String companyName,
      String title,
      String description,
      String categories,
      String company,
      DateTime date,
      GeoPoint geoPoint,
      String mapsInfo) async {
    await _firestore
        .collection("Company")
        .doc(companyName)
        .collection("Etkinlik Listesi")
        .add({
      'title': title,
      'description': description,
      'categories': categories,
      'companyName': company,
      'date': date,
      'konum': geoPoint,
      'konumBaslik': mapsInfo
    });
  }

  Future<void> etkinlikGuncelle(
      String companyName,
      String id,
      String title,
      String description,
      String categories,
      String company,
      DateTime date,
      GeoPoint geoPoint,
      String mapsInfo) async {
    try {
      var docRef = _firestore
          .collection("Company")
          .doc(companyName)
          .collection("Etkinlik Listesi")
          .doc(id);
      await docRef.update({
        'title': title,
        'description': description,
        'categories': categories,
        'companyName': company,
        'date': date,
        'konum': geoPoint,
        'konumBaslik': mapsInfo
      });
      print("Etkinlik başarıyla güncellendi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<Stream<QuerySnapshot>> tumEtkinlikler(String company) async {
    return await _firestore
        .collection('Company')
        .doc(company)
        .collection("Etkinlik Listesi")
        .snapshots();
  }

  Future<void> etkinlikKatil(
    String company,
    String etkinlikId,
    String title,
    String description,
    DateTime date,
    GeoPoint geoPoint,
    String locationTitle,
    String categories,
    String companyName,
  ) async {
    String? userId = await getUserId(); // Kullanıcı ID'sini al
    if (userId != null) {
      try {
        // Kullanıcının belgesine referans al
        var userDocRef = _firestore.collection('Company').doc(company);

        // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur
        var katildigimEtkinliklerCollection = userDocRef
            .collection('Çalışan Listesi')
            .doc(userId)
            .collection("KullanıcınınKatıldığıEtkinlikler");

        // Belge ekleyin
        await katildigimEtkinliklerCollection.doc(etkinlikId).set({
          'title': title,
          'description': description,
          'date': date,
          'konum': geoPoint,
          'konumBaslik': locationTitle,
          'categories': categories,
          'companyName': companyName,
          'katildiMi': true,
        });

        print("Etkinlik başarıyla eklendi");
      } catch (e) {
        print("Hata: $e");
      }
    } else {
      print("Kullanıcı ID'si bulunamadı.");
    }
  }

  Future<Stream<QuerySnapshot>> etkinligeKatilanKullanicilar(
      String company, String id) async {
    // Kullanıcının belgesine referans al
    var userDocRef = _firestore.collection('Company').doc(company);
    // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur

    return userDocRef
        .collection('Etkinlik Listesi')
        .doc(id)
        .collection('EtkinliğeKatilanKullanicilar')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> kullaniciTumEtkinlikler(String company) async {
    String? userId = await getUserId(); // Kullanıcı ID'sini al

    // Kullanıcının belgesine referans al
    var userDocRef = _firestore
        .collection('Company')
        .doc(company)
        .collection("Çalışan Listesi")
        .doc(userId);

    // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur

    return userDocRef
        .collection('KullanıcınınKatıldığıEtkinlikler')
        .snapshots();
  }

  Future<void> kullaniciEtkinlikSil(DocumentReference docRef) async {
    try {
      await docRef.delete();
      print("Etkinlik başarıyla silindi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> etkinlikKullaniciSil(String company, String etkinlikId) async {
    try {
      String? userId = await getUserId();
      var userDocref = _firestore
          .collection('Company')
          .doc(company)
          .collection("Etkinlik Listesi")
          .doc(etkinlikId);
      var katilanKullanici =
          userDocref.collection("EtkinliğeKatilanKullanicilar");
      katilanKullanici.doc(userId).delete();

      print("Etkinlik başarıyla silindi");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> etkinligeKatilanKullaniciyiCikarma(
    String company,
    String email,
    String etkinlikId,
  ) async {
    try {
      var documentID;
      var querySnapshot = await _firestore
          .collection('Company')
          .doc(company)
          .collection("Çalışan Listesi")
          .where("email", isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        documentID = querySnapshot.docs.first.id;
        print('Kullanıcıya ait döküman ID: $documentID');
      } else {
        print('Belirtilen email ile eşleşen kullanıcı bulunamadı.');
      }

      var userDocref = _firestore
          .collection('Company')
          .doc(company)
          .collection("Çalışan Listesi")
          .doc(documentID);
      var katilanKullanici =
          userDocref.collection("KullanıcınınKatıldığıEtkinlikler");
      katilanKullanici.doc(etkinlikId).delete();

      print("Etkinlik başarıyla silindi");
    } catch (e) {
      print("Hata: $e");
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

  //EMPLOYEE SERVİCE

  //ETKİNLİKLERE KULLANICILARI EKLEME
  Future<void> etkinligeKatilanKullanici(String companyName, String kullaniciId,
      String id, String email, String username, String number) async {
    try {
      // Kullanıcının belgesine referans al
      var userDocRef = _firestore.collection("Company").doc(companyName);

      // Kullanıcının belgesine referans alarak yeni bir alt koleksiyon oluştur
      var katildigimEtkinliklerCollection = userDocRef
          .collection('Etkinlik Listesi')
          .doc(id)
          .collection("EtkinliğeKatilanKullanicilar");

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
  }

  //Kullanıcıların hepsini çağıran fonksiyon.
  Future<Stream<QuerySnapshot>> tumKullanicilar(String company) async {
    return await _firestore
        .collection('Company')
        .doc(company)
        .collection("Çalışan Listesi")
        .snapshots();
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

  //AUTHSERVİcE

  //Şifre değiştirme

  Future<void> updateCompanyPassword(String userId, String newPassword) async {
    try {
      // Kullanıcının şirket dokümanını bulun
      QuerySnapshot querySnapshot =
          await _firestore.collection('Company').get();

      for (var doc in querySnapshot.docs) {
        // Her şirket dokümanında kullanıcının şifresini güncelleyin
        await doc.reference
            .collection('Çalışan Listesi')
            .doc(userId)
            .update({'password': newPassword});
      }
      print("Şirket veritabanındaki şifre başarıyla güncellendi");
    } catch (e) {
      print("Şifre güncelleme hatası: $e");
    }
  }

  //şirket girişi
  Future<bool> companySignIn(
      String username, String password, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Company')
          .where('companyName', isEqualTo: username)
          .where('companyPass', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
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

      return user.user;
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

  //kayıt ol fonksiyonu
  Future<User?> createPerson(
    String sirket,
    BuildContext context,
    String email,
    String username,
    String companyName,
    String number,
    String password,
  ) async {
    try {
      // Create a new user with Firebase Authentication
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the unique ID of the newly created user
      var userId = userCredential.user?.uid;

      // Ensure userId is not null
      if (userId == null) {
        throw Exception('User ID is null');
      }

      var userDocRef = _firestore.collection('Company').doc(sirket);

      var companyUser = userDocRef.collection('Çalışan Listesi');

      // Add user details to the "Users" collection with the same userId
      await _firestore.collection("Users").doc(userId).set({
        'email': email,
        'companyName': companyName,
        'username': username,
        'number': number
      });

      // Add user details to the company's employee list with the same userId
      await companyUser.doc(userId).set({
        'email': email,
        'username': username,
        'companyName': companyName,
        'number': number,
        'password': password,
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

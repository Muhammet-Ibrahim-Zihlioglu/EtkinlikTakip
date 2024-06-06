import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/bottomnavigationbar.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  AuthService authService = AuthService();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController number = TextEditingController();
  DocumentReference? id;

  Stream? soruStream;
  getontheload() async {
    soruStream = await AuthService().tumKullanicilar();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    allEmployeeDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(230, 19, 10, 113),
        onPressed: () {
          _showAddEmployeeDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 40, 119, 255),
          size: 40,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Kullanıcı Listesi',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(230, 19, 10, 113),
                fontSize: 25)),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/acikmavi.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                  0.8), // Saydamlık oranını buradan ayarlayabilirsiniz
              BlendMode.dstATop,
            ),
          ),
        ),
        child: allEmployeeDetails(),
      ),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.employee),
    );
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
      stream: soruStream,
      builder: ((context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount:
                    snapshot.data.docs.length + 1, // Increment itemCount by 1
                itemBuilder: (context, index) {
                  if (index == snapshot.data.docs.length) {
                    return SizedBox(
                        height: 30); // Add space after the last item
                  }
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  String password = ds["password"];
                  String maskedPassword = ("*" * (password.length));
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.88,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 40, 119, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      "Email: " + ds["email"],
                                      style: const TextStyle(
                                        color: Color.fromARGB(230, 19, 10, 113),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      "Kullanıcı Adı: " + ds["username"],
                                      style: const TextStyle(
                                        color: Color.fromARGB(230, 19, 10, 113),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      "Tel No: " + ds["number"],
                                      style: const TextStyle(
                                        color: Color.fromARGB(230, 19, 10, 113),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),

                                    // Kullanıcının şifresi uzunluğunda yıldızlardan oluşan bir metin oluştur

                                    Text(
                                      "Şifre: " + maskedPassword,
                                      style: const TextStyle(
                                        color: Color.fromARGB(230, 19, 10, 113),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  email.text = ds["email"];
                                  username.text = ds["username"];
                                  number.text = ds["number"];
                                  password = maskedPassword;
                                  id = ds.reference;
                                  _showEditEmployeeDialog(context, password);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: Color.fromARGB(230, 19, 10, 113),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  authService.kullaniciSil(ds.reference);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Color.fromARGB(230, 19, 10, 113),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : Container(
                child: Text(""),
              );
      }),
    );
  }

  void _showEditEmployeeDialog(BuildContext context, String pass) {
    TextEditingController emailController =
        TextEditingController(text: email.text);
    TextEditingController usernameController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController passwordController =
        TextEditingController(text: pass);
    String? errortext;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Kullanıcı Güncelleme',
                  style: TextStyle(
                      color: Color.fromARGB(255, 40, 119, 255),
                      fontWeight: FontWeight.w900)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 40, 119, 255),
                        ),
                        labelText: "Email",
                        hintText: '${email.text}',
                      ),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 40, 119, 255),
                        ),
                        labelText: "Kullanıcı Adı",
                        hintText: '${username.text}',
                      ),
                    ),
                    TextField(
                      controller: numberController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 40, 119, 255),
                        ),
                        labelText: "Telefon Numarası",
                        hintText: '${number.text}',
                      ),
                    ),
                    TextField(
                      enabled: false,
                      controller: passwordController,
                      decoration: InputDecoration(
                          //helperText: "Şifre En Az 6 Karakterden Oluşmalıdır.",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 40, 119, 255),
                          ),
                          labelText: "Şifre",
                          hintText: '${password.text}',
                          errorText: errortext),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Map<String, dynamic> guncelleBilgi = {
                            if (emailController.text.isNotEmpty)
                              "email": emailController.text,
                            if (emailController.text.isEmpty)
                              "email": email.text,
                            if (usernameController.text.isEmpty)
                              "username": username.text,
                            if (usernameController.text.isNotEmpty)
                              "username": usernameController.text,
                            if (numberController.text.isNotEmpty)
                              "number": numberController.text,
                            if (numberController.text.isEmpty)
                              "number": number.text,
                            if (passwordController.text.isEmpty)
                              "password": password.text,
                            if (passwordController.text.isNotEmpty &&
                                passwordController.text.length >= 6)
                              "password": passwordController.text,
                          };
                          authService.kullaniciGuncelle(id!, guncelleBilgi);
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Güncelle",
                          style: TextStyle(
                            color: Color.fromARGB(255, 40, 119, 255),
                          )),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    String? emailError;
    String? usernameError;
    String? passwordError;
    String? numberError;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Kullanıcı Ekle',
                  style: TextStyle(
                      color: Color.fromARGB(230, 19, 10, 113),
                      fontWeight: FontWeight.w900)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Color.fromARGB(230, 19, 10, 113),
                            fontWeight: FontWeight.w900),
                        labelText: 'Email',
                        errorText: emailError,
                      ),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Color.fromARGB(230, 19, 10, 113),
                              fontWeight: FontWeight.w900),
                          labelText: 'Kullanıcı Adı',
                          errorText: usernameError),
                    ),
                    TextField(
                      controller: numberController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Color.fromARGB(230, 19, 10, 113),
                              fontWeight: FontWeight.w900),
                          labelText: 'Telefonu numarası',
                          errorText: numberError),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Color.fromARGB(230, 19, 10, 113),
                            fontWeight: FontWeight.w900),
                        labelText: 'Şifre',
                        errorText: passwordError,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'İptal',
                    style: TextStyle(
                        color: Color.fromARGB(230, 19, 10, 113),
                        fontWeight: FontWeight.w900),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      emailError = null;
                      passwordError = null;
                      usernameError = null;
                      numberError = null;
                      // Hata kontrolleri

                      if (!RegExp(r'^[\w-\.]+@gmail\.com$')
                          .hasMatch(emailController.text)) {
                        emailError = "Geçerli Bir Eposta Adresi Giriniz";
                        return;
                      }
                      if (usernameController.text.isEmpty) {
                        usernameError = "Lütfen Bir Kullanıcı Adı Giriniz";
                      }
                      if (number.text.isEmpty) {
                        numberError = "Lütfen Bir Telefon Numarası Giriniz";
                      }
                      if (number.text.length != 11) {
                        numberError =
                            "Lütfen Geçerli Bir Telefon Numarası Giriniz";
                      }
                      if (usernameController.text.isEmpty) {
                        usernameError = "Lütfen Bir Kullanıcı adı giriniz";
                      }

                      if (passwordController.text.length < 6 &&
                          passwordController.text.length > 1) {
                        passwordError = "Şifre en az 6 karakter olmalıdır";
                        return;
                      }

                      // Hata yoksa işlemi tamamla
                      authService.createPerson(
                        context,
                        emailController.text,
                        usernameController.text,
                        numberController.text,
                        passwordController.text,
                      );

                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Kullanıcı Ekle",
                    style: TextStyle(
                        color: Color.fromARGB(230, 19, 10, 113),
                        fontWeight: FontWeight.w900),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}

import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kingyo_sushi/Login.dart';
import 'package:kingyo_sushi/pages/vendedorPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kingyo_sushi/pages/login_user.dart';
import 'package:kingyo_sushi/pages/login_admin.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      theme: ThemeData.dark(),
      routes: <String, WidgetBuilder>{
        '/vendedorpage': (BuildContext context) => new Vendedor(),
        '/LoginPage': (BuildContext context) => new LoginPage(),
        '/login_user': (BuildContext context) =>
            Login_User(username: username, id: id, contrasena: contrasena),
        '/login_admin': (BuildContext context) =>
            Login_Admin(username: username, id: id, contrasena: contrasena),
      },
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //final String url="https://swapi.co/api/people";

  final String url =
      "http://henrymata.hostingerapp.com/Kingyo_Sushi/leer_json.php";
  List data;
  String id = "";
  String pass = "";
  String username = "";
  final bool admin = true;
  final bool login = true;

  @override
  void initState() {
    this.getJsonData();
    readDatauser();
    debugPrint(id);
    debugPrint(pass);
    super.initState();
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));

    getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http.get(
//encode the url
        Uri.encodeFull(url),
//only accept json response
        headers: {"Accept": "application/json; charset=utf-8"});

    //debugPrint(response.body);
    setState(() {
      var convertDataToJson = jsonDecode(response.body);

      data = convertDataToJson["Promos"];
    });

    return "Sucess";
  }

  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFileuser async {
    final path = await localPath;
    return File('$path/user.txt');
  }

  Future<String> readDatauser() async {
    try {
      final file = await localFileuser;
      String body = await file.readAsString();
      setState(() {
        id = body;
      });
      debugPrint(id);
      debugPrint(pass);
      readDatapass();
      return body;
    } catch (e) {
      return "vacio";
    }
  }

  Future<File> writeDatauser(String data) async {
    final file = await localFileuser;
    return file.writeAsString("$data");
  }

  //pass

  Future<File> get localFilepass async {
    final path = await localPath;
    return File('$path/pass.txt');
  }

  Future<String> readDatapass() async {
    try {
      final file = await localFilepass;
      String body = await file.readAsString();
      setState(() {
        pass = body;
      });
      login_user();
      debugPrint(id);
      debugPrint(pass);
      return body;
    } catch (e) {
      return "vacio";
    }
  }

  Future<File> writeDatapass(String data) async {
    final file = await localFilepass;
    return file.writeAsString("$data");
  }

  Future<List> login_user() async {
    int proceso = 1;
    final response = await http.post(
        "http://henrymata.hostingerapp.com/Kingyo_Sushi/Login_Flutter.php",
        body: {
          "ID": id, //controlleruser.text,
          "Contrasena": pass, //controllerpass.text,
          "Proceso": proceso.toString(),
        });
    debugPrint(response.body);
    var datauser = jsonDecode(response.body);

    if (datauser.length != 0) {
         if (datauser[0]['Rol'] == '1') {
        setState(() {
          id = datauser[0]['ID'];
          pass = datauser[0]['Contrasena'];
          username = datauser[0]['Nombre'] +
              ' ' +
              datauser[0]['P_Apellido'] +
              ' ' +
              datauser[0]['S_Apellido'];
        });
        /*Navigator.popUntil(
                    context,
                    ModalRoute.withName('/login_admin'),
                  );*/
        //Navigator.pushReplacementNamed(context, '/login_admin');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Login_Admin(username: username, id: id, contrasena: pass),
            ));

        // debugPrint("administrador");
      } else if (datauser[0]['Rol'] == '0') {
        setState(() {
          id = datauser[0]['ID'];
          contrasena = datauser[0]['Contrasena'];
          username = datauser[0]['Nombre'] +
              ' ' +
              datauser[0]['P_Apellido'] +
              ' ' +
              datauser[0]['S_Apellido'];
          //controllerpass.clear();
          //controlleruser.clear();
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Login_User(username: username, id: id, contrasena: pass),
            ));
        //debugPrint("Normal");
      }
     /* setState(() {
        username = datauser[0]['Nombre'] +
            ' ' +
            datauser[0]['P_Apellido'] +
            ' ' +
            datauser[0]['S_Apellido'];
      });*/
    }
//debugPrint(usuario);
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        title: new Text("Menu"),
        backgroundColor: Colors.orangeAccent[700],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                "Kingyo Sushi & Fusión",
                //" Kingyo Sushi & Fusión",
                style: TextStyle(fontSize: 25),
              ),
              accountEmail: new Text(""),
              currentAccountPicture: new GestureDetector(
                //onTap: () => print("Hola"),

                child: new CircleAvatar(
                  backgroundImage: new AssetImage("assets/images/logo.jpg"),
                ),
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage(
                          "assets/images/backgroundDefault.jpg"))),
            ),
            //////////////login ? admin ? itemsnadmin() : itemsnuser() : itemsnlogin()
            ///

            itemsnlogin(),
          ],
        ),
      ),
      body: RefreshIndicator(
        child: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Center(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Card(
                      child: new Container(
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                                new MaterialPageRoute(
                                  builder: (BuildContext context) => new Detail(
                                        nama: data[index]['Titulo'],
                                        gambar: data[index]['Imagen'],
                                        des: data[index]['Des'],
                                        fecha: data[index]['Fecha'],
                                        precio: '₡' + data[index]['Precio'],
                                      ),
                                ),
                              ),
                        ),
                        height: 200.0,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                              data[index]['Imagen'],
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Text(
                      data[index]['Titulo'],
                      //data[index]['Titulo'],
                      style: new TextStyle(
                          fontSize: 20.0, color: Colors.orangeAccent[700]),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(1.0),
                    ),
                    new Text(
                      data[index]['Des'],
                      style: new TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(2.0),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: data[index]['Fecha'],
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.orangeAccent[700]))
                          ])),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '₡' + data[index]['Precio'],
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white))
                        ])),
                      ],
                    ),

                    /*
                    new Text(
                      data[index]['Fecha'],
                      style: new TextStyle(
                          fontSize: 20.0, color: Colors.orangeAccent[700]),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      
                    ),
                    new Text(
                      '₡' + data[index]['Precio'],
                      style: new TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    */
                    new Padding(
                      padding: new EdgeInsets.all(2.0),
                    ),
                    /*new Divider(
            color: Colors.orange,
          height: 16.0,

            ),*/
                    new SizedBox(
                      height: 10.0,
                      child: new Center(
                        child: new Container(
                          margin: new EdgeInsetsDirectional.only(
                              start: 1.0, end: 1.0),
                          height: 5.0,
                          color: Colors.orangeAccent[700],
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(2.0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        onRefresh: refresh,
      ),
    );
  }
}

class itemsnlogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        children: <Widget>[
          // new Padding(padding: EdgeInsets.all(10.0),),
          new ListTile(
            leading: new Icon(
              Icons.account_circle,
            ),
            title: new Text(
              "Ingresar",
            ),
            onTap: () => Navigator.of(context).pushNamed('/LoginPage'),
            /*onTap: () => Navigator.push(
    context, 
   MaterialPageRoute(builder: (context) => Registro()),
   
  ),*/
          ),
          new ListTile(
            leading: new Icon(Icons.home),
            title: new Text("Inicio"),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Menu"),
            leading: new Icon(Icons.restaurant_menu),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Facebook"),
            leading: new Icon(Icons.face),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Compartir"),
            leading: new Icon(Icons.share),
            onTap: () => null,
          ),
          new Divider(),
          new ListTile(
            title: new Text("Salir"),
            leading: new Icon(Icons.exit_to_app),
            onTap: () => null,
          )
        ],
      ),
    );
  }
}

class itemsnuser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        children: <Widget>[
          // new Padding(padding: EdgeInsets.all(10.0),),
          new ListTile(
            leading: new Icon(Icons.home),
            title: new Text("Inicio"),
            onTap: () => Navigator.of(context).pushNamed('/LoginPage'),
            /*onTap: () => Navigator.push(
    context, 
   MaterialPageRoute(builder: (context) => Registro()),
   
  ),*/
          ),
          new ListTile(
            title: new Text("Menu"),
            leading: new Icon(Icons.restaurant_menu),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Mis Puntos"),
            leading: new Icon(Icons.blur_circular),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Facebook"),
            leading: new Icon(Icons.face),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Compartir"),
            leading: new Icon(Icons.share),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Cambiar Contraseña"),
            leading: new Icon(Icons.vpn_key),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Cerrar Sesión"),
            leading: new Icon(Icons.close),
            onTap: () => null,
          ),
          new Divider(),
          new ListTile(
            title: new Text("Salir"),
            leading: new Icon(Icons.exit_to_app),
            onTap: () => null,
          )
        ],
      ),
    );
  }
}

class itemsnadmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        children: <Widget>[
          // new Padding(padding: EdgeInsets.all(10.0),),
          new ListTile(
            leading: new Icon(Icons.home),
            title: new Text("Inicio"),
            onTap: () => Navigator.of(context).pushNamed('/LoginPage'),
            /*onTap: () => Navigator.push(
    context, 
   MaterialPageRoute(builder: (context) => Registro()),
   
  ),*/
          ),
          new ListTile(
            title: new Text("Menu"),
            leading: new Icon(Icons.restaurant_menu),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Mis Puntos"),
            leading: new Icon(Icons.blur_circular),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Facebook"),
            leading: new Icon(Icons.face),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Compartir"),
            leading: new Icon(Icons.share),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Subir Promoción"),
            leading: new Icon(Icons.cloud_upload),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Gestión de Puntos"),
            leading: new Icon(Icons.add_circle_outline),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Adminstración Usuarios"),
            leading: new Icon(Icons.assignment_ind),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Cambiar Contraseña"),
            leading: new Icon(Icons.vpn_key),
            onTap: () => null,
          ),
          new ListTile(
            title: new Text("Cerrar Sesión"),
            leading: new Icon(Icons.close),
            onTap: () => null,
          ),
          new Divider(),
          new ListTile(
            title: new Text("Salir"),
            leading: new Icon(Icons.exit_to_app),
            onTap: () => null,
          )
        ],
      ),
    );
  }
}

class Detail extends StatelessWidget {
  Detail({this.nama, this.gambar, this.des, this.fecha, this.precio});
  final String nama;
  final String gambar;
  final String des;
  final String precio;
  final String fecha;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new ListView(
        children: <Widget>[
          //new Padding(padding: EdgeInsets.all(0.0),),
          new Container(
              height: 200.0,
              child: new Hero(
                tag: nama,
                child: new Material(
                  child: new InkWell(
                    child: new Image.network(
                      gambar,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )),
          new BagianNama(
            nama: nama,
          ),
          //new BagianIcon(),
          new Keterangan(
            des: des,
            color: Colors.white,
            dis: 10.0,
            tamano: 20.0,
            ali: TextAlign.left,
          ),
          new Keterangan(
            des: "Valido para: " + fecha,
            color: Colors.orangeAccent[700],
            dis: 1.0,
            tamano: 25.0,
            ali: TextAlign.center,
          ),
          new Keterangan(
            des: "Pecio: " + precio,
            color: Colors.redAccent[700],
            dis: 5.0,
            tamano: 30.0,
            ali: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

Widget _info(String nama, String gambar, String des) {
  return Drawer(
    child: Column(
      children: const <Widget>[
        const ListTile(
          leading: const Icon(Icons.search),
          title: const Text("nama"),
        ),
        const ListTile(
          leading: const Icon(Icons.search),
          title: const Text("des"),
        ),
      ],
    ),
  );
}

class BagianNama extends StatelessWidget {
  BagianNama({this.nama});
  final String nama;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.black,
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  nama,
                  style: new TextStyle(
                      fontSize: 30.0, color: Colors.orangeAccent[700]),
                  textAlign: TextAlign.left,
                ),
                /*new Text(
                  "$nama\@gmail.com",
                  style: new TextStyle(fontSize: 17.0, color: Colors.grey)
                ),*/
              ],
            ),
          ),
          /* new Row(
            children: <Widget>[
             /* new Icon(
                Icons.star,
                size: 30.0,
                color: Colors.red,
              ),*/
             /* new Text(
                "12",
                style: new TextStyle(fontSize: 18.0),
              )*/
            ],
          )*/
        ],
      ),
    );
  }
}

class BagianIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new Iconteks(
            icon: Icons.call,
            teks: "Call",
          ),
          new Iconteks(
            icon: Icons.message,
            teks: "Message",
          ),
          new Iconteks(
            icon: Icons.photo,
            teks: "Photo",
          ),
        ],
      ),
    );
  }
}

class Iconteks extends StatelessWidget {
  Iconteks({this.icon, this.teks});
  final IconData icon;
  final String teks;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Icon(
            icon,
            size: 50.0,
            color: Colors.blue,
          ),
          new Text(
            teks,
            style: new TextStyle(fontSize: 18.0, color: Colors.blue),
          )
        ],
      ),
    );
  }
}

class Keterangan extends StatelessWidget {
  Keterangan({this.des, this.color, this.dis, this.tamano, this.ali});
  final String des;
  final Color color;
  final double dis;
  final double tamano;
  final TextAlign ali;
  @override
  Widget build(BuildContext context) {
    return new Container(
      //color: Colors.black,
      padding: new EdgeInsets.all(dis),
      child: new Card(
        color: Colors.black,
        child: new Padding(
          padding: new EdgeInsets.all(dis),
          child: new Text(
            des,
            style: new TextStyle(fontSize: tamano, color: color),
            textAlign: ali,
          ),
        ),
      ),
    );
  }
}

class Registro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

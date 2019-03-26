import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'DrawerItem.dart';
//import 'first_screen.dart';
import 'package:kingyo_sushi/Login.dart';
import 'package:kingyo_sushi/pages/vendedorPage.dart';

void main() => runApp(new MaterialApp(
      home: new Login_Admin(username: "",contrasena: "",id: ""),
      theme: ThemeData.dark(),
      routes: <String, WidgetBuilder>{
        '/vendedorpage': (BuildContext context) => new Vendedor(),
       // '/LoginPage': (BuildContext context) => new LoginPage(),
      },
    ));

class Login_Admin extends StatefulWidget {
  Login_Admin({ Key key, @required this.username,this.id,this.contrasena}) : super(key: key);
    final username;
    final id;
    final contrasena;

   
    @override
  Login_AdminState createState() => Login_AdminState();
}

class Login_AdminState extends State<Login_Admin> {
  //final String url="https://swapi.co/api/people";
  final String url =
      "http://henrymata.hostingerapp.com/Kingyo_Sushi/leer_json.php";
  List data;
  final bool admin = true;
  final bool login = true;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
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

    debugPrint(response.body);
    setState(() {
      var convertDataToJson = jsonDecode(response.body);

      data = convertDataToJson["Promos"];
    });

    return "Sucess";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        
        title: new Text(username==null?"Menu":username),
        backgroundColor: Colors.orange[900],
      ),
      drawer: new Drawer(
        
        child: new ListView(
          
          children: <Widget>[
             new UserAccountsDrawerHeader(
              accountName: new Text("Kingyo Sushi & Fusión", style: TextStyle(fontSize: 25),),
             accountEmail: new Text(username==null?"hola":username),
              currentAccountPicture: new GestureDetector(
                //onTap: () => print("Hola"),
                
                child: new CircleAvatar(
                  
                  backgroundImage: new AssetImage(
                      "assets/images/logo.jpg"),
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
      
             itemsnadmin(),
      
            
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
                          onTap: () =>
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Detail(
                                    nama: data[index]['Titulo'],
                                    gambar: data[index]['Imagen'],
                                    des: data[index]['Des']),
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
                      style: new TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(20.0),
                    ),
                    /* new Text(
                data[index]['Des'],
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                  textAlign: TextAlign.left,
                 ),*/
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
            leading: new Icon(Icons.account_circle,),
            title: new Text("Ingresar",),
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
            onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        )),
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
            onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),),
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
  Detail({this.nama, this.gambar, this.des});
  final String nama;
  final String gambar;
  final String des;

  @override
  Widget build(BuildContext context){
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
          ),
        ],
      ),
    );
  }
}


Widget _info(String nama, String gambar, String des){
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
                  style: new TextStyle(fontSize: 30.0, color: Colors.blue),
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
  Keterangan({this.des});
  final String des;
  @override
  Widget build(BuildContext context) {
    return new Container(
      //color: Colors.black,
      padding: new EdgeInsets.all(10.0),
      child: new Card(
        color: Colors.black,
        child: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Text(
            des,
            style: new TextStyle(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.left,
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
              MaterialPageRoute(builder: (context) => Login_Admin(username: username,id: id,contrasena: contrasena,)),
            );
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

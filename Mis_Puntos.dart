import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingyo_sushi_fusion/main.dart';
import 'package:kingyo_sushi_fusion/pages/login_user.dart';
import 'package:kingyo_sushi_fusion/pages/login_admin.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:kingyo_sushi_fusion/pages/progress_buttom.dart' as ProgressButtonComponent;

String nombre = "";
String puntos = "0";
String mensaje = "";
String id = "";
bool buscar = true;
bool accion = false;
int procesoaccion = 0;
int verpuntos = 0;
bool internet=true;



class MisPuntos extends StatefulWidget {
  MisPuntos({@required this.id});
  final id;
  @override
  _MisPuntosState createState() => _MisPuntosState();
}

class _MisPuntosState extends State<MisPuntos> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;
  @override
  void initState() {
    setState(() {
      nombre = "";
      puntos = "";
      id = "";
      procesoaccion = 0;
      buscar=true;
    });
    Timer(Duration(seconds: 1), () => _gestorpuntos());
    super.initState();
  }

  TextEditingController controllercedula = new TextEditingController();
  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(text),
        duration: Duration(
          seconds: 1,
        )));
  }


  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      puntos = "";
      buscar = true;
    });
    _gestorpuntos();
    //getJsonData();
  }
  Future<Null> actualizar() async {
   // await Future.delayed(Duration(seconds: 2));
    setState(() {
      puntos = "";
      buscar = true;
    });
    _gestorpuntos();
    //getJsonData();
  }



  Future<List> _gestorpuntos() async {
    
   
    try {
      String proceso="3";////////////"1"; ///3 es el nuevo

    setState(() {
      mensaje = "";
      internet=true;
      //id=controllercedula.text;
      //nombre="";
      //puntos="";
    });
    //FocusScope.of(context).requestFocus(new FocusNode());
    final response = await http.post(
        //"https://henrymata.hostingerapp.com/Kingyo_Sushi/Gestor_Puntos_Flutter.php", original
        "https://henrymata.hostingerapp.com/Kingyo_Sushi/Kingyo_Sushi_Procesos.php",
        body: {
          "ID_Admin":"0",
          "ID_Cliente":widget.id,
          "Proceso": proceso,
        });
    //debugPrint(response.body);
    if (proceso == "3") {
      var datauser = jsonDecode(response.body);

      if (datauser.length == 0) {
        setState(() {
          mensaje = "No se encuntra el cliente";
          nombre = "";
        });
        _showSnackBar(mensaje);
      } else {
        setState(() {
          nombre = datauser[0]['Nombre'];
          puntos = datauser[0]['Puntos'];
          buscar = false;
          verpuntos = int.parse(puntos);
          if (verpuntos > 10) {
            verpuntos = 10;
          }
        });
        // _showSnackBar(nombre);
      }
      setState(() {
        procesoaccion = 0;
      });
      return datauser;
    } else {
      _showSnackBar(response.body);
      _gestorpuntos();
    }

    setState(() {
      procesoaccion = 0;
    });
       } catch (e) {
         setState(() {
          internet=false; 
         });
         _showSnackBar("No hay conexión a Internet");

    }
  
  }

    Future<void> _createMovement(done) async {
return done( Random().nextInt(50) % 2 == 0 ? true : false );
  }


 

  @override
  Widget build(BuildContext context) {
          SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: new AppBar(
        title: new Text(
          "Mis Puntos",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red[700],//Colors.orangeAccent[700],
      ),
      body: RefreshIndicator(
        child: ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                top: 100,
              ),
            ),
            puntos != "" 
                ? Center(
                    child: Text(
                    "Mis Puntos",
                    style: TextStyle(
                        color: Colors.white, fontSize: 30),
                  ))
                : Text(""),
            new Padding(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            ),
            Center(
              child: buscar == false
                  ? Container(
                      height: (MediaQuery.of(context).size.height*130)/604,
                      width: MediaQuery.of(context).size.width - 50,
                      child: puntos != ""
                          ? GridView.count(
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this would produce 2 rows.
                              crossAxisCount: 5,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              physics: NeverScrollableScrollPhysics(),
                              // Generate 100 Widgets that display their index in the List
                              children: List.generate(verpuntos, (index) {
                                return Center(
                                  child:
                                  CircleAvatar(
                                    backgroundImage: new AssetImage('assets/images/logo.jpg'),
                                    radius: 50,
                                  ),
                                     // new Image.asset('assets/images/logo.jpg'),
                                );
                              }),
                            )
                          : /*puntos != "" && int.parse(puntos)>10 ?
                          Center(child: Text("+"+ (int.parse(puntos)-10).toString()),)
                          :*/
                          Text(""),
                    )
                  : internet==true?
                   Center(child: CircularProgressIndicator())
                   :
                   Center(
                     child:Column(
                       children: <Widget>[
                         new Padding(
                        padding: EdgeInsets.only(top: 50, ),
                      ),
                        Center(
                          child:Icon(Icons.signal_wifi_off,size: 50, color: Colors.white,),),
                           Center(
                          child:
                          Container(
                      padding: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: new RaisedButton(
                        child: new Text("Actualizar"),
                        color: Colors.green,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          _gestorpuntos();                              
                          //Navigator.pop(context);
                        },
                      ),
                    ),
                          )
                       ],
                     )
                   )
            ),
            puntos != "" && int.parse(puntos) > 10
                ? Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width - 80),
                          width: MediaQuery.of(context).size.width - 30,
                          child: Text(
                            "+" + (int.parse(puntos) - verpuntos).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.orangeAccent[700],
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Puedes cambiar tus puntos en tu próxima compra",
                            style: TextStyle(
                                color: Colors.greenAccent[400], fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  )
                : puntos != ""
                    ? Center(
                        child: 10 - int.parse(puntos) == 1
                            ? Center(
                                child: Text(
                                  "Te falta " +
                                      (10 - int.parse(puntos)).toString() +
                                      " punto para obtener una regalía",
                                  style: TextStyle(
                                      color: Colors.greenAccent[400], fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : verpuntos < 10
                                ? verpuntos > 0
                                    ? Center(
                                        child: Text(
                                          "Te faltan " +
                                              (10 - int.parse(puntos))
                                                  .toString() +
                                              " puntos para obtener una regalía",
                                          style: TextStyle(
                                              color: Colors.greenAccent[400],
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          "No tienes puntos registrados \n\n Consigue puntos por cada compra",
                                          style: TextStyle(
                                              color: Colors.greenAccent[400],
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                : Center(
                                    child: Text(
                                      "Puedes cambiar tus puntos en tu próxima compra",
                                      style: TextStyle(
                                          color: Colors.greenAccent[400],
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                    : buscar == false
                        ? Center(
                            child: Text(
                              "No tienes puntos registrados \n\n Consigue puntos por cada compra",
                              style: TextStyle(
                                color: Colors.greenAccent[400],
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Center(
                            child: Text(""),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                          ),
                          buscar==false?
                          Center(
                            child:
                          Container(
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: new RaisedButton(
                        child: new Text("Actualizar"),
                        color: Colors.green,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          actualizar();
                          //Navigator.pop(context);
                        },
                      ),
             ),
                          ):Text(""),
                          
          ],
        ),
        onRefresh: refresh,
      ),
    );
  }
}

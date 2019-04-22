import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:imageswipe/pages/fecha_nacimiento.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;



String fechanacimiento = DateTime.now().day.toString() +
    '/' +
    DateTime.now().month.toString() +
    '/' +
    DateTime.now().year.toString();
String fechaActual = DateTime.now().year.toString() +
    '-' +
    DateTime.now().month.toString() +
    '-' +
    DateTime.now().day.toString();
    String fechanacimientosend='';

const List<String> imagenes = const <String>[
  'assets/images/0.jpg',
  'assets/images/1.jpg',
  'assets/images/2.jpg',
  'assets/images/3.jpg',
  'assets/images/4.jpg',
  'assets/images/5.jpg',
  'assets/images/6.jpg',
  'assets/images/7.jpg',
  'assets/images/8.jpg',
  'assets/images/9.jpg',
  'assets/images/10.jpg',
];

void main() => runApp(new SubirPromo());

class SubirPromo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SubirPromoPage(title: 'Subir Promoción'),
            routes: <String, WidgetBuilder>{
              '/SubirPromoPage': (BuildContext context) => SubirPromoPage(),
      },
    );
  }
}

class SubirPromoPage extends StatefulWidget {
  SubirPromoPage(
      {Key key,
      this.title,
      this.indexpageLocal,
      this.subir,
      this.local,
      this.indexpageServer})
      : super(key: key);
  int indexpageLocal;
  int indexpageServer;
  final String title;
  bool subir;
  bool local;

  @override
  _SubirPromoPageState createState() => _SubirPromoPageState();
}

class _SubirPromoPageState extends State<SubirPromoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Function _showBottomSheetCallback;
  bool showDatePicker = false;
  List data;
  TextEditingController titulopromo = new TextEditingController();
  TextEditingController descripcionpromo = new TextEditingController();
  TextEditingController preciopromo = new TextEditingController();
  TextEditingController fechapromo = new TextEditingController();

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    getJsonData();
  }

  @override
  void initState() {
    widget.indexpageServer = 0;
    widget.indexpageLocal = 0;
    widget.local = true;
    widget.subir = false;
    this.getJsonData();
    //debugPrint(id);
    //debugPrint(pass);
    super.initState();
  }

  /*final response = await http.post(
        "http://henrymata.hostingerapp.com/Kingyo_Sushi/Login_Flutter.php",
        body: {
          "ID": id, //controlleruser.text,
          "Contrasena": pass, //controllerpass.text,
          "Proceso": proceso.toString(),
        });*/

void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  Future<String> getJsonData() async {
    /*var response = await http.get(
//encode the url
        Uri.encodeFull(url),
//only accept json response
        
        headers: {"Accept": "application/json; charset=utf-8"});*/

    var proceso = 1;
    final response = await http.post(
        "http://henrymata.hostingerapp.com/Kingyo_Sushi/Imagenes_subir_Flutter.php",
        //"http://henrymata.hostingerapp.com/Kingyo_Sushi/leer_json.php",
        body: {
          "Proceso": proceso.toString(),
        });
    debugPrint(response.body);
    setState(() {
      var convertDataToJson = jsonDecode(response.body);

      data = convertDataToJson;
    });

    return "Sucess";
  }

  void _handlePageChanged(int page) {
    if (widget.local == true) {
      setState(() {
        widget.indexpageLocal = page;
      });
    } else {
      setState(() {
        widget.indexpageServer = page;
      });
    }
    //indexpageServer
  }

  void _subir(int page) {
    setState(() {
      if (widget.subir == true) {
        widget.subir = false;
      } else {
        widget.subir = true;
      }
    });
  }

  void subirdos() {
    setState(() {
      if (widget.subir == true) {
        widget.subir = false;
      } else {
        widget.subir = true;
      }
    });
  }

  _launchURL() async {
    const url = 'tel:71305184';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //Subir Imagen
  File _image;
  TextEditingController cTitle = new TextEditingController();

  Future getImageGallery() async {
    try {
      var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;

      int rand = new Math.Random().nextInt(100000);

      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, 500);

      var compressImg = new File("$path/image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

      setState(() {
        _image = compressImg;
      });
    } catch (e) {}
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImg;
    });
  }

  Future upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(
        "http://henrymata.hostingerapp.com/Kingyo_Sushi/Subir_Imagen_Flutter.php");

    var request = new http.MultipartRequest("POST", uri);

    var index = imageFile.path.lastIndexOf('/') + 1;
    var nombre = imageFile.path.substring(index);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    //request.fields['title'] = cTitle.text;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }


//fecha

_showBottomSheet(String picker) {
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet<Null>(
          (BuildContext context) {
                return DatePicker(
                  key: dobKey,
                  setDate: _setDate,
                  customShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  customItemColor: Colors.black, //Color(0xFFba5905),
                  customGradient:
                      LinearGradient(begin: Alignment(-0.5, 1.0), colors: [
                    Color(0xFFba5905),
                    Color(0xFFefcaaa),
                    Color(0xFFba5905),
                  ]),
                );
          },
        )
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button
              _showBottomSheetCallback = _showBottomSheet;
            });
          }
        });
  }

  void _setDate() {
    Navigator.of(context).pop();
    var mes = 1;
    switch (dobKey.currentState.dobStrMonth) {
      case 'Ene':
        mes = 1;
        break;
      case 'Feb':
        mes = 2;
        break;
      case 'Mar':
        mes = 3;
        break;
      case 'Abr':
        mes = 4;
        break;
      case 'May':
        mes = 5;
        break;
      case 'Jun':
        mes = 6;
        break;
      case 'Jul':
        mes = 7;
        break;
      case 'Ago':
        mes = 8;
        break;
      case 'Set':
        mes = 9;
        break;
      case 'Oct':
        mes = 10;
        break;
      case 'Nov':
        mes = 11;
        break;
      case 'Dic':
        mes = 12;
        break;
    }
    fechanacimiento = (dobKey.currentState.dobDate +
        '/' +
        '${dobKey.currentState.dobStrMonth}' +
        '/' +
        ' ${dobKey.currentState.dobYear}');

    fechanacimientosend = (dobKey.currentState.dobYear.toString() +
        '-' +
        mes.toString() +
        '-' +
        '${dobKey.currentState.dobDate}');
        //Navigator.of(context).pop();
  }

 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       key: _scaffoldKey,
      appBar: new AppBar(
       title: new Text(widget.title),
        ),
      body:
          RefreshIndicator(
        child: Form(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            /*decoration: new BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.cover,
                image: new AssetImage("assets/images/backgroundDefault.jpg")),
          ),*/
            child: ListView(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      width: 100,
                      child: Container(

                          //padding: EdgeInsets.only(top: 2),
                          //width: 10,//MediaQuery.of(context).size.width / 1.5,
                          child: new Center(
                        child: new RaisedButton(
                          child: widget.local == false
                              ? new Text("Locales")
                              : new Text("En Servidor"),
                          color: widget.local == false
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            try {
                              if (widget.local == true) {
                                setState(() {
                                  widget.local = false;

                                  widget.indexpageServer = 0;

                                  widget.subir = false;
                                });
                              } else {
                                setState(() {
                                  widget.local = true;

                                  widget.indexpageLocal = 0;

                                  widget.subir = false;
                                });
                              }
                            } catch (e) {
                              widget.indexpageServer = 0;
                              widget.indexpageLocal = 0;
                            }
                          },
                        ),
                      )),
                    ),
                  ],
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                new Container(
                  height: 200,
                  //width: MediaQuery.of(context).size.width,
                  child: widget.local == true
                      ? new Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return new Image.asset(
                              imagenes[index],
                              fit: BoxFit.fill,
                            );
                          },
                          onIndexChanged: _handlePageChanged,
                          itemCount: imagenes.length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                          loop: false,
                          onTap: _subir,
                        )
                      : widget.subir == false
                          ? new Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return new Image.network(
                                  data[index]['Imagen'],
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.low,
                                );
                              },
                              onIndexChanged: _handlePageChanged,
                              itemCount: data.length,
                              viewportFraction: 0.8,
                              scale: 0.9,
                              loop: false,
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: Center(
                                      child: _image == null
                                          ? new Text("Seleccione una imagen!")
                                          : new Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  10,
                                              height: 200,
                                              child: new Image.file(
                                                _image,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                    ),
                                  ),
                                  /*Row(
                                    children: <Widget>[
                                      RaisedButton(
                                        child: Icon(Icons.image),
                                        onPressed: getImageGallery,
                                      ),

                                      /*RaisedButton(
                        child: Icon(Icons.camera_alt),
                        onPressed: getImageCamera,
                      ),*/
                                      Expanded(
                                        child: Container(),
                                      ),
                                      RaisedButton(
                                        child: Text("Subir Imagen"),
                                        onPressed: () {
                                          upload(_image);
                                        },
                                      ),
                                    ],
                                  ),*/
                                ],
                              ),
                            ),
                ),
                /*new Center(
                  child: widget.local == true
                      ? new Text(widget.indexpageLocal == null
                          ? "0"
                          : imagenes[widget.indexpageLocal])
                      : new Text(widget.indexpageLocal == null
                          ? "0"
                          : data[widget.indexpageServer]['Imagen']),
                ),*/
                new Center(
                  child: widget.local == false
                      ? widget.subir == false
                          ? Container(
                              //padding: EdgeInsets.only(top: 2),
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: new RaisedButton(
                                child: new Text("Subir Imagen"),
                                color: Colors.orangeAccent,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: subirdos,
                              ),
                            )
                          : Row(
                              children: <Widget>[
                                new Padding(
                                  padding: new EdgeInsets.only(
                                    left: 10,
                                  ),
                                ),
                                Container(
                                  //padding: EdgeInsets.only(top: 2),
                                  width:
                                      80, //MediaQuery.of(context).size.width / 1.5,
                                  child: new RaisedButton(
                                    child: Icon(Icons.image),
                                    color: Colors.blueAccent,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: getImageGallery,
                                  ),
                                ),
                                /* RaisedButton(
                              child: Icon(Icons.image),
                              onPressed: getImageGallery,
                            ),

                            RaisedButton(
                              child: Icon(Icons.camera_alt),
                              onPressed: subirdos,
                            ),*/
                                new Padding(
                                  padding: new EdgeInsets.only(
                                    left: 50,
                                  ),
                                ),
                                Container(
                                  //padding: EdgeInsets.only(top: 2),
                                  width:
                                      100, //MediaQuery.of(context).size.width / 1.5,
                                  child: new RaisedButton(
                                    child: new Text("Cancelar"),
                                    color: Colors.orangeAccent,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: subirdos,
                                  ),
                                ),
                              ],
                            )
                      : null,
                ),
                new Padding(
                  padding: new EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.text,
                    /*inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],*/
                    controller: titulopromo,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.title,
                        color: Colors.black,
                      ),
                      hintText: "Titulo",
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    controller: descripcionpromo,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.description,
                        color: Colors.black,
                      ),
                      hintText: "Descripción",
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: preciopromo,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.monetization_on,
                        color: Colors.black,
                      ),
                      hintText: "Precio",
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: fechapromo,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.black,
                      ),
                      hintText: "Fecha",
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(
                    bottom: 20,
                  ),
                ),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          'Fecha Nacimiento: ' + fechanacimiento,
                        ),
                        textColor: Colors.black54,
                        onPressed: () {
                          _showBottomSheet('DatePicker');
                          
                          /* showDatePicker(
                              
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                              
                              ).then<DateTime>((DateTime value)
                              {
                                if (value!=null)
                                {
                                  setState(() {
                                   fechanacimiento=value.day.toString()+'/'+value.month.toString()+'/'+value.year.toString(); 
                                  });
                                }
                              });*/
                        },
                      ),
                    ),
                Container(
                  padding: EdgeInsets.only(left: 70,right: 70),
                  width: 60, //MediaQuery.of(context).size.width / 1.5,
                  child: new RaisedButton(
                    child: new Text("Subir Promoción"),
                    color: Colors.greenAccent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: (){},
                  ),
                ),
                 new Padding(
                  padding: new EdgeInsets.only(
                    bottom: 20,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 70,right: 70),
                  width: 60, //MediaQuery.of(context).size.width / 1.5,
                  child: new RaisedButton(
                    child: new Text("Cancelar"),
                    color: Colors.redAccent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: (){},
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(
                    bottom: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
        onRefresh: refresh,
      ),
    );
  }
}

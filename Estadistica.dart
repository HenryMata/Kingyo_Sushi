import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingyo_sushi_fusion/main.dart';
import 'package:kingyo_sushi_fusion/pages/login_user.dart';
import 'package:kingyo_sushi_fusion/pages/login_admin.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:kingyo_sushi_fusion/pages/progress_buttom.dart'
    as ProgressButtonComponent;
import 'package:fl_chart/fl_chart.dart';

int dia = 0;
int valor = 0;
int mayorvalor = 0;

String fde;
String fhe;

String mensaje = "";
bool buscar = true;
bool accion = false;
int procesoaccion = 0;
bool datos =false;

int verpuntos = 0;
bool internet = true;
int difference = 0;
var temp;
List<FlSpot> spot;
    String dropdownValue = 'Ingreso';
var _listaprocesos =['Ingreso','Registro', 'Consulta Puntos', 'Subir Puntos', 'Canjear Puntos','Otros'];
class Estadisticas extends StatefulWidget {
  @override
  _EstadisticasState createState() => _EstadisticasState();
}

class _EstadisticasState extends State<Estadisticas> {
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
      dia = 0;
      datos=false;
      valor = 0;
      mayorvalor = 0;
      procesoaccion = 0;
      buscar = true;
      fde=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
      fhe=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
      spot=new List(400);
    });
    // _gestorpuntos();
    difference = 0;
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
      valor = 0;
      buscar = true;
    });
    _consulta();
    //getJsonData();
  }

  Future<List> _consulta() async {
    try {
      String proceso = "20"; ////////////"1"; ///3 es el nuevo

      setState(() {
        if (spot!=null)
        {
        
        spot=null;
        
        }
        mensaje = "";
        datos=false;
        internet = true;
        //id=controllercedula.text;
        //nombre="";
        //puntos="";
      });
      //FocusScope.of(context).requestFocus(new FocusNode());
      final response = await http.post(
          //"https://henrymata.hostingerapp.com/Kingyo_Sushi/Gestor_Puntos_Flutter.php", original
          "https://henrymata.hostingerapp.com/Kingyo_Sushi/Kingyo_Sushi_Procesos.php",
          body: {
            //"ID": widget.id, //controlleruser.text,
            "fde" : fde,
            "fhe" : fhe,
            "Proceso": proceso, //3
          });
      //debugPrint(response.body);
      if (proceso == "20") {
       var datauser  = jsonDecode(response.body);
        print(response.body);
        if (datauser.length == 0) {
          setState(() {
            datos=false;
            mensaje = "No hay datos";
            dia = 0;
          });
          _showSnackBar(mensaje);
        } else {
          setState(() {
              temp=datauser;
              spot[0]=FlSpot(1.0,5.0);// temp;
              for (var i = 0; i < 3; i++) {
               // spot[i]=FlSpot(i.toDouble(), double.parse(datauser[i]["Valor"].toString()));
                //spot.add(FlSpot(i.toDouble(), 2));
              }
            datos=true;
            //dia = int.parse(datauser[0]['Dia'].toString());
           // valor = int.parse(datauser[0]['Valor'].toString());
            buscar = false;
           
          });
          // _showSnackBar(nombre);
        }
        setState(() {
          procesoaccion = 0;
        });
        return datauser;
      } else {
        _showSnackBar(response.body);
        _consulta();
      }

      setState(() {
        procesoaccion = 0;
      });
    } catch (e) {
      setState(() {
        datos=false;
        internet = false;
      });
      print(e);
      _showSnackBar("No hay conexión a Internet");
    }
  }

  Future<void> _createMovement(done) async {
    return done(Random().nextInt(50) % 2 == 0 ? true : false);
  }

  DateTime selectedDate_desde = DateTime.now();
  DateTime selectedDate_hasta = DateTime.now();

  Future<Null> _selectDate_desde(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate_desde,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate_desde)
      setState(() {
        selectedDate_desde = picked;
        fde=picked.day.toString()+"-"+picked.month.toString()+"-"+picked.year.toString();
      });
    final desde = DateTime(selectedDate_desde.year, selectedDate_desde.month,
        selectedDate_desde.day);
    final hasta = DateTime(selectedDate_hasta.year, selectedDate_hasta.month,
        selectedDate_hasta.day);
    difference = hasta.difference(desde).inDays;
  }

  Future<Null> _selectDate_hasta(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate_hasta,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate_hasta)
      setState(() {
        selectedDate_hasta = picked;
        fhe=picked.day.toString()+"-"+picked.month.toString()+"-"+picked.year.toString();
      });

    final desde = DateTime(selectedDate_desde.year, selectedDate_desde.month,
        selectedDate_desde.day);
    final hasta = DateTime(selectedDate_hasta.year, selectedDate_hasta.month,
        selectedDate_hasta.day);
    difference = hasta.difference(desde).inDays;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        appBar: new AppBar(
          title: new Text(
            "Estadisticas",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red[700], //Colors.orangeAccent[700],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 20,top: 10)),
                  Text("Proceso"),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Center(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      items: _listaprocesos.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[Text("Fecha Desde:")],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Column(
                      children: <Widget>[
                        Text(selectedDate_desde.day.toString() +
                            "/" +
                            selectedDate_desde.month.toString() +
                            "/" +
                            selectedDate_desde.year.toString())
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () => _selectDate_desde(context),
                          child: Icon(Icons.date_range),
                        )
                      ],
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[Text("Fecha  Hasta:")],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Column(
                      children: <Widget>[
                        Text(selectedDate_hasta.day.toString() +
                            "/" +
                            selectedDate_hasta.month.toString() +
                            "/" +
                            selectedDate_hasta.year.toString())
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () => _selectDate_hasta(context),
                          child: Icon(Icons.date_range),
                        )
                      ],
                    )
                  ],
                )),

            Container(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text(difference != null && difference != 0
                    ? "Dias: " + difference.toString()
                    : "Dias: 0")),

            Center(
              child: Container(
                padding: EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width / 1.5,
                child: new RaisedButton(
                  child: new Text("Consultar"),
                  color: Colors.green,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    _consulta();
                    //registro();
                    //Navigator.pop(context);
                  },
                ),
              ),
            ),


            
            /////////////grafico
            datos==true?
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: Color(0xff232d37)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: FlChart(
                    chart: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalGrid: true,
                          getDrawingVerticalGridLine: (value) {
                            return const FlLine(
                              color: Color(0xff37434d),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingHorizontalGridLine: (value) {
                            return const FlLine(
                              color: Color(0xff37434d),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          horizontalTitlesTextStyle: TextStyle(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          getHorizontalTitles: (value) {
                            //for (var t=0;t<difference;t++)
                            //{
                              return (value+1.0).toInt().toString();
                            //}
                            /*switch (value.toInt()) {
                              case 2:
                                return "MAR";
                              case 5:
                                return "JUN";
                              case 8:
                                return "SEP";
                            }*/

                            //return "";
                          },
                          verticalTitlesTextStyle: TextStyle(
                            color: Color(0xff67727d),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          getVerticalTitles: (value) {

                            //for (var v=0;v<temp.length;v++)
                            //{
                              //return temp[value.toInt()]["Valor"].toString();
                              return value.toInt().toString();
                            //}
                            /*switch (value.toInt()) {
                              case 1:
                                return "10k";
                              case 3:
                                return "30k";
                              case 5:
                                return "50k";
                            }*/
                            return "";
                          },
                          verticalTitlesReservedWidth: 28,
                          verticalTitleMargin: 12,
                          horizontalTitleMargin: 8,
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border:
                                Border.all(color: Color(0xff37434d), width: 1)),
                        minX: 0,
                        maxX: difference.toDouble(),///para el lado
                        minY: 0,
                        maxY: mayorvalor+10.toDouble(),//para arriba
                        lineBarsData: [
                          LineChartBarData(
                            spots:  
                             [
                              FlSpot(0, 3),
                              FlSpot(2.6, 2),
                              FlSpot(4.9, 5),
                              FlSpot(6.8, 3.1),
                              FlSpot(8, 4),
                              FlSpot(9.5, 3),
                              FlSpot(11, 4),
                              
                            ],
                            isCurved: true,
                            colors: gradientColors,
                            barWidth: 5,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: false,
                            ),
                            belowBarData: BelowBarData(
                              show: true,
                              colors: gradientColors
                                  .map((color) => color.withOpacity(0.3))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ):
            Text(""),
          ],
        ));
  }
}

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bezier_chart/bezier_chart.dart';


  bool hay_datos;
class Charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //debugShowCheckedModeBanner: false,
      title: 'Pruebas',
      home: new ChartsPage(),
    );
  }
}

class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


    @override
  void initState() {
      hay_datos=false;

    super.initState();
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

Future<List> _consulta() async {
    try {

      final response = await http.post(
          "https://henrymata.hostingerapp.com/Kingyo_Sushi/Kingyo_Sushi_Procesos.php",
          body: {
            "fd" : "08-07-2019",//fecha desde 
            "fh" : "13-07-2019",//fecha hasta 
            "Proceso": "20",
          });
       var datauser  = jsonDecode(response.body);
        print(response.body);
        if (datauser.length == 0) {
         
          _showSnackBar("No existen registros");
        }
        else
        {
          ///
          ///aqui deberia ir el codigo del map 
          ///
          setState(() {
          hay_datos=true;  
          });
        }

        return datauser;

    } catch (e) {
      print(e);
      _showSnackBar("No hay conexión a Internet");
    }
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
      //resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text("Estadisticas"),
        backgroundColor: Colors.red[700],//Colors.orangeAccent[700],
      ),
      body: ListView(
        children: <Widget>[
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
        //charts.LineChart(_createRandomData(), animate: true),
        hay_datos==true?
        Center(
    child: Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width * 0.9,
      child: BezierChart(
        bezierChartScale: BezierChartScale.CUSTOM,
        xAxisCustomValues: const [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85],
        series: const [
          BezierLine(
            data: const [
              DataPoint<double>(value: 10, xAxis: 0),
              DataPoint<double>(value: 130, xAxis: 5),
              DataPoint<double>(value: 50, xAxis: 10),
              DataPoint<double>(value: 150, xAxis: 15),
              DataPoint<double>(value: 75, xAxis: 20),
              DataPoint<double>(value: 0, xAxis: 25),
              DataPoint<double>(value: 5, xAxis: 30),
              DataPoint<double>(value: 45, xAxis: 35),
              DataPoint<double>(value: 10, xAxis: 40),
              DataPoint<double>(value: 130, xAxis: 45),
              DataPoint<double>(value: 50, xAxis: 50),
              DataPoint<double>(value: 150, xAxis: 55),
              DataPoint<double>(value: 150, xAxis: 60),
              DataPoint<double>(value: 75, xAxis: 65),
              DataPoint<double>(value: 0, xAxis: 70),
              DataPoint<double>(value: 5, xAxis: 75),
              DataPoint<double>(value: 150, xAxis: 80),
              DataPoint<double>(value: 150, xAxis: 55),
              
            ],
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 5.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: true,
          backgroundColor: Colors.red,
          snap: false,
        ),
      ),
    ),
  ):
  Text(""),

        ],
      ),
    );
  }
}



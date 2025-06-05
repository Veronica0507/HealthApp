import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/registro': (context) => RegistroScreen(),
      },
    );
  }
}

class UserData {
  final String usuario;
  final String edad;
  final String genero;
  final String ocupacion;

  UserData(this.usuario, this.edad, this.genero, this.ocupacion);
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Health App',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/registro'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'COMENZAR',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: 'Health App ',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Registro',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLabeledField('Nombre de usuario', userController),
              buildLabeledField('Edad', ageController),
              buildLabeledField('Género', genderController),
              buildLabeledField('Ocupación', jobController),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final userData = UserData(
                    userController.text,
                    ageController.text,
                    genderController.text,
                    jobController.text,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VariableScreen(userData: userData),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'SIGUIENTE',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabeledField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VariableScreen extends StatelessWidget {
  final UserData userData;

  VariableScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: 'Health App ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Variable fisiológica',
                style: TextStyle(color: Colors.cyan),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Señal Electrocardiograma',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ECGFromCSVScreen(userData: userData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'INICIAR TOMA',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ECGFromCSVScreen extends StatefulWidget {
  final UserData userData;
  ECGFromCSVScreen({required this.userData});

  @override
  _ECGFromCSVScreenState createState() => _ECGFromCSVScreenState();
}

class _ECGFromCSVScreenState extends State<ECGFromCSVScreen> {
  List<FlSpot> ecgData = [];
  int index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final rawData = await rootBundle.loadString('assets/ecg_simulation.csv');
    final lines = rawData.split('\n');

    List<FlSpot> parsedData = [];
    for (int i = 0; i < lines.length; i++) {
      final value = lines[i].trim();
      if (value.isNotEmpty) {
        final y = double.tryParse(value);
        if (y != null) {
          parsedData.add(FlSpot(i.toDouble(), y));
        }
      }
    }

    setState(() {
      ecgData = parsedData;
    });

    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (index + 50 < ecgData.length) {
        setState(() {
          index += 1;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<FlSpot> get currentWindow {
    int start = index < 50 ? 0 : index - 50;
    return ecgData.sublist(start, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health App Recomendación'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              child:
                  ecgData.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: currentWindow,
                              isCurved: false,
                              color: Colors.teal,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                        ),
                      ),
            ),
            SizedBox(height: 20),
            Text(
              'Edad: ${widget.userData.edad} años',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Género: ${widget.userData.genero}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '${widget.userData.usuario}, recuerda compartir esta señal con tu médico si es necesario.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'FINALIZAR',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart' show rootBundle;

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

const double ecgMaxY = 1.2;
const Duration refreshRate = Duration(milliseconds: 50);
const Color primaryColor = Colors.cyan;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Text('Health App',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/registro'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('COMENZAR', style: TextStyle(fontSize: 18)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text('Viendo por tu salud',
                    style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700])),
              ),
            ],
          ),
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
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Health App Registro'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildField('Nombre de usuario', userController),
                buildField('Edad', ageController, isNumber: true),
                buildField('Género', genderController),
                buildField('Ocupación', jobController),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = UserData(
                        userController.text,
                        ageController.text,
                        genderController.text,
                        jobController.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VariableScreen(userData: data)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child:
                      Text('SIGUIENTE', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ]),
    );
  }
}

class VariableScreen extends StatefulWidget {
  final UserData userData;
  VariableScreen({required this.userData});

  @override
  _VariableScreenState createState() => _VariableScreenState();
}

class _VariableScreenState extends State<VariableScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Variable fisiológica'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(Icons.favorite, color: Colors.redAccent, size: 60),
            ),
            SizedBox(height: 20),
            Text('Señal Electrocardiograma',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ECGFromCSVScreen(userData: widget.userData)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('INICIAR TOMA', style: TextStyle(fontSize: 16)),
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

    ecgData = [];
    for (int i = 0; i < lines.length; i++) {
      final y = double.tryParse(lines[i].trim());
      if (y != null) ecgData.add(FlSpot(i.toDouble(), y));
    }

    _timer = Timer.periodic(refreshRate, (timer) {
      if (index + 50 < ecgData.length) {
        setState(() => index += 1);
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
    int start = index < 90 ? 0 : index - 90;
    return ecgData.sublist(start, index);
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.userData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendación'),
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
              child: ecgData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : LineChart(
                      LineChartData(
                        minY: -ecgMaxY,
                        maxY: ecgMaxY,
                        lineBarsData: [
                          LineChartBarData(
                            spots: currentWindow,
                            isCurved: true,
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
            Text('Edad: ${u.edad} años', style: TextStyle(fontSize: 18)),
            Text('Género: ${u.genero}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('${u.usuario}, recuerda compartir esta señal con tu médico si es necesario.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('FINALIZAR', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

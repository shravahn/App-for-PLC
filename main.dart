import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PLC Data Viewer',
      theme: ThemeData(
        primaryColor: Colors.indigo[700],
        scaffoldBackgroundColor: Colors.grey[200],
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                // Placeholder authentication logic (replace with your own)
                if (_usernameController.text == 'admin' &&
                    _passwordController.text == 'password') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid credentials'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _plcData = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedMachine = 'All';
  String _selectedSensor = 'All';
  DateTime _selectedDateTime = DateTime.now();

  final List<String> _machines = ['All', 'Machine A', 'Machine B'];
  final List<String> _sensors = ['All', 'Proximity Sensor 1', 'Proximity Sensor 2'];

  @override
  void initState() {
    super.initState();
    _fetchPLCData();
  }

  Future<void> _fetchPLCData() async {
    setState(() => _isLoading = true);
    try {
      String csvString = await rootBundle.loadString('assets/plc_data.csv');
      LineSplitter ls = LineSplitter();
      List<String> lines = ls.convert(csvString);

      List<String> headers = lines.first.split(',');
      for (int i = 1; i < lines.length; i++) {
        List<String> values = lines[i].split(',');
        Map<String, dynamic> data = {};
        for (int j = 0; j < headers.length; j++) {
          if (headers[j] == 'dateTime') {
            data[headers[j]] = values[j];
          } else if (headers[j] == 'counter' || headers[j] == 'value') {
            data[headers[j]] = int.parse(values[j]);
          } else {
            data[headers[j]] = values[j];
          }
        }
        _plcData.add(data);
      }

      setState(() {
        _plcData = _plcData.where((data) =>
        (_selectedMachine == 'All' || data['machine'] == _selectedMachine) &&
            (_selectedSensor == 'All' || data['sensor'] == _selectedSensor) &&
            (DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(data['dateTime'])) ==
                DateFormat('yyyy-MM-dd').format(_selectedDateTime))).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLC Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchPLCData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
          : Column(
        children: [
          // Filter DropdownButtons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                value: _selectedMachine,
                items: _machines.map((machine) => DropdownMenuItem(
                  value: machine,
                  child: Text(machine),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMachine = value!;
                    _fetchPLCData();
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedSensor,
                items: _sensors.map((sensor) => DropdownMenuItem(
                  value: sensor,
                  child: Text(sensor),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSensor = value!;
                    _fetchPLCData();
                  });
                },
              ),
              // Date Picker (you'll need to add a date picker package)
              ElevatedButton(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );
                  if (newDate != null && newDate != _selectedDateTime) {
                    setState(() {
                      _selectedDateTime = newDate;
                      _fetchPLCData();
                    });
                  }
                },
                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDateTime)),
              ),
            ],
          ),
          // Data ListView
          Expanded(
            child: ListView.builder(
              itemCount: _plcData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      _plcData[index]['sensor'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Machine: ${_plcData[index]['machine']}'),
                        Text('Counter: ${_plcData[index]['counter']}'),
                        Text(
                          'Date/Time: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(_plcData[index]['dateTime']))}',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    trailing: Text(
                      _plcData[index]['value'].toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

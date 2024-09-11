# welappp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
/*
import 'dart:convert'; // For parsing CSV data
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date/time formatting
import 'package:flutter/services.dart' show rootBundle; // For accessing assets

void main() => runApp(MyApp()); // Entry point of the Flutter app

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
// Create the root MaterialApp widget with theme customization
return MaterialApp(
title: 'PLC Data Viewer', // Title for the app
theme: ThemeData(
primaryColor: Colors.indigo[700], // Primary color for the app bar and other components
scaffoldBackgroundColor: Colors.grey[200], // Background color for the app
cardTheme: CardTheme( // Style for the cards in the dashboard
elevation: 3, // Shadow effect on the cards
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
),
),
home: LoginScreen(), // Start with the login screen
);
}
}

class LoginScreen extends StatelessWidget {
// Controllers for the username and password input fields
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)), // Login screen title
),
body: Padding(
padding: const EdgeInsets.all(16.0), // Padding around the input fields and button
child: Column(
mainAxisAlignment: MainAxisAlignment.center, // Center the contents vertically
children: [
TextField(
controller: _usernameController,
decoration: InputDecoration(
labelText: 'Username',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)), // Rounded input field
),
),
SizedBox(height: 16), // Spacing between the input fields
TextField(
controller: _passwordController,
decoration: InputDecoration(
labelText: 'Password',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
),
obscureText: true, // Hide the password characters
),
SizedBox(height: 32), // Spacing before the login button
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.indigo,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // Rounded button
padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
),
onPressed: () {
// Placeholder authentication logic (replace with your actual logic)
if (_usernameController.text == 'admin' && _passwordController.text == 'password') {
// Navigate to DashboardScreen if credentials are correct
Navigator.push(
context,
MaterialPageRoute(builder: (context) => DashboardScreen()),
);
} else {
// Show error message if credentials are incorrect
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Invalid credentials'), backgroundColor: Colors.red),
);
}
},
child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
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
List<Map<String, dynamic>> _plcData = []; // List to store PLC data from CSV
bool _isLoading = true; // Flag to indicate data loading state
String? _errorMessage; // To store any error message during data fetching

// Filter variables
String _selectedMachine = 'All';
String _selectedSensor = 'All';
DateTime _selectedDateTime = DateTime.now();

// Lists for filter options
final List<String> _machines = ['All', 'Machine A', 'Machine B'];
final List<String> _sensors = ['All', 'Proximity Sensor 1', 'Proximity Sensor 2'];

@override
void initState() {
super.initState();
_fetchPLCData(); // Fetch PLC data when the widget is initialized
}

// Function to fetch PLC data from the CSV file
Future<void> _fetchPLCData() async {
setState(() => _isLoading = true); // Show loading indicator
try {
String csvString = await rootBundle.loadString('assets/plc_data.csv'); // Load CSV from assets
LineSplitter ls = LineSplitter();
List<String> lines = ls.convert(csvString); // Split the CSV into lines

      List<String> headers = lines.first.split(','); // Get headers from the first line

      // Loop through the remaining lines (data rows)
      for (int i = 1; i < lines.length; i++) {
        List<String> values = lines[i].split(',');
        Map<String, dynamic> data = {};

        for (int j = 0; j < headers.length; j++) {
          String header = headers[j];
          String value = values[j];

          if (header == 'dateTime') {
            data[header] = value; // Keep dateTime as a string for later formatting
          } else if (header == 'counter') {
            data[header] = int.tryParse(value); // Parse counter as int, or null if not possible
          } else if (header == 'value') {
            data[header] = double.tryParse(value); // Parse value as double, or null if not possible (to avoid FormatException)
          } else {
            data[header] = value; // Store other values as strings
          }
        }
        _plcData.add(data); // Add the parsed data to the _plcData list
      }

      setState(() {
        // Filter the data based on the selected options
        _plcData = _plcData.where((data) =>
            (_selectedMachine == 'All' || data['machine'] == _selectedMachine) &&
            (_selectedSensor == 'All' || data['sensor'] == _selectedSensor) &&
            (DateFormat('yyyy-MM-dd').format(DateTime.parse(data['dateTime'])) == DateFormat('yyyy-MM-dd').format(_selectedDateTime))
        ).toList();
        _isLoading = false; // Data loading is complete
      });
    } catch (e) {
      // Handle errors during data fetching
      setState(() {
        _errorMessage = 'Error fetching data: $e'; 
        _isLoading = false;
      });
    }
}

// ... (Rest of the DashboardScreen class: UI, filters, etc.)
}

Sources
info
pub.dev/documentation/ioc_container/latest/
github.com/ishvar99/fluteco
github.com/pshanmukha/http_request
github.com/LeeXiuNiang/FinalYearProject_MyKidsProgress
github.com/ASE-485-Job-Search-Team/ase485jobsearch-frontend
github.com/3rdUt/boride-rider
stackoverflow.com/questions/65762107/the-method-was-called-on-null-flutter-error


Absolutely! Here's a comprehensive README file for your Flutter PLC Data Viewer app, including installation, usage, and customization instructions:

# PLC Data Viewer

This Flutter application allows you to view and filter data from a CSV file that simulates data from a Programmable Logic Controller (PLC).

## Features

- **Login Screen:** Secure access to the dashboard using a username and password.
- **Dashboard:** 
    - Displays PLC data in a user-friendly list format.
    - Includes filters for Machine, Sensor, and Date to narrow down results.
    - Supports manual data refresh.
- **Error Handling:** Provides informative error messages for incorrect login credentials or issues loading data.
- **UI Enhancements:**  Modern design with rounded corners, card layouts, and color themes.

## Getting Started

### Prerequisites

- **Flutter SDK:** Ensure you have Flutter installed on your machine. You can follow the official installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
- **Android Studio (or VS Code):** Choose your preferred IDE for Flutter development.

### Installation


1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

2. **Create CSV File:**
   - Create a CSV file named `plc_data.csv` in the `assets` folder of your project.
   - Use the following format for your CSV data:
     ```
     dateTime,machine,sensor,counter,value
     2024-06-11 12:30:00,Machine A,Proximity Sensor 1,105,0.8
     2024-06-11 13:45:00,Machine B,Proximity Sensor 2,88,1.2
     2024-06-12 09:15:00,Machine A,Proximity Sensor 1,120,0.9
     2024-06-12 15:30:00,Machine C,Proximity Sensor 3,95,1.1
     ```

3. **Update Assets:**
   - Open your `pubspec.yaml` file and add the following under `flutter`:
     ```yaml
     assets:
       - assets/
     ```

4. **Run the App:**
   - Connect a device or start an emulator.
   - Run the app using the following command:
     ```bash
     flutter run
     ```

## Usage

1. **Login:** Enter the default credentials (username: `admin`, password: `password`) or replace them with your actual login logic.
2. **Dashboard:** The dashboard will display the PLC data from your CSV file.
3. **Filtering:** Use the dropdown menus to filter the data by machine, sensor, and date.
4. **Refresh Data:** Tap the refresh icon in the app bar to reload data from the CSV file.


## Customization

- **Authentication:**  Replace the placeholder authentication logic with your actual authentication mechanism.
- **Data Source:**  For a real application, fetch data from your actual PLC or API endpoint instead of the CSV file.
- **UI Design:** Customize the colors, fonts, and overall layout to match your preferences and branding.
- **Additional Features:** You can add features like data visualization using charts or graphs, real-time data updates, and more.



*/



Here's a comprehensive README file for your Flutter PLC Data Viewer app, including installation, usage, and customization instructions:

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

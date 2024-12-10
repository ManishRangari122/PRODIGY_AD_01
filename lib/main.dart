import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class CalculationHistory extends ChangeNotifier {
  List<String> _history = [];

  List<String> get history => _history;

  void addCalculation(String calculation) {
    _history.add(calculation);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculationHistory(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CalculatorScreen(),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _input = "";
      _output = "0";
      _num1 = 0;
      _num2 = 0;
      _operation = "";
    }
    else if (buttonText == "⌫") {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
        if (_input.isEmpty) {
          _output = "0";
        } else {
          _output = _input;
        }
      }
    }else if (buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/") {
      _num1 = double.parse(_input);
      _operation = buttonText;
      _input = "";
    } else if (buttonText == ".") {
      if (_input.contains(".")) {
        return;
      } else {
        _input += buttonText;
      }
    } else if (buttonText == "=") {
      _num2 = double.parse(_input);

      switch (_operation) {
        case "+":
          _output = (_num1 + _num2).toString();
          break;
        case "-":
          _output = (_num1 - _num2).toString();
          break;
        case "*":
          _output = (_num1 * _num2).toString();
          break;
        case "/":
          _output = (_num1 / _num2).toString();
          break;
      }

      Provider.of<CalculationHistory>(context, listen: false)
          .addCalculation('$_num1 $_operation $_num2 = $_output');

      _num1 = 0;
      _num2 = 0;
      _operation = "";
      _input = _output;
    } else {
      _input += buttonText;
      _output = _input;
    }

    setState(() {});
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20.0),
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24.0),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.white],
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0, color: Colors.white),
              ),
            ),
            Expanded(
              child: Divider(),
            ),
            Column(children: [
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("/"),
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("*"),
              ]),
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-"),
              ]),
              Row(children: [
                _buildButton("."),
                _buildButton("0"),
                _buildButton("00"),
                _buildButton("+"),
              ]),
              Row(children: [
                _buildButton("C"),
                _buildButton("⌫"),
                _buildButton("="),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Consumer<CalculationHistory>(
        builder: (context, history, child) {
          return ListView.builder(
            itemCount: history.history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  history.history[index],
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}

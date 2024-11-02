import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.greenAccent),
        ),
      ),
      home: const ScientificCalculatorApp(),
    );
  }
}

class ScientificCalculatorApp extends StatelessWidget {
  const ScientificCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalculatorScreen();
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = "";
  String _result = "0";
  
  var log10;

  void _evaluateExpression() {
    try {
      final double res = _calculateExpression(_expression);
      setState(() {
        _result = res.toString(); 
      });
    } catch (e) {
      setState(() {
        _result = "Invalid Expression";
      });
    }
  }

  double _calculateExpression(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('^', '**');
    final expressionParser = Expression.parse(expression);
    final evaluator = const ExpressionEvaluator();

    final context = {
      'sin': (num x) => sin(x * pi / 180),
      'cos': (num x) => cos(x * pi / 180),
      'tan': (num x) => tan(x * pi / 180),
      'sqrt': sqrt,
      'log': log10,
      'ln': log,
      'pi': pi,
      'e': e,
    };

    return evaluator.eval(expressionParser, context) as double;
  }

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = "";
        _result = "0";
      } else if (buttonText == '=') {
        _evaluateExpression();
      } else {
        _expression += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scientific Calculator',
          style: TextStyle(color: Colors.greenAccent),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _expression,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _result,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(10),
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('÷'),
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('×'),
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-'),
                _buildButton('0'),
                _buildButton('.'),
                _buildButton('='),
                _buildButton('+'),
                _buildButton('C'),
                _buildButton('sin'),
                _buildButton('cos'),
                _buildButton('tan'),
                _buildButton('√'),
                _buildButton('^'),
                _buildButton('log'),
                _buildButton('ln'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return GestureDetector(
      onTap: () => _onPressed(buttonText),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.greenAccent, width: 1),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


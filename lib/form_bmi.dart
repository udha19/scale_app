import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scale_app/form.dart';
import 'package:scale_app/profile.dart';

class FormBmiPage extends StatefulWidget {
  const FormBmiPage({super.key, required this.user});

  final User user;
  @override
  State<FormBmiPage> createState() => _FormBmiPageState();
}

class _FormBmiPageState extends State<FormBmiPage> {
  final Data data = Data(
    weight: 0,
    height: 0,
    bodyFat: 0,
    muscleMass: 0,
    visceralFat: 0,
    basal: 0,
  );

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _bodyFatController = TextEditingController();
  TextEditingController _muscleMassController = TextEditingController();
  TextEditingController _visceralFatController = TextEditingController();
  TextEditingController _basalController = TextEditingController();
  late FocusNode weightFocusNode;
  late FocusNode heightFocusNode;

  void _nextStep() {
    if (double.parse(_heightController.text) == 0 ||
        double.parse(_weightController.text) == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter weight and height'),
      ));
      if (double.parse(_heightController.text) == 0) {
        heightFocusNode.requestFocus();
      }
      if (double.parse(_weightController.text) == 0) {
        weightFocusNode.requestFocus();
      }
    } else {
      data.weight = double.parse(_weightController.text);
      data.height = double.parse(_heightController.text);
      data.bodyFat = double.parse(_bodyFatController.text);
      data.muscleMass = double.parse(_muscleMassController.text);
      data.visceralFat = double.parse(_visceralFatController.text);
      data.basal = double.parse(_basalController.text);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(data: data, user: widget.user)));
    }
  }

  @override
  void initState() {
    _weightController = TextEditingController(text: 0.toString());
    _heightController = TextEditingController(text: 0.toString());
    _bodyFatController = TextEditingController(text: 0.toString());
    _muscleMassController = TextEditingController(text: 0.toString());
    _visceralFatController = TextEditingController(text: 0.toString());
    _basalController = TextEditingController(text: 0.toString());

    weightFocusNode = FocusNode();
    heightFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Scale App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Enter Your weight',
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _weightController,
              focusNode: weightFocusNode,
              decoration: const InputDecoration(
                hintText: 'Enter Your weight',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{1,3}(\.\d{0,1})?')),
              ],
            ),
          ),
          const Text('Enter Your height'),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _heightController,
              focusNode: heightFocusNode,
              decoration: const InputDecoration(
                hintText: 'Enter Your height',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{1,3}(\.\d{0,1})?')),
              ],
            ),
          ),
          const Text('Enter Your Body Fat'),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _bodyFatController,
              decoration: const InputDecoration(
                hintText: 'Enter Your Body Fat',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{1,2}(\.\d{0,1})?')),
              ],
            ),
          ),
          const Text('Enter Your Muscle Mass'),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _muscleMassController,
              decoration: const InputDecoration(
                hintText: 'Enter Your Muscle Mass',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{1,2}(\.\d{0,1})?')),
              ],
            ),
          ),
          const Text('Enter Your Visceral Fat'),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _visceralFatController,
              decoration: const InputDecoration(
                hintText: 'Enter Your  Visceral Fat',
              ),
              onChanged: (text) {
                if (int.parse(text) > 12) {
                  // show popup here.
                  _visceralFatController.text = 12.toString();
                  _visceralFatController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _visceralFatController.text.length));
                }
              },
            ),
          ),
          const Text('Enter Your Basal Metabolism'),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _basalController,
              decoration: const InputDecoration(
                hintText: 'Enter Your  Basal Metabolism',
              ),
              maxLength: 4,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(4)
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              _nextStep();
            },
            child: Text('Finish', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class Data {
  Data({
    this.weight,
    this.height,
    this.bodyFat,
    this.muscleMass,
    this.visceralFat,
    this.basal,
  });

  double? weight;
  double? height;
  double? bodyFat;
  double? muscleMass;
  double? visceralFat;
  double? basal;
}

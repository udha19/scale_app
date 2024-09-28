import 'package:flutter/material.dart';
import 'package:scale_app/form_bmi.dart';

enum gender { Male, Female }

class FormPage extends StatefulWidget {
  const FormPage({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> with RestorationMixin {
  final User user = User(
    name: "",
    gender: "",
    birthdate: "",
  );
  late FocusNode nameFocusNode;

  @override
  String? get restorationId => widget.restorationId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  gender? _gender = gender.Male;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1920),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
      _birthdateController.text =
          '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
    }
  }

  void _nexStep() {
    if (_nameController.text == '' || _birthdateController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter name and birthdate'),
      ));
      if (_nameController.text == '') {
        nameFocusNode.requestFocus();
      }
      return;
    } else {
      user.name = _nameController.text;
      user.birthdate = _birthdateController.text;

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FormBmiPage(user: user)));
    }
  }

  @override
  void initState() {
    super.initState();

    nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameFocusNode.dispose();

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
            'Tell me Your name',
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _nameController,
              focusNode: nameFocusNode,
              decoration: const InputDecoration(
                hintText: 'Enter Your name',
              ),
            ),
          ),
          const Text('Are You'),
          ListTile(
            title: const Text('Male'),
            leading: Radio<gender>(
              value: gender.Male,
              groupValue: _gender,
              onChanged: (gender? value) {
                setState(() {
                  _gender = value;
                  user.gender = value.toString();
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Female'),
            leading: Radio<gender>(
              value: gender.Female,
              groupValue: _gender,
              onChanged: (gender? value) {
                setState(() {
                  _gender = value;
                  user.gender = value.toString();
                });
              },
            ),
          ),
          const Text('What is Your Birthdate'),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              readOnly: true,
              controller: _birthdateController,
              decoration: const InputDecoration(
                hintText: 'Enter Your Birthdate',
              ),
              onTap: () {
                _restorableDatePickerRouteFuture.present();
              },
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              _nexStep();
            },
            child: Text('Continue', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class User {
  User({
    this.name,
    this.gender,
    this.birthdate,
  });

  String? name;
  String? birthdate;
  String? gender;
}

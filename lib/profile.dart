import 'package:flutter/material.dart';
import 'package:scale_app/form.dart';
import 'package:scale_app/form_bmi.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.data, required this.user});
  final Data data;
  final User user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double bmi = 0;
  String category = 'Invalid';

  @override
  void initState() {
    calculateBmi();
    super.initState();
  }

  void calculateBmi() {
    double heigtMtr = widget.data.height! / 100;
    double bmi = widget.data.weight! / (heigtMtr * heigtMtr);
    setState(() {
      this.bmi = double.parse(bmi.toStringAsFixed(2));
    });
    defineCategory();
  }

  void defineCategory() {
    if (bmi < 18.5) {
      setState(() {
        category = 'Underweight';
      });
    } else if (bmi >= 18.5 && bmi <= 22.9) {
      setState(() {
        category = 'Normal';
      });
    } else if (bmi >= 23 && bmi < 25) {
      setState(() {
        category = 'Overweight';
      });
    } else if (bmi >= 25) {
      setState(() {
        category = 'Obesity';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Your result:'),
              Padding(
                padding: EdgeInsets.all(20),
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Information',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Value',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Name')),
                        DataCell(Text('${widget.user.name}')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('BMI')),
                        DataCell(Text('${bmi.toString()}')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Category')),
                        DataCell(Text('$category')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Weight')),
                        DataCell(Text('${widget.data.weight} Kg')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Height')),
                        DataCell(Text('${widget.data.height} Cm')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Body Fat')),
                        DataCell(Text('${widget.data.bodyFat} %')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Muscle Mass')),
                        DataCell(Text('${widget.data.muscleMass} Kg')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Basal Metabolism')),
                        DataCell(Text('${widget.data.basal} Kcal')),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FormPage()));
                },
                child:
                    Text('Recalculate', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ));
  }
}

import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import 'package:http/http.dart' as http;
import 'package:strong_tower_app/screens/registerParts/register02.dart';

class RegisterScreen01 extends StatefulWidget {
  RegisterScreen01({
    super.key,
  });

  @override
  State<RegisterScreen01> createState() => _RegisterScreen01State();
}

class _RegisterScreen01State extends State<RegisterScreen01> {
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();
  var weightController = TextEditingController();
  var heightController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final edgePadding = 12.0;

  // Variable for gender dropdown
  List<String> _gender = [
    'Male',
    'Female',
  ];

  late String _selectedGender;

  // Code for selecting user location using API
  @override
  void initState() {
    super.initState();
    ProvincesApi();
  }

  String? selectedprovincescode;

  final sourceApi = 'psgc.gitlab.io';
  Map<String, String> provinces = {};
  Map<String, String> cities = {};
  bool isCitiesLoaded = false;
  Map<String, String> barangay = {};
  bool isBarangayLoaded = false;

  late String selectedProvince, selectedCities, selectedBarangay;
  var provinceController = TextEditingController();
  var citiesController = TextEditingController();
  var barangayController = TextEditingController();

  Future<void> ProvincesApi() async {
    var url = Uri.https(sourceApi, 'api/island-groups/luzon/provinces/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      json.forEach((element) {
        provinces.addAll({
          element['code']: element['name'],
        });
      });
    }
    setState(() {});
  }

  Future<void> CitiesApi(String provinceCode) async {
    var url = Uri.https(
        sourceApi, 'api/provinces/$provinceCode/cities-municipalities/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      cities.clear();
      List json = jsonDecode(response.body);
      json.forEach((element) {
        cities.addAll({
          element['code']: element['name'],
        });
      });
      setState(() {
        citiesController.clear();
        isCitiesLoaded = true;
        barangayController.clear();
      });
    }
  }

  Future<void> BarangayApi(String barangayCode) async {
    var url = Uri.https(
        sourceApi, 'api/cities-municipalities/$barangayCode/barangays/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      barangay.clear();
      List json = jsonDecode(response.body);
      json.forEach((element) {
        barangay.addAll({
          element['code']: element['name'],
        });
      });
      setState(() {
        isBarangayLoaded = true;
        barangayController.clear();
      });
    }
  }

  // End code for selecting user location using API
  final List<double> _heights =
      List.generate(200, (index) => (index + 100).toDouble());
  final List<double> _weights =
      List.generate(150, (index) => (index + 50).toDouble());

  late double _selectedHeight;
  late double _selectedWeight;

  // Going to next registration
  void nextRegister(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _selectedHeight = double.parse(heightController.text);
    _selectedWeight = double.parse(weightController.text);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RegisterScreen02(
          name: nameController.text,
          age: int.parse(ageController.text),
          gender: _selectedGender,
          weight: _selectedWeight,
          height: _selectedHeight,
          province: selectedProvince,
          cities: selectedCities,
          barangay: selectedBarangay,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - edgePadding * 2;
    final screenWidth2 = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        shadowColor: Colors.black,
        elevation: 5,
      ),
      body: Stack(
        // alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/pic8.jpg',
            fit: BoxFit.cover,
            height: screenHeight,
            width: screenWidth2,
          ),
          Container(
            height: screenHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Material(
              elevation: 5,
              color: Color.fromARGB(45, 0, 0, 0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 50, // Adjust as needed
                              height: 12, // Adjust as needed
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(
                                    8), // Add border radius
                              ),
                            ),
                            SizedBox(
                                width: 8), // Add some space between containers
                            Container(
                              width: 50, // Adjust as needed
                              height: 6, // Adjust as needed
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 211, 211, 211),
                                borderRadius: BorderRadius.circular(
                                    8), // Add border radius
                              ),
                            ),
                            SizedBox(
                                width: 8), // Add some space between containers
                            Container(
                              width: 50, // Adjust as needed
                              height: 6, // Adjust as needed
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 211, 211, 211),
                                borderRadius: BorderRadius.circular(
                                    8), // Add border radius
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Personal Information',
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        Gap(15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Fill this up. Name is required.';
                            }
                            return null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        Gap(15),
                        DropdownMenu(
                          controller: provinceController,
                          label: const Text(
                            'Provinces',
                            style: TextStyle(color: Colors.white),
                          ),
                          width: screenWidth,
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                          dropdownMenuEntries: provinces.entries.map((item) {
                            return DropdownMenuEntry(
                              value: item.key,
                              label: item.value,
                            );
                          }).toList(),
                          onSelected: (value) {
                            CitiesApi(value!);
                            selectedProvince = provinceController.text;
                          },
                        ),
                        Gap(15),
                        DropdownMenu(
                          controller: citiesController,
                          enabled: isCitiesLoaded,
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Cities',
                            style: TextStyle(color: Colors.white),
                          ),
                          width: screenWidth,
                          dropdownMenuEntries: cities.entries.map((item) {
                            return DropdownMenuEntry(
                              value: item.key,
                              label: item.value,
                            );
                          }).toList(),
                          onSelected: (value) {
                            BarangayApi(value!);
                            selectedCities = citiesController.text;
                          },
                        ),
                        Gap(15),
                        DropdownMenu(
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                          controller: barangayController,
                          enabled: isBarangayLoaded,
                          label: const Text(
                            'Barangay',
                            style: TextStyle(color: Colors.white),
                          ),
                          width: screenWidth,
                          dropdownMenuEntries: barangay.entries.map((item) {
                            return DropdownMenuEntry(
                              value: item.key,
                              label: item.value,
                            );
                          }).toList(),
                          onSelected: (value) {
                            selectedBarangay = barangayController.text;
                          },
                        ),
                        Gap(15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Fill this up. Age is required.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: ageController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        Gap(15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Fill this up. Height is required.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: heightController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Height(cm)',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        Gap(15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Fill this up. Weight is required.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: weightController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Weight(kg)',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        Gap(15),
                        Card(
                          elevation: 5,
                          child: CustomDropdown(
                            decoration: CustomDropdownDecoration(
                                listItemStyle: TextStyle()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select your Gender';
                              }
                              return null;
                            },
                            hintText: 'Gender',
                            items: _gender,
                            onChanged: (value) {
                              _selectedGender = value.toString();
                            },
                          ),
                        ),
                        Gap(15),
                        ElevatedButton(
                          onPressed: () {
                            nextRegister(context);
                          },
                          child: const Text('Next'),
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strong_tower_app/screens/user/calo_track.dart/add_food.dart';

class SearchFoodScreen extends StatefulWidget {
  SearchFoodScreen({
    super.key,
    required this.myFunction,
  });

  final Future<void> Function() myFunction;

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  String _searchQuery = '';
  List<DocumentSnapshot> _searchResults = [];
  List<String> foodsItem = [];

  TextEditingController _searchController = TextEditingController();

  Future<QuerySnapshot<Map<String, dynamic>>> searchRecord(String query) {
    return FirebaseFirestore.instance
        .collection('foods')
        .where('', isEqualTo: query)
        .get();
  }

  void _search() async {
    final results = await searchRecord(_searchQuery);
    setState(() {
      _searchResults = results.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    getCollections();
  }

  Future<void> getCollections() async {
    try {
      QuerySnapshot<Map<String, dynamic>> collectionSnapshot =
          await FirebaseFirestore.instance.collection('foods').get();

      // Loop through the documents in the collection
      collectionSnapshot.docs.forEach((DocumentSnapshot doc) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      });
    } catch (e) {
      print("Error getting collections: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(247, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Search Food',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        shadowColor: Colors.black,
        elevation: 5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('foods').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    var filteredDocs = snapshot.data!.docs.where((doc) {
                      return doc
                          .data()['foodName']
                          .toString()
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return Center(child: Text('No results found'));
                    }

                    return ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final data = filteredDocs[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: () {
                                double protein =
                                    double.parse(data['Protein'].toString());

                                double carbo = double.parse(
                                    data['Carbohydrates'].toString());
                                double fat =
                                    double.parse(data['Fat'].toString());

                                double calories =
                                    double.parse(data['Calories'].toString());

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddCalorieScreen(
                                    foodId: data['foodName'],
                                    protein: protein,
                                    carbohydrates: carbo,
                                    fat: fat,
                                    calories: calories,
                                    serSize: data['serSize'],
                                    myFunction: widget.myFunction,
                                  ),
                                ));
                              },
                              title: Text('${data.id}'),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

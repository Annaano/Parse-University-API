import 'package:flutter/material.dart';

import 'list_data_model.dart';
import 'university_list_from_api.dart';

void main() {
  runApp(const MaterialApp(
    home: CountryList(),
  ));
}

class CountryList extends StatefulWidget {
  const CountryList({super.key});
  @override
  State<CountryList> createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  static List<String> countryNamesList = [
    'Georgia',
    'United States',
    'Germany',
    'France',
    'Italy'
  ];

  static List<String> flagsURL = [
    'https://flagsworld.org/img/cflags/georgia-flag.png',
    'https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/1280px-Flag_of_the_United_States.svg.png',
    'https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Flag_of_Germany.svg/1200px-Flag_of_Germany.svg.png',
    'https://upload.wikimedia.org/wikipedia/en/thumb/c/c3/Flag_of_France.svg/1920px-Flag_of_France.svg.png',
    'https://upload.wikimedia.org/wikipedia/en/thumb/0/03/Flag_of_Italy.svg/1200px-Flag_of_Italy.svg.png'
  ];

  final List<ListDataModel> countryListData = List.generate(
      countryNamesList.length,
      (index) => ListDataModel(countryNamesList[index], flagsURL[index]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COUNTRIES'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: countryListData.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: Image.network(countryListData[index].imageUrl),
              ),
              title: Column(children: [
                Text(
                  countryListData[index].names,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UniversityListFromAPI(
                          countryName: countryNamesList[index],
                          dataList: countryListData,
                        )));
              },
            ),
          );
        },
      ),
    );
  }
}

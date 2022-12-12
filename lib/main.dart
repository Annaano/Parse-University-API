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
    'Italy',
    'United Kingdom',
    'Australia',
    'Ukraine',
    'Netherlands',
    'Canada'
  ];

  static List<String> flagsURL = [
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-Georgia.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-United-States-of-America.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-Germany.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-France.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-Italy.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-United-Kingdom.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-Australia.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-Ukraine.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-Netherlands.png',
    'https://www.countries-ofthe-world.com/flags-normal/flag-of-Canada.png'
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
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: countryListData.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 15.0),
                leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: FadeInImage.assetNetwork(
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('lib/assets/study.png');
                      },
                      placeholder: 'lib/assets/study.png',
                      image: countryListData[index].imageUrl,
                    )),
                title: Column(children: [
                  Text(
                    countryListData[index].names.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ]),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.blueAccent, size: 20.0),
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
        ));
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'list_data_model.dart';

class UniversityListFromAPI extends StatefulWidget {
  final List<ListDataModel> dataList;
  final String countryName;
  const UniversityListFromAPI(
      {Key? key, required this.countryName, required this.dataList})
      : super(key: key);

  @override
  State<UniversityListFromAPI> createState() => _UniversityListFromAPIState();
}

class _UniversityListFromAPIState extends State<UniversityListFromAPI> {
  bool isLoading = true;
  bool internetConnection = false;
  List universities = [];

  @override
  void initState() {
    super.initState();
    fetchUniversities().whenComplete(() {
      if (!internetConnection) showDialogBox();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  fetchUniversities() async {
    try {
      var serverURL = "http://universities.hipolabs.com/search";
      var token = widget.countryName;
      var url = '$serverURL?country=$token';
      var response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var items = json.decode(response.body);
        internetConnection = true;
        setState(() {
          universities = items;
          isLoading = false;
          internetConnection = true;
        });
      } else {
        setState(() {
          universities = [];
          isLoading = false;
        });
      }
    } on SocketException {
      setState(() {
        internetConnection = false;
        isLoading = false;
      });
    }
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content:
              const Text('Turn on celluar data or use Wi-Fi to access data.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const CountryList(),
                //   ),
                // );
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UNIVERSITIES OF ${widget.countryName.toUpperCase()}',
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ),
      body: getBody(),
    );
  }

  Widget? getBody() {
    if (internetConnection == false && !isLoading) {
      return null;
    } else {
      if (universities.contains(null) || isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
    }
    return ListView.builder(
        itemCount: universities.length,
        itemBuilder: (context, index) {
          return getUniversitiesListPage(universities[index]);
        });
  }

  Widget getUniversitiesListPage(index) {
    var uniName = index['name'];
    var uniCountry = index['country'];
    var webPage = index['web_pages'][0];
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(uniName.toString(),
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: (Text(uniCountry.toString(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.left)),
                  ),
                  TextButton(
                    onPressed: () async {
                      var url = webPage;
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Text(
                      'READ MORE ',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )));
  }
}

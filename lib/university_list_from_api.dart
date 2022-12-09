import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      var response = await http.get(Uri.parse(url));
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
        builder: (BuildContext context) => const CupertinoAlertDialog(
          title: Text('No internet connection'),
          content: Text('Please check your internet connection and try again'),
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
      //loadingFinished
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
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
                title: Row(children: <Widget>[
              const SizedBox(
                width: 20,
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(uniName.toString(),
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.left),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(uniCountry.toString(),
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                      textAlign: TextAlign.left)
                ],
              )),
            ]))));
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/topic_repository.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddTopicScreen extends StatefulWidget {
  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  final TextEditingController _lyricController = TextEditingController();
  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _singerNameController = TextEditingController();
  final TextEditingController _linkSongController = TextEditingController();
  final TextEditingController _linkSongController1 = TextEditingController();

  String _tone;
  String _beat;
  String _genre;
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  void _doPost(RoundedLoadingButtonController controller) async {
    if (_lyricController.text.isEmpty ||
        _tone == null ||
        _songNameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bạn cần nhập đủ các thông tin cần thiết'),
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ],
            ),
            backgroundColor: Colors.grey,
          ),
        );
      controller.error();
    } else if (await addTopic()) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thêm đề tài thành công'),
                const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ],
            ),
            backgroundColor: Colors.grey,
          ),
        );
      controller.success();
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lỗi! Thử lại sau...'),
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ],
            ),
            backgroundColor: Colors.grey,
          ),
        );
      controller.error();
    }
  }

  Future<bool> addTopic() async {
    
     return await TopicRepository().createTopic(
      Topic(
        topicCode: _singerNameController.text,
        name: _songNameController.text,
        field: _tone,
        type: _beat,
        image: _linkSongController.text,
        budget: int.parse(_linkSongController1.text),
        content: _lyricController.text,
        dateCreated: DateTime.now().toString(),
        acceptanceTime:
            "${DateTime(DateTime.now().year, DateTime.now().month + 7, DateTime.now().day).toString()}",
        note: "",
      ),
    );
  }

  final scaffoldKey = GlobalKey();

  @override
  void dispose() {
    _lyricController.dispose();
    _singerNameController.dispose();
    _songNameController.dispose();
    _linkSongController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Thêm đề tài",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputTopicName(),
              buildInputIdTopic(),
              buildSelectedField(context),
              buildSelectedType(context),
              //buildSelectedGenre(context),
              buildInputLinkImage(),
              buildInputBudget(),
              buildInputContent(),
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedLoadingButton(
        errorColor: Colors.redAccent,
        successColor: Colors.greenAccent,
        child: const Text('Đăng bài'),
        controller: _btnController1,
        onPressed: () => _doPost(_btnController1),
      ),
    );
  }

  Row buildSelectedField(BuildContext context) {
    List<String> tones = [
      "CNTT",
      "QTKD",
      "ATTT",
      "KT",
      "ĐT",
      "VT",
      "MR",
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Lĩnh vực:",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width * .5,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[500],
                    offset: const Offset(4, 4),
                    blurRadius: 15.0,
                    spreadRadius: 1),
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 15.0,
                    spreadRadius: 1),
              ],
            ),
            child: DropdownButton<String>(
                autofocus: true,
                isDense: true,

                // alignment: Alignment.center,
                isExpanded: true,
                value: _tone,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 30,
                underline: const SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    _tone = newValue;
                    _btnController1.reset();
                  });
                },
                items: tones.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    // alignment: Alignment.center,
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }

  Row buildSelectedType(BuildContext context) {
    List<String> beats = [
      "CB",
      "NC",
      "TB",
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Trình độ",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width * .5,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[500],
                    offset: const Offset(4, 4),
                    blurRadius: 15.0,
                    spreadRadius: 1),
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 15.0,
                    spreadRadius: 1),
              ],
            ),
            child: DropdownButton<String>(
                autofocus: true,
                isDense: true,
                isExpanded: true,
                value: _beat,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 30,
                underline: const SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    _beat = newValue;
                    _btnController1.reset();
                  });
                },
                items: beats.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }

  Row buildSelectedGenre(BuildContext context) {
    List<String> genres = [
      "Nhạc Trẻ",
      "US-UK",
      "Tình yêu",
      "Nhạc Vàng",
      "Indie",
      "Pop",
      "Rap",
      "Bolero",
      "Chill",
      "Nhạc Trữ Tình",
      "Nhạc Hàn"
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Thể loại",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width * .5,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[500],
                    offset: const Offset(4, 4),
                    blurRadius: 15.0,
                    spreadRadius: 1),
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 15.0,
                    spreadRadius: 1),
              ],
            ),
            child: DropdownButton<String>(
                autofocus: true,
                isDense: true,
                isExpanded: true,
                value: _genre,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 30,
                underline: const SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    _genre = newValue;
                    _btnController1.reset();
                  });
                },
                items: genres.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }

  Padding buildInputIdTopic() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                offset: const Offset(4, 4),
                blurRadius: 15.0,
                spreadRadius: 1),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15.0,
                spreadRadius: 1),
          ],
        ),
        child: TextField(
          onChanged: (_) {
            _btnController1.reset();
          },
          autofocus: true,
          controller: _singerNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: "Nhập mã đề tài",
          ),
        ),
      ),
    );
  }

  Padding buildInputTopicName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                offset: const Offset(4, 4),
                blurRadius: 15.0,
                spreadRadius: 1),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15.0,
                spreadRadius: 1),
          ],
        ),
        child: TextField(
          onChanged: (_) {
            _btnController1.reset();
          },
          autofocus: true,
          controller: _songNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: "Nhập tên đề tài",
          ),
        ),
      ),
    );
  }

  Padding buildInputLinkImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                offset: const Offset(4, 4),
                blurRadius: 15.0,
                spreadRadius: 1),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15.0,
                spreadRadius: 1),
          ],
        ),
        child: TextField(
          onChanged: (_) {
            _btnController1.reset();
          },
          autofocus: true,
          controller: _linkSongController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: "Nhập link ảnh",
          ),
        ),
      ),
    );
  }

  Padding buildInputBudget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                offset: const Offset(4, 4),
                blurRadius: 15.0,
                spreadRadius: 1),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15.0,
                spreadRadius: 1),
          ],
        ),
        child: TextField(
          onChanged: (_) {
            _btnController1.reset();
          },
          keyboardType: TextInputType.number,
          autofocus: true,
          controller: _linkSongController1,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: "Nhập kinh phí",
          ),
        ),
      ),
    );
  }

  Padding buildInputContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                offset: const Offset(4, 4),
                blurRadius: 15.0,
                spreadRadius: 1),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15.0,
                spreadRadius: 1),
          ],
        ),
        child: TextField(
          onChanged: (_) {
            _btnController1.reset();
          },
          autofocus: true,
          controller: _lyricController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: "Nhập nội dung đề tài",
          ),
          maxLines: 10,
        ),
      ),
    );
  }
}

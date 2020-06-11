import 'dart:io';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_kanye/network_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vibrate/vibrate.dart';

class HomeScreen extends StatefulWidget {
  double sliderValue = 24;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NetworkHelper helper;
  String quote = 'loading...';
  ScreenshotController screenshotController = ScreenshotController();
  File _imageFile;
  final snackBar = SnackBar(content: Text('Saved to gallery'));

  @override
  void initState() {
    super.initState();
    helper = NetworkHelper();
    _getQuote();
  }

  _getQuote() async {
    await helper.fetchAlbum().then((value) {
      setState(() {
        quote = value.quote;
      });
    });
  }

  void _newQuote() {
    helper.fetchAlbum().then((value) {
      setState(() {
        quote = value.quote;
      });
    });
  }

  void _saveImage() async {
    screenshotController.capture().then((File image) async {
      Vibrate.feedback(FeedbackType.medium);
      await Share.file('ESYS AMLOG', 'amlog.jpg', image.readAsBytesSync(), 'image/jpg');
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff333333),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.0,
                    color: Colors.white,
                  ),
                  Column(
                    children: [
                      Text(
                        'PLAYING FROM ALBUM',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'yeQuotes',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.more_vert,
                    size: 20.0,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onLongPress: () {
                _saveImage();
              },
              child: Screenshot(
                controller: screenshotController,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/album_background.png',
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: MediaQuery.of(context).size.width / 2,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: [
                                  Text(
                                    quote,
                                    style: GoogleFonts.shadowsIntoLight(
                                      color: Colors.greenAccent[400],
                                      fontSize: widget.sliderValue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _newQuote();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _newQuote();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _newQuote();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                thumbColor: Colors.black,
                activeTrackColor: Colors.red,
                inactiveTrackColor: Colors.grey,
              ),
              child: Slider(
                value: widget.sliderValue,
                min: 16,
                max: 42,
                onChanged: (double newVal) {
                  setState(() {
                    widget.sliderValue = newVal;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

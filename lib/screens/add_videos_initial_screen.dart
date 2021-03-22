import 'package:flutter/material.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/screens/add_videos_screen.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:youtube1/widget/appDrawer.dart';

class AddVideosInitialScreen extends StatefulWidget{
  @override
  _AddVideosInitialStateScreen createState() => _AddVideosInitialStateScreen();
}

class _AddVideosInitialStateScreen extends State<AddVideosInitialScreen>{
  TextEditingController _videoYoutubeUrlController;
  ThemeData _theme;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _videoYoutubeUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _videoYoutubeUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(title: 'Add a new Video'),
      body: Form(
              key: _formKey,
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child:Column(
                  children: [
                    SizedBox(height: 12,),
                    Text(
                    'First paste the youtube video url that you want to add',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                    ),
                    SizedBox(height: 25,),
                    TextFormField(
                      controller: _videoYoutubeUrlController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _theme.colorScheme.primary, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _theme.colorScheme.secondary, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Enter the video url',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a video url';
                        }

                        String youtubeVideoUrl = value;
                        String youtubeVideoId = getIdFromUrl(youtubeVideoUrl);
                        if(youtubeVideoId == null){
                          return 'Please enter a valid video url';
                        }
                        return null;
                      },
                    ),
                    Center(
                      child: ElevatedButton(
                              child: Text('Continue'),
                              onPressed: () {

                                if (_formKey.currentState.validate()) {
                                  String youtubeVideoUrl = _videoYoutubeUrlController.text;
                                  String youtubeVideoId = getIdFromUrl(youtubeVideoUrl);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddVideosScreen(youtubeVideoId),
                                    ),
                                  );
                                }
                              }
                      ),
                    ),
                  ]
              )
            )
          )
    );
  }
}


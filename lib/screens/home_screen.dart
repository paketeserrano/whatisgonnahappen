import 'package:flutter/material.dart';
import 'package:youtube1/models/channel_model.dart';
import 'package:youtube1/screens/channel_screen.dart';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Channel> channels = List<Channel>();

  @override
  void initState() {
    super.initState();
    _initHome();
  }

  _initHome() async {
    channels = await APIService.instance
        .fetchChannel();

    setState(() {
      print('----------- In the set state function');
    });
  }

  _buildChannelInfo(channel) {
    Video video;
    return GestureDetector(
        onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChannelScreen(channel),
          ),
        ),
      child:Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 35.0,
                  backgroundImage: NetworkImage(channel.profilePictureUrl),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        channel.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${channel.subscriberCount} subscribers',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
      ],
      )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(title: 'Select a tournament',),
      body: ListView.builder(
          itemCount: channels.length,
          itemBuilder: (BuildContext context, int index) {
            print('index: $index');
            Channel channel = channels[index];
            return _buildChannelInfo(channel);
          },
        ),
      );
  }
}
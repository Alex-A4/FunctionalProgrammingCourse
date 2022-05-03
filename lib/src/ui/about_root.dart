import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutUsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Image(image: AssetImage('assets/logo.png'),),
          padding: EdgeInsets.only(left:10.0, top:5.0, bottom: 5.0),
        ),
        title: Text('О нас'),
      ),

      body: ListView(
        padding: EdgeInsets.only(top: 16.0),
        children: <Widget>[
          getTextPair('Время работы:', ' С 10:00 до 17:00 без обеда и выходных'),
          getTextPair('Наш адрес:', 'г. Ярославль, ул. Шевелюха, 137'),
          getTextPair('Наш телефон:', '8(4852)74-32-21'),

          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            child: Text(
              'Мы в социальных сетях:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius:   BorderRadius.circular(20.0),
                side: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Button to open VK
                  getIconButton('assets/vk.png', 'https://vk.com/zooyar'),

                  //Button to open Facebook
                  getIconButton('assets/facebook.png', 'https://www.facebook.com/yaroslavlzoo'),

                  //Button to open Instagram
                  getIconButton('assets/instagram.png', 'https://www.instagram.com/yaroslavlzoo/'),

                  //Button to open Youtube
                  getIconButton('assets/youtube.png', 'https://www.youtube.com/channel/UC_2z1FBwooyqMcUTYrzjyiw/about'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Uses to define image of social networks
  Widget getIconButton(String source, String url) {
    return IconButton(
      onPressed: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print ('Could not launch $url');
        }
      },
      iconSize: 50.0,
      icon: Image(
        image: AssetImage(source),
        color: Colors.green[700],
      ),
    );
  }

  Widget getTextPair(String title, String text) {
    return Container(
      padding: EdgeInsets.only(left: 16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Text for title
            Text(
              title,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.black
              ),
            ),

            SizedBox(
              height: 10,
            ),
            //Text for text
            Text(
              text,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
          ],
      )
    );
  }

}
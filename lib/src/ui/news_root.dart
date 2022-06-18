import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_mobile/src/bloc/app_bloc/app.dart';
import 'package:zoo_mobile/src/models/news/news.dart';
import 'package:zoo_mobile/src/widgets/downloading_widgets.dart';
import 'full_news_viewer.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AppBloc>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Image(
            image: AssetImage('assets/logo.png'),
          ),
          padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        ),
        title: Text('Новости'),
      ),
      body: StreamBuilder<List<News>>(
        stream: bloc.newsStore.stream,
        builder: (context, snapshot) {
          //If downloading finished
          if (snapshot.hasData) {
            return getListView(snapshot.data);
          } else if (snapshot.hasError) {
            // If error occurred
            showToast(snapshot.error.toString().replaceFirst('Exception: ', ''));

            return getUpdateScreen(() => bloc.newsStore.forceLoad(bloc.newsStore.basicUrl));
          }

          //Until downloading finishes, show progress bar
          return getProgressBar();
        },
      ),
    );
  }

  Widget getListView(List<News> news) {
    return ListView(
      key: PageStorageKey('NewsKey'),
      padding: EdgeInsets.only(top: 8.0),
      children: news.map((e) => _NewsListItem(e)).toList(),
    );
  }
}

/// Class describes news item from list
class _NewsListItem extends StatelessWidget {
  final News _news;

  _NewsListItem(this._news);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FullNewsScreen(_news.pageUrl)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text with title of news
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: Text(
              _news.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
          ),

          // Text with date
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              _news.postDate,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14.0, color: Colors.black45),
            ),
          ),

          //An image which placed into the center
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                  _news.imageUrl,
                  width: MediaQuery.of(context).size.width - 150,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          // A description of news
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Text(
              _news.description,
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(fontSize: 17.0, color: Colors.black45),
            ),
          ),

          Divider(color: Colors.black26),
        ],
      ),
    );
  }
}

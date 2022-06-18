import 'package:flutter/material.dart';
import 'package:zoo_mobile/src/content_providers/store_single.dart';
import 'package:zoo_mobile/src/models/news/full_news.dart';
import 'package:zoo_mobile/src/widgets/clickable_image.dart';
import 'package:zoo_mobile/src/widgets/downloading_widgets.dart';

class FullNewsScreen extends StatefulWidget {
  final String newsUrl;

  FullNewsScreen(this.newsUrl);

  @override
  State<FullNewsScreen> createState() => _FullNewsScreenState();
}

class _FullNewsScreenState extends State<FullNewsScreen> {
  StoreSingle<FullNews> store;

  @override
  void initState() {
    store = StoreSingle<FullNews>(basicUrl: widget.newsUrl);
    store.forceLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: store.stream,
        builder: (context, snapshot) {
          //If data downloaded
          if (snapshot.hasData) {
            return getListView(snapshot.data);
          } else if (snapshot.hasError) {
            //If error occurred
            print(snapshot.error);
            showToast('Проверьте интернет соединение');

            // Close news if there is no connectivity
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
          }

          //Default widget
          return getCircularProgress();
        },
      ),
    );
  }

  //Getting progress bar until downloading finish
  Widget getCircularProgress() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Соединение..'),
      ),
      body: Center(
        child: getProgressBar(),
      ),
    );
  }

  //Getting list view which contains content
  Widget getListView(FullNews news) {
    return Scaffold(
      body: CustomScrollView(
        key: PageStorageKey("FullNewsList"),
        slivers: <Widget>[
          //AppBar
          SliverAppBar(
            pinned: true,
            elevation: 3,
            title: Text(
              news.title,
            ),
            expandedHeight: 250,
            //HEADER IMAGE
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                news.headerImageUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          //Content
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                // TEXT OF NEWS
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    news.text,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                ),

                // CONTENT OF NEWS
                ClickableImages(
                  news.imageUrls,
                  pLeft: 32.0,
                  pRight: 32.0,
                  pTop: 16.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

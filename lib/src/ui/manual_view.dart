import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_mobile/src/bloc/app_bloc/app.dart';
import 'package:zoo_mobile/src/models/manual/manual_item.dart';
import 'package:zoo_mobile/src/widgets/downloading_widgets.dart';

import 'animals_category.dart';

/// Class describes main page of zoo manual
/// This page contains categories of animals

class ManualCategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppBloc>(context).manualStore;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Image(
            image: AssetImage('assets/logo.png'),
          ),
          padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        ),
        title: Text('Справочник'),
      ),
      body: StreamBuilder<List<ManualItem>>(
        stream: store.stream,
        builder: (context, snapshot) {
          //If downloading finished
          if (snapshot.hasData) {
            return getGridView(snapshot.data);
          } else if (snapshot.hasError) {
            // If error occurred
            showToast(snapshot.error.toString().replaceFirst('Exception: ', ''));

            return getUpdateScreen(() => store.forceLoad(store.basicUrl));
          }

          //Until downloading finishes, show progress bar
          return getProgressBar();
        },
      ),
    );
  }

  ///GridView with the items of manual
  Widget getGridView(List<ManualItem> items) {
    return GridView.builder(
      key: PageStorageKey('ManualKey'),
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int pos) {
        return ManualCategoryListItem(items[pos]);
      },
    );
  }
}

/// One item of list from manual
class ManualCategoryListItem extends StatelessWidget {
  final ManualItem item;

  ManualCategoryListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AnimalsCategoryWidget(item),
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        elevation: 5.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Image of manual
            Image.network(
              item.imageUrl,
              fit: BoxFit.fitWidth,
            ),

            //Description of manual
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

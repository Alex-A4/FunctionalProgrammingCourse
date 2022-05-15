import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_mobile/src/bloc/app_bloc/app.dart';
import 'package:zoo_mobile/src/models/manual/animals_category_data.dart';
import 'package:zoo_mobile/src/models/manual/manual_item.dart';
import 'package:zoo_mobile/src/widgets/downloading_widgets.dart';
import 'animals_viewer.dart';

/// Class to display list of animals by specified category
class DetailedCategoryAnimalScreen extends StatelessWidget {
  final ManualItem manualItem;

  DetailedCategoryAnimalScreen(this.manualItem);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppBloc>(context).categoryStore;
    store.tryToLoad(manualItem.pageUrl);

    return StreamBuilder<List<AnimalCategory>>(
      stream: store.stream,
      builder: (context, snapshot) {
        //If data downloaded
        if (snapshot.hasData) {
          //If count of animals more then 5, then show like grid else like list
          return Scaffold(
            appBar: AppBar(
              title: Text(manualItem.description),
            ),
            body: getGridView(snapshot.data),
          );
        } else if (snapshot.hasError) {
          //If error occurred
          showToast('Проверьте интернет соединение');

          // Close categories if there is no connectivity
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
          return Container();
        }

        //Default widget
        return getCircularProgress();
      },
    );
  }

  //Getting progress bar until downloading finish
  Widget getCircularProgress() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Соединение..'),
      ),
      body: getProgressBar(),
    );
  }

  //Getting grid view which contains content
  //If there is more then 5 entries then show like 2-column grid
  // else like 1-column grid
  Widget getGridView(List<AnimalCategory> animals) {
    return GridView.builder(
      key: PageStorageKey('AnimalsCategoryGridKey'),
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: animals.length,
      itemBuilder: (context, pos) {
        return _AnimalsCategoryItem(animals[pos]);
      },
    );
  }
}

//Widget contains image of category and title
class _AnimalsCategoryItem extends StatelessWidget {
  final AnimalCategory _category;

  _AnimalsCategoryItem(this._category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DetailedAnimalScreen(_category)),
        );
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(9.0),
              child: Image.network(
                _category.imageUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Text(
                _category.title,
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

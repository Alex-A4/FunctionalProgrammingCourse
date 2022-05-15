import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_mobile/src/ui/about_root.dart';
import 'package:zoo_mobile/src/ui/manual_view.dart';
import 'package:zoo_mobile/src/ui/news_root.dart';

import 'bloc/app_bloc/app.dart';

/// Class which is equivalent to Android's ViewPager
/// Contains interaction pages
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AppBloc>(context);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[700],
        accentColor: Colors.yellow[400],
      ),
      title: 'Ярославский зоопарк',
      home: Scaffold(
        body: StreamBuilder<AppBlocState>(
          stream: bloc.state,
          builder: (_, snap) {
            if (!snap.hasData) return Container();
            if (snap.data is NewsState) return NewsScreen();
            if (snap.data is AboutState) return AboutScreen();
            if (snap.data is ManualState) return ManualCategoryScreen();

            if (snap.hasError) print(snap.error);

            return Container();
          },
        ),
        bottomNavigationBar: CustomBottomBar(),
      ),
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AppBloc>(context);

    return StreamBuilder<AppBlocState>(
      stream: bloc.state,
      builder: (_, snap) {
        int currentIndex = 0;
        if (snap.data is AboutState) currentIndex = 1;
        if (snap.data is ManualState) currentIndex = 2;

        return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Новости',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'О нас',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.import_contacts),
              label: 'Справочник',
            ),
          ],
          fixedColor: Colors.green,
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == 0) bloc.dispatch(OpenNewsEvent());
            if (index == 1) bloc.dispatch(OpenAboutEvent());
            if (index == 2) bloc.dispatch(OpenManualEvent());
          },
        );
      },
    );
  }
}

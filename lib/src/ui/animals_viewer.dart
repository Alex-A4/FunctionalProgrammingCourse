import 'package:flutter/material.dart';
import 'package:zoo_mobile/src/content_providers/store_single.dart';
import 'package:zoo_mobile/src/models/manual/animals.dart';
import 'package:zoo_mobile/src/models/manual/animals_category_data.dart';
import 'package:zoo_mobile/src/widgets/downloading_widgets.dart';

class DetailedAnimalScreen extends StatefulWidget {
  final AnimalCategory category;

  DetailedAnimalScreen(this.category);

  @override
  _AnimalsViewerState createState() => _AnimalsViewerState();
}

class _AnimalsViewerState extends State<DetailedAnimalScreen> with TickerProviderStateMixin {
  TabController _controller;
  StoreSingle<Animal> store;

  @override
  void initState() {
    store = StoreSingle<Animal>(basicUrl: widget.category.pageUrl);
    store.forceLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: store.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controller = TabController(
              length: (snapshot.data as Animal).tabElements.length,
              vsync: this,
              initialIndex: 0,
            );

            return getListView(snapshot.data);
          } else if (snapshot.hasError) {
            print('${snapshot.error}');
            showToast('Проверьте интернет соединение');

            // Close news if there is no connectivity
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
            return Container();
          }

          return getProgressBar();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget getListView(Animal animal) {
    return CustomScrollView(
      key: PageStorageKey("AnimalList${widget.category.title}"),
      slivers: <Widget>[
        //AppBar
        SliverAppBar(
          pinned: true,
          elevation: 3,
          title: Text(
            widget.category.title,
          ),
          expandedHeight: 250,
          //HEADER IMAGE
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              widget.category.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),

        //Content
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              // TEXT OF ANIMAL
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  animal.description,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),

              // CONTENT OF ANIMAL
              SizedBox(
                height: 30,
              ),

              TabBar(
                unselectedLabelColor: Colors.green[400],
                labelColor: Colors.green[800],
                indicator: BoxDecoration(
                    border: Border.all(color: Colors.yellow[600], width: 2.0),
                    borderRadius: BorderRadius.circular(10.0)),
                controller: _controller,
                tabs: animal.tabElements.keys
                    .map((key) => new Tab(
                          child: Text(
                            key,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ))
                    .toList(),
                isScrollable: true,
              ),

              Divider(),

              //TabView which contains interesting facts about animal
              Container(
                height: 200,
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                child: TabBarView(
                  controller: _controller,
                  children: animal.tabElements.values
                      .map((value) =>
                          //Show dialog with full text by clicking on text
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          animal.tabElements.keys.toList()[_controller.index],
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                value,
                                                style:
                                                    TextStyle(fontSize: 17.0, color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'Супер!',
                                              style: TextStyle(fontSize: 17.0, color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    value,
                                    maxLines: 7,
                                    style: TextStyle(fontSize: 17.0, color: Colors.black),
                                    overflow: TextOverflow.clip,
                                  ),
                                  Text(
                                    'Читать далее...',
                                    style: TextStyle(color: Colors.grey[400], fontSize: 17.0),
                                  )
                                ],
                              )))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

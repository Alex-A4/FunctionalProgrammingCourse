import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_mobile/src/bloc/app_bloc/app.dart';

import 'src/app.dart';

void main() {
  final bloc = AppBloc();
  bloc.dispatch(InitAppEvent());

  runApp(
    Provider<AppBloc>(
      create: (_) => bloc,
      dispose: (_, b) => b.dispose(),
      child: App(),
    ),
  );
}

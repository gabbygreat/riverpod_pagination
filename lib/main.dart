import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_pagination/model.dart';
import 'package:riverpod_pagination/provider.dart';

import 'network.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Pagination',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final PaginationModel paginationModel = PaginationModel();
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    final airplaneList = ref.watch(
      airplaneListProvider(
        paginationModel,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Pagination using Riverpod'),
      ),
      body: airplaneList.when(
        data: (value) => SmartRefresher(
          reverse: true,
          controller: refreshController,
          enablePullUp: true,
          enablePullDown: false,
          onRefresh: () async {
            value.clear();
            paginationModel.page = 0;
            paginationModel.total = 100;
            var _ =
                await ref.refresh(airplaneListProvider(paginationModel).future);
            refreshController.refreshCompleted();
          },
          onLoading: () async {
            if (value.length != paginationModel.total) {
              try {
                final a = await getAirPlane(paginationModel);
                value.addAll(a);
                refreshController.loadComplete();
                setState(() {});
              } catch (_) {
                refreshController.refreshFailed();
              }
            } else {
              refreshController.loadNoData();
            }
          },
          child: ListView.builder(
            itemBuilder: (context, index) {
              final listOfAirPlane =
                  value.map((e) => AirPlaneModel.fromJson(e)).toList();
              return ListTile(
                title: Text('$index ${listOfAirPlane[index].name}'),
                subtitle: Text(listOfAirPlane[index].airlineModel.slogan),
                leading: CircleAvatar(
                  child: Image.network(
                    listOfAirPlane[index].airlineModel.logo,
                  ),
                ),
              );
            },
            itemCount: value.length,
          ),
        ),
        error: (error, trace) => const Text('ERROR'),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

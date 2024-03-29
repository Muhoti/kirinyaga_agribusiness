// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kirinyaga_agribusiness/Components/VCIncidentBar.dart';
import 'package:kirinyaga_agribusiness/Model/VCItem.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Components/Utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VCScrollController extends StatefulWidget {
  final String id;
  final storage = const FlutterSecureStorage();

  const VCScrollController({super.key, required this.id});

  @override
  _VCScrollControllerState createState() => _VCScrollControllerState();
}

class _VCScrollControllerState extends State<VCScrollController> {
  final _numberOfPostsPerRequest = 10;
  String vcid = '';
  String valuechain = '';
  dynamic isLoading;

  final PagingController<int, VCItem> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    isLoading = LoadingAnimationWidget.staggeredDotsWave(
      color: const Color.fromRGBO(0, 128, 0, 1),
      size: 100,
    );

    try {
      final dynamic response;

      response = await get(
        Uri.parse("${getUrl()}farmerdetails/valuechains/${widget.id}"),
      );

      List responseList = json.decode(response.body);

      if (responseList.isNotEmpty) {
        setState(() {
          vcid = responseList[0]["ID"];
          valuechain = responseList[0]["ValueChainName"];
        });
      }

      List<VCItem> postList = responseList.map((data) => VCItem(data)).toList();

      final isLastPage = postList.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(postList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(postList, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, VCItem>(
          shrinkWrap: true,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<VCItem>(
            itemBuilder: (context, item, index) => Padding(
              padding: const EdgeInsets.all(0),
              child: VCIncidentBar(
                  item: item,
                  id: widget.id,
                  vcid: vcid,
                  valuechain: valuechain),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

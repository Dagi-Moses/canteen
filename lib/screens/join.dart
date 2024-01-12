// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:canteen/screens/login.dart';
import 'package:canteen/screens/register.dart';

class JoinApp extends StatefulWidget {
  final bool canPop;
  const JoinApp({
    Key? key,
    required this.canPop,
  }) : super(key: key);
  @override
  _JoinAppState createState() => _JoinAppState();
}

class _JoinAppState extends State<JoinApp> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: widget.canPop
            ? IconButton(
                icon: Icon(
                  Icons.keyboard_backspace,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : SizedBox(),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
          tabs: <Widget>[
            Tab(
              text: app.login,
            ),
            Tab(
              text: app.register,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          LoginScreen(),
          RegisterScreen(),
        ],
      ),
    );
  }
}

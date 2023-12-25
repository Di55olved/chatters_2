import 'dart:developer';

import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Screens/profile_screen.dart';
import 'package:chatters_2/Widgets/chatter_card.dart';
import 'package:chatters_2/bloc/user_bloc/user_bloc.dart';
import 'package:chatters_2/bloc/user_bloc/user_events.dart';
import 'package:chatters_2/bloc/user_bloc/user_states.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;

  const HomeScreen({super.key, required this.userRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserBloc _userBloc;
  List<Cuser> _userList = [];
  final List<Cuser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userRepository: widget.userRepository);
    _userBloc.add(const FetchUser());
    APIs.getSelfInfo();

//for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    // APIs.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          //if user presses back button, search unselected and app does not close
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name, Email, ...'),
                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      //when search text changes then updated search list
                      onChanged: (val) {
                        //search logic
                        _searchList.clear();

                        for (var i in _userList) {
                          if (i.name!
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email!
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                            setState(() {
                              _searchList;
                            });
                          }
                        }
                      },
                    )
                  : const Text('Chatters'),
              leading: const Icon(
                CupertinoIcons.home,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                user: APIs.me,
                                userRepository: widget.userRepository)));
                  },
                  icon: const Icon(Icons.more_vert),
                  color: Colors.black,
                )
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () async {
                  // await APIs.auth.signOut();
                  // await GoogleSignIn().signOut();
                },
                child: const Icon(Icons.add_comment_rounded),
              ),
            ),
            body: BlocBuilder(
              bloc: _userBloc,
              builder: (_, UserState state) {
                if (state is UserEmpty) {
                  return const Center(child: Text('Empty state'));
                }
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UserLoaded) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: state.user(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _userList = snapshot.data!.docs
                            .map((doc) => Cuser.fromJson(doc.data()))
                            .toList();

                        if (_userList.isEmpty) {
                          // Handle empty list
                          return const Center(
                            child: Text(
                              "No Users Available",
                              style: TextStyle(fontSize: 30),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: _isSearching
                              ? _searchList.length
                              : _userList.length,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .01,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatterCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _userList[index],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        // Handle error state
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      } else {
                        // Handle initial loading state
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                }
                if (state is UserError) {
                  return const Text(
                    'Something went wrong!',
                    style: TextStyle(color: Colors.red),
                  );
                }
                return const SizedBox();
              },
            )),
      ),
    );
  }
}

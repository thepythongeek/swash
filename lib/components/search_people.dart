import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/Chat/chartscreen.dart';
import 'package:swash/models/message_manager.dart';
import 'package:swash/models/models.dart';
import '../object/search_people.dart';
import 'components.dart';

class CustomSearch extends SearchDelegate {
  String hinttext;

  CustomSearch({required this.hinttext});

  @override
  String? get searchFieldLabel => hinttext;
  @override
  List<Widget>? buildActions(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<People>(
      future: createSearchPeople(
          query, Provider.of<ProfileManager>(context, listen: false).user!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List profiles = snapshot.data!.profiles;
            return ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  Map profile = profiles[index];
                  return GestureDetector(
                      onTap: () {
                        print(111);

                        Provider.of<MessageManager>(context, listen: false)
                            .addRecipient(profile['id']);

                        //   Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (context) => ChatArea()));
                      },
                      child: expert(profile, context));
                });
          } else {
            return Container(
              child: Center(
                child: Text('${snapshot.data}'),
              ),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<People>(
      future: createSearchPeople(
          query, Provider.of<ProfileManager>(context, listen: false).user!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List profiles = snapshot.data!.profiles;
            return ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  Map profile = profiles[index];
                  return GestureDetector(
                      onTap: () {
                        Provider.of<MessageManager>(context, listen: false)
                            .addRecipient(profile['id']);

//Navigator.of(context).push(MaterialPageRoute(
                        //    builder: (context) => ChatArea()));
                      },
                      child: expert(profile, context));
                });
          } else {
            return Container(
              child: Center(
                child: Text('${snapshot.data}'),
              ),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

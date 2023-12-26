import 'package:contact_buddy/ui/create_edit.dart';
import 'package:contact_buddy/ui/single_contact.dart';
import 'package:flutter/material.dart';

import '../data/contact_model.dart';
import '../services/sqlite_service.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final _sqliteService = SqliteService();
  late Future<List<ContactModel>> _contactListFuture;

  @override
  void initState() {
    super.initState();
    _contactListFuture = _refreshContactList();
  }

  Future<List<ContactModel>> _refreshContactList() async {
    return _sqliteService.readFavouriteContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ContactModel>>(
        future: _contactListFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<ContactModel>> snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No favorite contacts found.'));
          }
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () {
                setState(() {
                  _contactListFuture = _refreshContactList();
                });
                return _contactListFuture;
              },
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ContactModel contact = snapshot.data![index];
                  return ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(contact.image),
                      ),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.number),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleContactPage(
                          contact: contact,
                        ),
                      ),
                    ).then((_) {
                      setState(() {
                        _contactListFuture = _refreshContactList();
                      });
                    }),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () async {
                        contact.isFavourite = false;
                        await _sqliteService.updateContact(contact);
                        setState(() {
                          _contactListFuture = _refreshContactList();
                        });
                      },
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load contacts'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

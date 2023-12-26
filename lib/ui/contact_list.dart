import 'package:flutter/material.dart';
import '../data/contact_model.dart';
import '../services/sqlite_service.dart';
import '../ui/single_contact.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final _sqliteService = SqliteService();
  late Future<List<ContactModel>> _contactListFuture;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contactListFuture = _refreshContactList();
  }

  Future<List<ContactModel>> _refreshContactList() async {
    return _sqliteService.readContacts();
  }

  List<ContactModel> _filterContacts(List<ContactModel> contacts, String query) {
    if (query.isEmpty) {
      return contacts;
    }
    return contacts
        .where((contact) =>
            contact.name.toLowerCase().contains(query.toLowerCase()) ||
            contact.number.contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  // Refresh the contact list with the filtered results
                  _contactListFuture =
                      _refreshContactList().then((contacts) {
                    return _filterContacts(contacts, value);
                  });
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ContactModel>>(
              future: _contactListFuture,
              builder:
                  (BuildContext context, AsyncSnapshot<List<ContactModel>> snapshot) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contacts found.'));
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
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(contact.image),
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
                            icon: Icon(
                              contact.isFavourite ? Icons.star : Icons.star_border,
                            ),
                            onPressed: () async {
                              contact.isFavourite = !contact.isFavourite;
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
          ),
        ],
      ),
    );
  }
}
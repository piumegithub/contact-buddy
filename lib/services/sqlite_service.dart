import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/contact_model.dart';

class SqliteService {
  // initialize database
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'contact.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, number TEXT, image TEXT, isFavourite INTEGER)",
        );
      },
      version: 1,
    );
  }

  // insert contact
  Future<int> insertContact(ContactModel contact) async {
    var database = await this.initializeDB();
    var result = await database.insert('contacts', contact.toJson());
    return result;
  }

  // read contacts
  Future<List<ContactModel>> readContacts() async {
    List<ContactModel> contacts = [];
    var database = await this.initializeDB();
    var result = await database.query('contacts');
    result.forEach((element) {
      var contact = ContactModel.fromJson(element);
      contacts.add(contact);
    });
    return contacts;
  }

  // read favourite contacts
  Future<List<ContactModel>> readFavouriteContacts() async {
    List<ContactModel> contacts = [];
    var database = await this.initializeDB();
    var result =
        await database.query('contacts', where: 'isFavourite=?', whereArgs: [1]);
    result.forEach((element) {
      var contact = ContactModel.fromJson(element);
      contacts.add(contact);
    });
    return contacts;
  }

  Future<ContactModel> readContact(int id) async {
    var database = await this.initializeDB();
    var result =
        await database.query('contacts', where: 'id=?', whereArgs: [id]);
    var contact = ContactModel.fromJson(result.first);
    return contact;
  }

  // update contact
  Future<int> updateContact(ContactModel contact) async {
    var database = await this.initializeDB();
    var result = await database.update(
      'contacts',
      contact.toJson(),
      where: 'id=?',
      whereArgs: [contact.id],
    );
    return result;
  }

  // delete contact
  Future<int> deleteContact(int id) async {
    var database = await this.initializeDB();
    var result =
        await database.delete('contacts', where: 'id=?', whereArgs: [id]);
    return result;
  }
}
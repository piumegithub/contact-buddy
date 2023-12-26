import 'package:flutter/material.dart';
import '../data/contact_model.dart';
import '../services/sqlite_service.dart';

class CreateEditPage extends StatefulWidget {
  final ContactModel? contact;

  CreateEditPage({Key? key, this.contact}) : super(key: key);

  @override
  _CreateEditPageState createState() => _CreateEditPageState();
}

class _CreateEditPageState extends State<CreateEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _sqliteService = SqliteService();
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  String _imageUrl = 'https://picsum.photos/200';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name);
    _numberController = TextEditingController(text: widget.contact?.number);
    _nameController.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    setState(() {
      _imageUrl =
          'https://ui-avatars.com/api/?background=random&name=${_nameController.text.replaceAll(' ', '+')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Create Contact' : 'Edit Contact'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 32),
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                    widget.contact == null ? _imageUrl : widget.contact!.image),
              ),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Number',
                    border: OutlineInputBorder(),
                  ),
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () async {
                  _formKey.currentState!.validate();

                  if (_nameController.text.isNotEmpty &&
                      _numberController.text.isNotEmpty) {
                    if (widget.contact == null) {
                      var contact = ContactModel(
                        name: _nameController.text,
                        number: _numberController.text,
                        image:
                            'https://ui-avatars.com/api/?background=random&name=${_nameController.text.replaceAll(' ', '+')}',
                        id: DateTime.now().millisecondsSinceEpoch,
                      );
                      await _sqliteService.insertContact(contact);
                    } else {
                      widget.contact!.name = _nameController.text;
                      widget.contact!.number = _numberController.text;
                      widget.contact!.image =
                          'https://ui-avatars.com/api/?background=random&name=${_nameController.text.replaceAll(' ', '+')}';
                      await _sqliteService.updateContact(widget.contact!);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            widget.contact == null
                                ? 'Contact created successfully. Pull down to refresh.'
                                : 'Contact updated successfully.',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.contact == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'models/contact.dart';

class NewContactForm extends StatefulWidget {
  const NewContactForm({Key? key}) : super(key: key);

  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _age;

  void addContact(Contact contact) {
    // ignore: avoid_print
    print('Name: ${contact.name}, Age: ${contact.age}');

    // Hive.box('contacts').put(1, contact); // 自分でキーを指定して入れる
    // Hive.box('contact').add(contact); // AutoIncrementで追加する
    final contactsBox = Hive.box('contacts');
    contactsBox.add(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _name = value!,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _age = value!,
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Add New Contact'),
            onPressed: () {
              _formKey.currentState?.save();
              final newContact = Contact(_name!, int.parse(_age!));
              addContact(newContact);
            },
          ),
        ],
      ),
    );
  }
}

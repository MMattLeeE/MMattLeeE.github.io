import 'package:app_2/providers/inventory.dart';
import 'package:app_2/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_provider.dart';

class InventoryAddScreen extends StatefulWidget {
  static const routeName = '/inventory_add';

  @override
  _InventoryAddScreenState createState() => _InventoryAddScreenState();
}

class _InventoryAddScreenState extends State<InventoryAddScreen> {
  final _countFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedInventory = Inventory(
    id: null,
    title: '',
    count: 0,
    description: '',
    imageUrl: '',
  );

  void _submit() {
    final noError = _form.currentState.validate();
    if (!noError) {
      return;
    }
    _form.currentState.save();
    Provider.of<InventoryProvider>(context, listen: false)
        .addInventory(_editedInventory);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _countFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // does not rebuild due to changes in data as the view only looks
    // at one inventory item when editing
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Inventory Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_countFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedInventory = Inventory(
                    id: null,
                    title: value,
                    count: _editedInventory.count,
                    description: _editedInventory.description,
                    imageUrl: _editedInventory.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Count'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _countFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a count';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  if (int.parse(value) < 0) {
                    return 'Enter a positive count';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedInventory = Inventory(
                    id: null,
                    title: _editedInventory.title,
                    count: int.parse(value),
                    description: _editedInventory.description,
                    imageUrl: _editedInventory.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLength: 100,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedInventory = Inventory(
                    id: null,
                    title: _editedInventory.title,
                    count: _editedInventory.count,
                    description: value,
                    imageUrl: _editedInventory.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                focusNode: _imageUrlFocusNode,
                onFieldSubmitted: (_) {
                  _submit();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a Image Url';
                  }
                  if (!value.startsWith('http') && !value.startsWith('https')) {
                    return 'Enter a valid URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedInventory = Inventory(
                    id: null,
                    title: _editedInventory.title,
                    count: _editedInventory.count,
                    description: _editedInventory.description,
                    imageUrl: value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submit();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

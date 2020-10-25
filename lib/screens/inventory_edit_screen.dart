import 'package:app_2/providers/inventory.dart';
import 'package:app_2/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_provider.dart';

class InventoryEditScreen extends StatefulWidget {
  static const routeName = '/inventory_edit';

  @override
  _InventoryEditScreenState createState() => _InventoryEditScreenState();
}

class _InventoryEditScreenState extends State<InventoryEditScreen> {
  final _countFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedInventory = Inventory(
    id: null,
    title: '',
    count: 0,
    description: '',
    //imageUrl: '',
  );
  var _loading = false;

  Future<void> _submit() async {
    final noError = _form.currentState.validate();
    if (!noError) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<InventoryProvider>(context, listen: false)
          .updateInventory(_editedInventory.id, _editedInventory);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error occured'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
    }
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
    final inventoryId =
        ModalRoute.of(context).settings.arguments as String; // provides id
    // does not rebuild due to changes in data as the view only looks
    // at one inventory item when editing
    final loadedInventory = Provider.of<InventoryProvider>(
      context,
      listen: false, //does not rebuild due to data change
    ).findById(inventoryId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ' + loadedInventory.title),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue: loadedInventory.title,
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
                          id: inventoryId,
                          title: value,
                          count: _editedInventory.count,
                          description: _editedInventory.description,
                          // imageUrl: _editedInventory.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Count'),
                      initialValue: loadedInventory.count.toString(),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _countFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
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
                          id: inventoryId,
                          title: _editedInventory.title,
                          count: int.parse(value),
                          description: _editedInventory.description,
                          // imageUrl: _editedInventory.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      initialValue: loadedInventory.description,
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
                          id: inventoryId,
                          title: _editedInventory.title,
                          count: _editedInventory.count,
                          description: value,
                          // imageUrl: _editedInventory.imageUrl,
                        );
                      },
                    ),
                    // TextFormField(
                    //   decoration: InputDecoration(labelText: 'Image URL'),
                    //   // initialValue: loadedInventory.imageUrl,
                    //   keyboardType: TextInputType.url,
                    //   textInputAction: TextInputAction.done,
                    //   focusNode: _imageUrlFocusNode,
                    //   onFieldSubmitted: (_) {
                    //     _submit();
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Enter a Image Url';
                    //     }
                    //     if (!value.startsWith('http') &&
                    //         !value.startsWith('https')) {
                    //       return 'Enter a valid URL';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _editedInventory = Inventory(
                    //       id: inventoryId,
                    //       title: _editedInventory.title,
                    //       count: _editedInventory.count,
                    //       description: _editedInventory.description,
                    //       // imageUrl: value,
                    //     );
                    //   },
                    // ),
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

import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const id = '/edit_product_screen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocus.addListener(_imageUrlListener);
    super.initState();
  }

  void _imageUrlListener() {
    if (!_imageUrlFocus.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_imageUrlListener);
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter product title';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: DateTime.now().toString(),
                    title: value!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid value';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than 0';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: DateTime.now().toString(),
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your description';
                  }
                  if (value.length < 10) {
                    return 'Please provide more than 10 characters';
                  }
                  return null;
                },
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: DateTime.now().toString(),
                    title: _editedProduct.title,
                    description: value!,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: _imageUrlController.text.isEmpty
                        ? const Center(
                            child: Text('Enter Image Url'),
                          )
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image Url';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid url address';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid Url address';
                        }
                        return null;
                      },
                      focusNode: _imageUrlFocus,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Image Url',
                      ),
                      keyboardType: TextInputType.url,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: DateTime.now().toString(),
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value!,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

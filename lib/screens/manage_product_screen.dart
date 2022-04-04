import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const ManageProductScreen({Key? key}) : super(key: key);

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;

  Product _editedProduct = Product(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageUrl: "",
    userId: "",
    isFavorite: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage product"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,
                autovalidateMode: AutovalidateMode.disabled,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter product title"
                            : null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value as String,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          userId: _editedProduct.userId,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      focusNode: _descriptionFocusNode,
                      // textInputAction: TextInputAction.next,
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter product description"
                            : null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value as String,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          userId: _editedProduct.userId,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.price.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        return value!.isEmpty || double.tryParse(value)! <= 0.0
                            ? "Please enter valid price"
                            : null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value as String),
                          imageUrl: _editedProduct.imageUrl,
                          userId: _editedProduct.userId,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image url',
                        hintText: 'Url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      controller: _imageUrlController,
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter product image url"
                            : null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value as String,
                          userId: _editedProduct.userId,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      onFieldSubmitted: (_) => _saveForm,
                    ),
                    Container(
                      width: 250,
                      height: 250,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: _imageUrlController.text.isEmpty
                          ? const BoxDecoration()
                          : BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                      child: _imageUrlController.text.isEmpty
                          ? Container()
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null) {
        _editedProduct = arguments as Product;
        _editedProduct = Product(
          id: _editedProduct.id,
          title: _editedProduct.title,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: _editedProduct.imageUrl,
          userId: _editedProduct.userId,
          isFavorite: _editedProduct.isFavorite,
        );
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final is_Valid = _form.currentState!.validate();
    if (!is_Valid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id.isEmpty) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await _showErrorMessage(context);
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        await _showErrorMessage(context);
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showErrorMessage(BuildContext context) async {
    setState(() {
      _isLoading = false;
    });
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Something went wrong!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok!"),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/product_provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-products';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(description: '', title: '', id: null, imageUrl: '', price: 0.0);
  var _initProduct = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };
  var isInit = false;
  var _isLoaded = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductProvider>(
          context,
          listen: false,
        ).findById(productId);
        _initProduct = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          // 'imageUrl': '',
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = true;
    super.didChangeDependencies();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) if (!_imageUrlController.text
                .startsWith('http') &&
            !_imageUrlController.text.startsWith('https') ||
        !_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg')) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoaded = true;
    });
    if (_editedProduct.id == null) {
      try {
        await Provider.of<ProductProvider>(
          context,
          listen: false,
        ).addProduct(_editedProduct);
      } catch (error) {
        showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Text('Something went wrong.'),
                title: Text('An error occured!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Ok'))
                ],
              );
            });
      } 
    } else {
      try{
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).updateProduct(_editedProduct.id, _editedProduct);
      }catch(_){
         showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Text('Something went wrong.'),
                title: Text('An error occured!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Ok'))
                ],
              );
            });
      }
    }
      setState(() {
        _isLoaded = false;
      });
      Navigator.of(context).pop();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Edit Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: submitForm,
          )
        ],
      ),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initProduct['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            description: _editedProduct.description,
                            title: value,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the title.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initProduct['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            description: _editedProduct.description,
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid price.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'The price should be greater than zero.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initProduct['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            description: value,
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the description.';
                          }
                          if (value.length < 10) {
                            return 'The description should be greater than 10 characters.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    'Enter Image URL!',
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
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
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                              ),
                              controller: _imageUrlController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                submitForm();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  description: _editedProduct.description,
                                  title: _editedProduct.title,
                                  id: _editedProduct.id,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL.';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid URL.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}

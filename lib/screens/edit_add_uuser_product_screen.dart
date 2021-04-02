import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:max_ecommerce/models/providers/product.dart';
import 'package:max_ecommerce/models/providers/products_details.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'EditProductScreen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusnode = FocusNode();
  final _imgUrlFocusnode = FocusNode();
  final _descriptionFocusnode = FocusNode();
  final TextEditingController _imgUrl = TextEditingController();
  var data;
  var _editProduct = Product(
      id: '',
      title: '',
      description: '',
      imageUrl: '',
      price: 0.0,
      isFaviourte: false);
  final _form = GlobalKey<FormState>();
  bool isInit = true;
  var initVal = {'title': '', 'description': '', 'imgUrl': '', 'price': ''};
  @override
  void initState() {
    // TODO: implement initState
    _imgUrlFocusnode.addListener(_listenerToImgUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      final productId = (ModalRoute.of(context)!.settings.arguments) ?? '';
      final str = productId as String;
      if (str.isNotEmpty) {
        data = Provider.of<ProductInfo>(context)
            .productItems
            .where((element) => element.id == productId)
            .first;
        _editProduct = data;
        print('DataId${_editProduct.id}');
        initVal = {
          'title': data.title,
          'description': data.description,
          'imgUrl': data.imageUrl,
          'price': data.price.toString()
        };
        _imgUrl.text = data.imageUrl;
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    if (_editProduct.id.isEmpty) {
      print('empty');
      Provider.of<ProductInfo>(context, listen: false).addProduct(_editProduct);
    } else {
      Provider.of<ProductInfo>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    }
    Navigator.of(context).pop();
  }

  _listenerToImgUrl() {
    if (!_imgUrlFocusnode.hasFocus) {
      if (_imgUrl.text.isEmpty ||
          !_imgUrl.text.isURL ||
          !_imgUrl.text.isImageFileName) return;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusnode.dispose();
    _descriptionFocusnode.dispose();
    _imgUrl.dispose();
    _imgUrlFocusnode.removeListener(_listenerToImgUrl);
    _imgUrlFocusnode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: initVal['title'],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: initVal['title'],
                  labelText: 'Title',
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusnode);
                },
                validator: (val) {
                  if (val!.isEmpty) return 'please enter the Title';
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                      title: value!,
                      id: _editProduct.id,
                      price: _editProduct.price,
                      description: _editProduct.description,
                      imageUrl: _editProduct.imageUrl,
                      isFaviourte: _editProduct.isFaviourte);
                },
              ),
              TextFormField(
                initialValue: initVal['price'],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: initVal['price'],
                  labelText: 'price',
                ),
                keyboardType: TextInputType.number,
                focusNode: _priceFocusnode,
                onSaved: (value) {
                  _editProduct = Product(
                      title: _editProduct.title,
                      id: _editProduct.id,
                      price: double.parse(value!),
                      description: _editProduct.description,
                      imageUrl: _editProduct.imageUrl,
                      isFaviourte: _editProduct.isFaviourte);
                },
                validator: (val) {
                  if (val!.isEmpty) return 'Enter the price';
                  if (double.tryParse(val) == null) return 'Enter Valid Price';
                  if (double.parse(val) <= 0) return 'Enter Valid Price';
                  return null;
                },
              ),
              TextFormField(
                initialValue: initVal['description'],
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: initVal['description'],
                  labelText: 'Description',
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusnode);
                },
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusnode,
                onSaved: (value) {
                  _editProduct = Product(
                      title: _editProduct.title,
                      id: _editProduct.id,
                      price: _editProduct.price,
                      description: value!,
                      imageUrl: _editProduct.imageUrl,
                      isFaviourte: _editProduct.isFaviourte);
                },
                validator: (val) {
                  if (val!.isEmpty) return 'Please Enter Description';
                  if (val.length < 10) return 'Enter More Than 10 character';
                },
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 7, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1), color: Colors.grey),
                    child: _imgUrl.text.isEmpty
                        ? Container(
                            child: Text('Enter Url'),
                          )
                        : FittedBox(
                            child: Image.network(_imgUrl.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                        toolbarOptions: ToolbarOptions(
                            selectAll: true,
                            copy: true,
                            paste: true,
                            cut: true),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imgUrl,
                        decoration: InputDecoration(labelText: 'Image Url'),
                        focusNode: _imgUrlFocusnode,
                        onSaved: (value) {
                          _editProduct = Product(
                              title: _editProduct.title,
                              id: _editProduct.id,
                              price: _editProduct.price,
                              description: _editProduct.description,
                              imageUrl: value!,
                              isFaviourte: _editProduct.isFaviourte);
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (val) {
                          if (val!.isEmpty) return 'Please Enter Valid Url';
                          try {
                            if (!val.isURL || !val.isImageFileName) {
                              return 'enter valid image';
                            }
                          } on Exception catch (e) {
                            print(e);
                            return 'enter valid image';
                          }
                          return null;
                        }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

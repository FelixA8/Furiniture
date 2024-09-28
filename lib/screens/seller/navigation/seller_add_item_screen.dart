import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/services/product_firebase.dart';
import 'package:furiniture/widgets/upload_image_form.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SellerAddItemScreen extends StatefulWidget {
  final String uid;
  const SellerAddItemScreen({super.key, required this.uid});

  @override
  State<SellerAddItemScreen> createState() => _SellerAddItemScreenState();
}

class _SellerAddItemScreenState extends State<SellerAddItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  late String productName;
  late String description;
  late String price;
  late String stock;
  late String uid = widget.uid;
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  String? selectedCategory;
  File? _image;
  final picker = ImagePicker();
  bool isUploading = false;

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _submitForm(productName, description, price, category, stock, image,
      augmentedURL) async {
    // send data to firebase
    setState(() {
      isUploading = true;
    });
    var response = await createProduct(
        name: productName,
        description: description,
        price: price,
        category: category,
        augmentedURL: augmentedURL,
        image: image,
        sellerId: uid,
        stock: stock);
    //Create Product
    setState(() {
      isUploading = false;
    });
    if (response) {
      GoRouter.of(context).go("/seller/$sellerID");
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) {
      return '';
    }
    // Remove the Rupiah symbol and formatting before parsing
    String cleanedValue = value.replaceAll('Rp ', '').replaceAll(',', '');
    int intValue = int.parse(cleanedValue);
    return _currencyFormat.format(intValue);
  }

  int nameParsing(String priceWithCurrency) {
    String cleanPrice =
        priceWithCurrency.replaceAll('Rp ', '').replaceAll('.', '');
    int price = int.parse(cleanPrice);
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Product!"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    onSaved: (newValue) {
                      productName = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 3) {
                        return 'Please enter a valid product name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'Enter your product name',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    minLines: 3,
                    maxLines: 10,
                    onSaved: (newValue) {
                      description = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 20) {
                        return 'Please enter more than 20 letters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Product Description',
                      hintText: 'Enter your product Description',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    onSaved: (newValue) {
                      price = newValue!;
                    },
                    validator: (value) {
                      // add email validation
                      if (value == null || value.isEmpty) {
                        return 'Please enter some price';
                      }
                      if (value == "0") {
                        return "Nothing is free";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String newText = _formatCurrency(newValue.text);
                        return newValue.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter Product Price',
                      prefixIcon: Icon(Icons.attach_money_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(),
                        ),
                      ),
                      items: listCategories
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value.toString();
                        });
                      },
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for an item...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  ),
                  _gap(),
                  UploadImageForm(
                    image: _image,
                    pickImage: pickImage,
                    showImage: true,
                  ),
                  _gap(),
                  TextFormField(
                    onSaved: (newValue) {
                      stock = newValue!;
                    },
                    validator: (value) {
                      // add email validation
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value == "0") {
                        return "Enter at least one stock";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                      hintText: 'Enter Product Stocks',
                      prefixIcon: Icon(Icons.gradient_sharp),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextButton.icon(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green)),
                    onPressed: () {
                      //Make 3D Model
                    },
                    icon: const Icon(
                      Icons.architecture,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "(Optional) Create 3D Model",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: isUploading
                        ? const Text('Submitting...')
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Submit Product',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                print(sellerID);
                                // _submitForm(productName, description, price,
                                //     selectedCategory, stock, _image, "");
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

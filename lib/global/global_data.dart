import 'package:furiniture/view_models/person_model.dart';
import 'package:furiniture/view_models/product_model.dart';

final List<String> listCategories = [
  'Bed',
  'Chair',
  'Kitchenware',
  'Sofas',
  'Tables',
  'Others',
];

var userID = "";
var sellerID = "";

late Person globalUserData;
late final List<Product> globalListProduct;

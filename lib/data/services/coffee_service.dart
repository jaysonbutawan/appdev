import 'package:appdev/core/constants.dart';
import 'package:appdev/data/models/coffee.dart';
import 'package:appdev/data/services/api_services.dart';

final coffeeApi = ApiService<Coffee>(
  baseUrl: "${ApiConstants.baseUrl}coffee_api/index.php", 
  model: Coffee(
    id: '',
    name: '',
    description: '',
    imageBase64: '',
    category: '',
    price: '',
  ),
);

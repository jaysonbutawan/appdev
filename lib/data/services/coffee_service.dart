import 'package:appdev/data/models/coffee.dart';
import 'package:appdev/data/services/api_services.dart';

final coffeeApi = ApiService<Coffee>(
  baseUrl: "http://192.168.1.11/appdev/controller/index.php", 
  model: Coffee(
    id: '',
    name: '',
    description: '',
    imageBase64: '',
    category: '',
    price: '',
  ),
);

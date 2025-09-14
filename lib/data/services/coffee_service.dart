import 'package:appdev/data/models/coffee.dart';
import 'package:appdev/data/services/api_services.dart';

final coffeeApi = ApiService<Coffee>(
  baseUrl: "http://192.168.254.109/appdev/controller/index.php", 
  model: Coffee(
    id: '',
    title: '',
    description: '',
    imageBase64: '',
    category: '',
    price: '',
  ),
);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ConstController extends GetxController {
  static final ConstController _instance = new ConstController.internal();

  ConstController.internal();

  factory ConstController() => _instance;


  final RxMap currentUser = RxMap({});




}

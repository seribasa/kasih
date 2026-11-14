import 'package:kasih/features/payment/data/models/order_model.dart';
import 'package:kasih/features/vaccination/data/models/appointment_model.dart';
import 'package:equatable/equatable.dart';

class AppointmentOrderEntity extends Equatable {
  final AppointmentModel? appointment;
  final OrderModel? order;

  const AppointmentOrderEntity({this.appointment, this.order});

  @override
  List<Object?> get props => [appointment, order];
}

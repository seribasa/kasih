import 'package:kasih/features/payment/data/models/order_model.dart';
import 'package:kasih/features/vaccination/data/models/appointment_model.dart';
import 'package:kasih/features/vaccination/data/models/appointment_payment_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AppointmentRepository {
  final SupabaseClient supabaseClient;

  AppointmentRepository(this.supabaseClient);

  Future<List<AppointmentModel>> getAppointments({
    required String userId,
    String? sortCriteria,
  }) async {
    try {
      final orderBy = () {
        if (sortCriteria == 'date') {
          return 'date';
        } else if (sortCriteria == 'name') {
          return 'children ( name )';
        } else {
          return 'date';
        }
      }();
      final result = await supabaseClient
          .from(AppointmentModel.tableName)
          .select('''
              *,
              profiles:parent_id ( * ),
              children ( * )
            ''')
          .eq('parent_id', userId)
          .order(orderBy, ascending: true)
          .withConverter(
            (json) =>
                json.map((e) => AppointmentModel.fromSeribase(e)).toList(),
          );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentOrderEntity> getAppointment({required String id}) async {
    try {
      final fetch = await supabaseClient.functions.invoke(
        'api/appointments/$id',
        method: HttpMethod.get,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${supabaseClient.auth.currentSession?.accessToken}',
        },
      );
      if (fetch.status != 200 && fetch.status != 201) {
        throw Exception('Failed to initiate payment');
      }

      final data = fetch.data['data'];
      if (data == null) {
        throw Exception('Data not found');
      }
      final result = AppointmentModel.fromSeribase(data);
      final order =
          data['order'] != null ? OrderModel.fromSeribase(data['order']) : null;
      return AppointmentOrderEntity(appointment: result, order: order);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentOrderEntity> setAppointment(AppointmentModel model) async {
    try {
      final gateway = _cleanGateway(dotenv.env['PAYMENT_GATEWAY']);
      final currency = _cleanCurrency(dotenv.env['PAYMENT_CURRENCY']);
      final token = supabaseClient.auth.currentSession?.accessToken;
      final result = await supabaseClient.functions.invoke(
        'api/appointments',
        method: HttpMethod.post,
        body:
            model.toSeribase()
              ..addAll({'gateway': gateway, 'currency': currency}),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );
      if (result.status != 200 && result.status != 201) {
        final message =
            (result.data is Map && result.data['message'] != null)
                ? result.data['message'].toString()
                : (result.data is Map && result.data['error'] != null)
                ? (result.data['error'] is Map &&
                        result.data['error']['message'] != null)
                    ? result.data['error']['message'].toString()
                    : result.data['error'].toString()
                : 'Failed to set appointment';
        throw Exception(message);
      }
      final data = result.data['data'];
      if (data == null) {
        throw Exception('Data not found');
      }
      final appointment = AppointmentModel.fromSeribase(data);
      final orderById =
          data['order'] != null ? OrderModel.fromSeribase(data['order']) : null;
      return AppointmentOrderEntity(appointment: appointment, order: orderById);
    } catch (e) {
      rethrow;
    }
  }

  static String _cleanGateway(String? raw) {
    if (raw == null) return 'midtrans';
    final cleaned = raw.split('#').first.trim().toLowerCase();
    return cleaned == 'stripe' ? 'stripe' : 'midtrans';
  }

  static String _cleanCurrency(String? raw) {
    if (raw == null) return 'IDR';
    final cleaned = raw.split('#').first.trim().toUpperCase();
    return cleaned.isEmpty ? 'IDR' : cleaned;
  }

  Future<AppointmentModel> updateAppointment(AppointmentModel model) async {
    try {
      assert(model.id != null, 'ID appointment tidak ditemukan');
      await supabaseClient
          .from(AppointmentModel.tableName)
          .update(model.toSeribase())
          .eq('id', model.id!);

      return model;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAppointment(String id) async {
    return await supabaseClient
        .from(AppointmentModel.tableName)
        .delete()
        .eq('id', id);
  }
}

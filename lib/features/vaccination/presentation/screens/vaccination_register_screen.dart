import 'package:kasih/core/utils/constant.dart';
import 'package:kasih/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:kasih/features/health_worker/data/models/health_worker_model.dart';
import 'package:kasih/features/profile/data/models/child_model.dart';
import 'package:kasih/features/vaccination/data/models/appointment_model.dart';
import 'package:kasih/features/vaccination/logic/blocs/appointmentBloc/appointment_bloc.dart';
import 'package:kasih/injection.dart';
import 'package:kasih/core/widgets/button_custom.dart';
import 'package:kasih/core/widgets/snackbar_custom.dart';
import 'package:kasih/routers/route_paths/vaccination_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/picker.dart';

class VaccinationRegisterScreen extends StatelessWidget {
  final ChildModel anak;
  final HealthWorkerModel nakes;

  const VaccinationRegisterScreen({
    Key? key,
    required this.anak,
    required this.nakes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppointmentBloc>(),
      child: _VaccinationRegisterScaffold(child: anak, healthWorker: nakes),
    );
  }
}

class _VaccinationRegisterScaffold extends StatefulWidget {
  final ChildModel child;
  final HealthWorkerModel healthWorker;

  const _VaccinationRegisterScaffold({
    required this.child,
    required this.healthWorker,
  });

  @override
  State<_VaccinationRegisterScaffold> createState() =>
      _VaccinationRegisterScaffoldState();
}

class _VaccinationRegisterScaffoldState
    extends State<_VaccinationRegisterScaffold> {
  DateTime? _selectedDate;
  Schedule? selectedRadioTile;
  String? _note;

  final kFirstDay = DateTime.now().add(Duration(days: 1));
  final kLastDay = DateTime(DateTime.now().year + 1);

  setSelectedRadioTile(Schedule? val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  setNoteValue(String val) {
    setState(() {
      _note = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (context.read<AuthenticationBloc>().state as Authenticated).user;

    void onSubmit() {
      if (selectedRadioTile == null || _selectedDate == null) {
        snackbarCustom('Lengkapi data terlebih dahulu!').show(context);
        return;
      }
      final appointment = AppointmentModel(
        date: _selectedDate,
        child: widget.child,
        parent: user,
        healthWorker: widget.healthWorker,
        purpose: 'Imunisasi',
        note: _note,
        startTime: selectedRadioTile?.startTime,
        endTime: selectedRadioTile?.endTime,
      );
      context.read<AppointmentBloc>().add(CreateAppointmentEvent(appointment));
    }

    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state.statusSubmit == FormzSubmissionStatus.success) {
          context.go(
            VaccinationRoutePaths.vaccinationConfirmation.fullPath,
            extra: state.appointmentWithOrder?.appointment?.id,
          );
        } else if (state.statusSubmit == FormzSubmissionStatus.failure) {
          snackbarCustom(
            state.errorMessage ?? AppConstant.MAKE_APPOINTMENT_FAILED,
          ).show(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text(
            AppConstant.MAKE_APPOINTMENT,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            return SizedBox.expand(
              child: Container(
                color: Colors.black,
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  elevation: 0,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Nakes: ' +
                                (widget.healthWorker.fullName ?? '-'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...?widget.healthWorker.schedules?.map((schedule) {
                            final day = schedule.day?.name;
                            return Column(
                              children: [
                                Text('$day, ${schedule.time}'),
                                SizedBox(height: 5),
                              ],
                            );
                          }).toList(),
                          SizedBox(height: 20),
                          TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text:
                                  _selectedDate == null
                                      ? null
                                      : DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(_selectedDate!),
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range),
                              suffixIconColor: Colors.black,
                              labelText: 'Tanggal',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onTap: () async {
                              final date = await Picker.pickDate(
                                context,
                                currentTime: () {
                                  final days =
                                      widget.healthWorker.practiceSchedules
                                          ?.map((e) => e.day?.id)
                                          .whereType<int>()
                                          .toList();

                                  if (days == null || days.isEmpty) {
                                    return null;
                                  }

                                  final tomorrowDate = DateTime.now().add(
                                    Duration(days: 1),
                                  );
                                  final tomorrow = tomorrowDate.weekday;

                                  final nextAvailableDay = days.firstWhere(
                                    (element) => element >= tomorrow,
                                    orElse: () => days.first,
                                  );

                                  final difference =
                                      (nextAvailableDay - tomorrow) % 7;
                                  return tomorrowDate.add(
                                    Duration(days: difference),
                                  );
                                }(),
                                maxTime: kLastDay,
                                minTime: kFirstDay,
                                selectableDayPredicate: (DateTime day) {
                                  final daySchedule = widget
                                      .healthWorker
                                      .practiceSchedules
                                      ?.where((element) {
                                        return element.day?.id == day.weekday;
                                      });
                                  return daySchedule?.isNotEmpty ?? false;
                                },
                              );
                              setState(() {
                                _selectedDate = date;
                                if (selectedRadioTile != null &&
                                    selectedRadioTile?.day?.id !=
                                        date?.weekday) {
                                  selectedRadioTile = null;
                                }
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Jadwal Praktek Imunisasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Column(
                            children:
                                () {
                                      if (_selectedDate == null) {
                                        return [
                                          Text('Pilih tanggal terlebih dahulu'),
                                        ];
                                      }
                                      final schedules =
                                          widget.healthWorker.practiceSchedules;
                                      if (schedules == null ||
                                          schedules.isEmpty) {
                                        return Text(
                                          'Belum ada jadwal imunisasi',
                                        );
                                      }
                                      return schedules
                                          .where((element) {
                                            return element.day?.id ==
                                                _selectedDate?.weekday;
                                          })
                                          .map((e) {
                                            final day = e.day?.name;
                                            return RadioListTile<Schedule>(
                                              dense: true,
                                              contentPadding: EdgeInsets.all(0),
                                              value: e,
                                              groupValue: selectedRadioTile,
                                              title: Text(
                                                '$day, ${e.time}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              onChanged: setSelectedRadioTile,
                                            );
                                          })
                                          .toList();
                                    }()
                                    as List<Widget>,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            onChanged: setNoteValue,
                            maxLines: null,
                            minLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Catatan (Opsional)',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ListTile(
                            title: Text(
                              'Booking Fee: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              'Rp. ${widget.healthWorker.bookingFee ?? '-'}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          ButtonCustom(
                            onPressed: onSubmit,
                            loading:
                                state.statusSubmit ==
                                FormzSubmissionStatus.inProgress,
                            child: Text(
                              'Buat Janji',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

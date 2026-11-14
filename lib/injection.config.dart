// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import 'core/di/app_module.dart' as _i808;
import 'features/authentication/data/repositories/auth_repository.dart'
    as _i594;
import 'features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart'
    as _i556;
import 'features/authentication/logic/cubit/local_auth_cubit/local_auth_cubit.dart'
    as _i855;
import 'features/authentication/logic/cubit/login_cubit/login_cubit.dart'
    as _i1044;
import 'features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart'
    as _i53;
import 'features/authentication/logic/cubit/reset_password_cubit/reset_password_cubit.dart'
    as _i122;
import 'features/authentication/logic/cubit/signup_cubit/signup_cubit.dart'
    as _i64;
import 'features/calendar/data/repositories/calendar_repository.dart' as _i990;
import 'features/calendar/logic/bloc/calendar_bloc/calendar_bloc.dart' as _i246;
import 'features/contact/data/repositories/clinic_repository.dart' as _i30;
import 'features/contact/logic/clinic_bloc/clinic_bloc.dart' as _i860;
import 'features/health_worker/data/repositories/health_worker_repository.dart'
    as _i295;
import 'features/health_worker/logic/blocs/healthWorkerBloc/health_worker_bloc.dart'
    as _i811;
import 'features/healthy_book/data/repositories/checkup_repository.dart'
    as _i665;
import 'features/healthy_book/logic/blocs/checkupBloc/checkup_bloc.dart'
    as _i29;
import 'features/payment/data/repositories/payment_repository.dart' as _i701;
import 'features/payment/logic/blocs/payment_bloc/payment_bloc.dart' as _i580;
import 'features/profile/data/repositories/child_repository.dart' as _i545;
import 'features/profile/logic/blocs/childBloc/child_profile_bloc.dart'
    as _i284;
import 'features/profile/logic/blocs/parentBloc/profile_bloc.dart' as _i980;
import 'features/splash/data/repositories/splash_repository.dart' as _i927;
import 'features/vaccination/data/repositories/appointment_repository.dart'
    as _i368;
import 'features/vaccination/logic/blocs/appointmentBloc/appointment_bloc.dart'
    as _i977;
import 'services/notifications.dart' as _i403;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i979.HiveInterface>(() => appModule.hiveInterface);
    gh.factory<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.singleton<_i403.NotificationService>(() => _i403.NotificationService());
    gh.factory<_i30.ClinicRepository>(
        () => _i30.ClinicRepository(gh<_i454.SupabaseClient>()));
    gh.factory<_i295.HealthWorkerRepository>(
        () => _i295.HealthWorkerRepository(gh<_i454.SupabaseClient>()));
    gh.factory<_i545.ChildRepository>(
        () => _i545.ChildRepository(gh<_i454.SupabaseClient>()));
    gh.factory<_i368.AppointmentRepository>(
        () => _i368.AppointmentRepository(gh<_i454.SupabaseClient>()));
    gh.factory<_i665.CheckupRepository>(
        () => _i665.CheckupRepository(gh<_i454.SupabaseClient>()));
    gh.factory<_i977.AppointmentBloc>(
        () => _i977.AppointmentBloc(gh<_i368.AppointmentRepository>()));
    gh.factory<_i860.ClinicBloc>(
        () => _i860.ClinicBloc(gh<_i30.ClinicRepository>()));
    gh.factory<_i594.AuthRepository>(() => _i594.AuthRepository(
          gh<_i460.SharedPreferences>(),
          gh<_i454.SupabaseClient>(),
        ));
    gh.factory<_i284.ChildProfileBloc>(
        () => _i284.ChildProfileBloc(gh<_i545.ChildRepository>()));
    gh.factory<_i927.SplashRepository>(
        () => _i927.SplashRepository(gh<_i460.SharedPreferences>()));
    gh.factory<_i855.LocalAuthCubit>(
        () => _i855.LocalAuthCubit(gh<_i460.SharedPreferences>()));
    gh.factory<_i990.CalendarRepository>(() => _i990.CalendarRepository(
          gh<_i454.SupabaseClient>(),
          gh<_i979.HiveInterface>(),
        ));
    gh.factory<_i29.CheckupBloc>(
        () => _i29.CheckupBloc(gh<_i665.CheckupRepository>()));
    gh.factory<_i980.ProfileBloc>(
        () => _i980.ProfileBloc(gh<_i594.AuthRepository>()));
    gh.factory<_i1044.LoginCubit>(
        () => _i1044.LoginCubit(gh<_i594.AuthRepository>()));
    gh.factory<_i122.ResetPasswordCubit>(
        () => _i122.ResetPasswordCubit(gh<_i594.AuthRepository>()));
    gh.factory<_i64.SignUpCubit>(
        () => _i64.SignUpCubit(gh<_i594.AuthRepository>()));
    gh.factory<_i53.LoginPhoneCubit>(
        () => _i53.LoginPhoneCubit(gh<_i594.AuthRepository>()));
    gh.factory<_i811.HealthWorkerBloc>(
        () => _i811.HealthWorkerBloc(gh<_i295.HealthWorkerRepository>()));
    gh.factoryParam<_i701.PaymentRepository, _i454.SupabaseClient?, dynamic>((
      supabaseClient,
      _,
    ) =>
        _i701.PaymentRepository(supabaseClient: supabaseClient));
    gh.factory<_i246.CalendarBloc>(() => _i246.CalendarBloc(
          gh<_i403.NotificationService>(),
          gh<_i990.CalendarRepository>(),
        ));
    gh.singleton<_i556.AuthenticationBloc>(() => _i556.AuthenticationBloc(
          gh<_i594.AuthRepository>(),
          gh<_i927.SplashRepository>(),
          gh<_i454.SupabaseClient>(),
        ));
    gh.factory<_i580.PaymentBloc>(
        () => _i580.PaymentBloc(gh<_i701.PaymentRepository>()));
    return this;
  }
}

class _$AppModule extends _i808.AppModule {}

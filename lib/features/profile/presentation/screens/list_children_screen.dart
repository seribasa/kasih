import 'package:kasih/core/extension.dart';
import 'package:kasih/core/widgets/error.dart';
import 'package:kasih/features/profile/presentation/screens/child_profile_screen.dart';
import 'package:kasih/routers/route_paths/profile_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/top_app_bar.dart';
import '../../../../injection.dart';
import '../../data/models/child_model.dart';
import '../../logic/blocs/childBloc/child_profile_bloc.dart';

class ListChildrenScreen extends StatelessWidget {
  final Function(ChildModel?)? onSelected;

  const ListChildrenScreen({Key? key, this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ChildProfileBloc>()..add(OnGetChildrenEvent()),
      child: Scaffold(
        appBar: AppBarPeltops(title: AppConstant.APP_BAR_CHILD_PROFILE),
        backgroundColor: Colors.black,
        body: BlocBuilder<ChildProfileBloc, ChildProfileState>(
          builder: (context, state) {
            if (state.statusGetChildren == FormzSubmissionStatus.failure) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Center(
                    child: ErrorContainer(
                      onRefresh: () {
                        context.read<ChildProfileBloc>().add(
                          OnGetChildrenEvent(),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else if (state.statusGetChildren ==
                FormzSubmissionStatus.inProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.children == null || state.children!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Data pasien belum tersedia, silakan tambahkan data pasien',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }
            final data = state.children;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: data?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      if (onSelected != null) {
                        onSelected!(data?[index]);
                        return;
                      }
                      context.push(
                        ProfileRoutePaths.editChildren.fullPath,
                        extra: {
                          'child': data?[index],
                          'mode': ChildProfileScreenMode.edit,
                          'bloc': context.read<ChildProfileBloc>(),
                        },
                      );
                    },
                    title: Text(
                      data?[index].nama ?? emptyString,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(data?[index].umurAnak ?? emptyString),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: BlocBuilder<ChildProfileBloc, ChildProfileState>(
          builder: (context, state) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                context.push(
                  ProfileRoutePaths.addChildren.fullPath,
                  extra: {'bloc': context.read<ChildProfileBloc>()},
                );
              },
            );
          },
        ),
      ),
    );
  }
}

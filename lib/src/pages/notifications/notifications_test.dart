import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/notifications/notifications_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          ( NotificationsBloc bloc) => Text(
            '${bloc.state.status}', 
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFFFFFFF),
                fontFamily: 'AvenirReg',
              )
          ),
        ),
        actions:[
          IconButton(
            icon: const Icon(Icons.notifications),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              iconColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {
              context.read<NotificationsBloc>().requestPermission();
            },
          )
        ]
      ),
      body: Container(
        child: const Center(
          child: Text('data'),
        ),
      ),
    );
  }
}


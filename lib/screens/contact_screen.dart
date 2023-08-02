import 'package:contacts_app/data/cubit/contact_state.dart';
import 'package:contacts_app/data/cubit/contacts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts App'),
        centerTitle: true,
      ),
      body: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          if (state is ContactLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ContactsLoadedState) {
            return AnimatedList(
              initialItemCount: state.contacts.length,
              itemBuilder: (context, index, animation) {
                return ListTile(
                  title: Text(state.contacts[index].displayName!),
                  subtitle: Text(
                    state.contacts[index].phones![0].value!,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.white,
                    child: Text(state.contacts[index].displayName![0]),
                  ),
                  trailing: const Icon(Icons.arrow_circle_right_sharp),
                );
              },
            );
          }

          return Center(
            child: Text(state is ContactsErrorState ? state.error : ''),
          );
        },
      ),
    );
  }
}

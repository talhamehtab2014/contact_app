import 'package:contacts_service/contacts_service.dart';

abstract class ContactState {}

class ContactInitialState extends ContactState {}

class ContactLoadingState extends ContactState {}

class ContactsLoadedState extends ContactState {
  final List<Contact> contacts;
  ContactsLoadedState(this.contacts);
}

class ContactsErrorState extends ContactState {
  final String error;
  ContactsErrorState(this.error);
}

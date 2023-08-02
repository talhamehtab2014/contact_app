import 'package:contacts_app/data/cubit/contact_state.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactCubit extends Cubit<ContactState> {
  static const MethodChannel _channel =
      MethodChannel('github.com/clovisnicolas/flutter_contacts');

  ContactCubit() : super(ContactInitialState()) {
    fetchContacts();
  }

  void fetchContacts(
      {String? query,
      bool withThumbnails = true,
      bool photoHighResolution = true,
      bool orderByGivenName = true,
      bool iOSLocalizedLabels = true,
      bool androidLocalizedLabels = true}) async {
    emit(ContactLoadingState());
    if (await _getPermission().isGranted) {
      Iterable contacts =
          await _channel.invokeMethod('getContacts', <String, dynamic>{
        'query': query,
        'withThumbnails': withThumbnails,
        'photoHighResolution': photoHighResolution,
        'orderByGivenName': orderByGivenName,
        'iOSLocalizedLabels': iOSLocalizedLabels,
        'androidLocalizedLabels': androidLocalizedLabels,
      });

      List<Contact> contactList =
          contacts.map((m) => Contact.fromMap(m)).toList();
      emit(ContactsLoadedState(contactList));
    } else {
      emit(ContactsErrorState('Permission Denied'));
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }
}

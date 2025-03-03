import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:universal_html/js_util.dart' as forms;

import '../../../core/models/form_model.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());
  static RequestsCubit get(context) => BlocProvider.of(context);
  List<FormModel> sentForms = [];
  List<FormModel> receivedForms = [];

  void getSentForms(String userId)async{
    sentForms.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sent_forms')
        .get().then((value) async {
      for (var element in value.docs) {
        sentForms.add(FormModel.fromJson(element.data()));
      }
    });
    emit(GetSentForms());
  }
  void getReceivedForms(String userId)async{
    receivedForms.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('received_forms')
        .get().then((value) async {
      for (var element in value.docs) {
        DocumentReference<Map<String,dynamic>> receivedFormRef;
        receivedFormRef = await element['formRef'];
        print(receivedFormRef);
        await receivedFormRef.get().then((onValue){
          print(onValue.data());
          receivedForms.add(FormModel.fromJson(onValue.data()));
        });
      }
    });
    emit(GetSentForms());
  }



}

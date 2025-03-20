

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/src/intl/date_format.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';

import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;
import '../../../core/constants/constants.dart';
import '../../../core/models/form_model.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());

  static RequestsCubit get(context) => BlocProvider.of(context);
  List<FormModel> sentForms = [];
  List<FormModel> receivedForms = [];



  Future signTheForm(List<GlobalKey> globalKeys, FormModel form,BuildContext context) async {
    try{
      showDialog(barrierDismissible: false,context: context, builder: (context) => AlertDialog(content: Text('Loading'),),);
      await Future.delayed(const Duration(seconds: 1));
      /// sign the form
      Uint8List pdfBytes =   await AppFunctions.saveWidgetsAsPdf(globalKeys);
      /// upload form get link
      String downloadLink = form.formLink ?? '';
      await FirebaseStorage.instance
          .ref()
          .child(
              'SignedForms/$form.formName/${Constants.userModel?.userId}/$form.formName${DateFormat('yyy-MM-dd-hh:mm').format(DateTime.now())}.pdf')
          .putData(pdfBytes, SettableMetadata(contentType: 'application/pdf'))
          .then((onValue) async {
        downloadLink = await onValue.ref.getDownloadURL();
      });
      /// check if last required email
      /// change link
      /// add me to signed by and if last required email change isFullySigned
      bool isLastRequiredEmail = false;
      form.signedBy!.add(Constants.userModel!.email!);
      if (form.sentTo!.length == form.signedBy!.length) {
        isLastRequiredEmail = true;
      }

      await form.formReference!.update({
        'formLink': downloadLink,
        'signedBy': form.signedBy,
        'isFullySigned': isLastRequiredEmail,
      });
      if(context.mounted)Navigator.pop(context);
    }catch(e){
      print('Sign Error: $e');
    }
  }

  bool checkIfValidToSign(FormModel form) {
    late bool isValidToSign;
    for (int i = 0; i < form.sentTo!.length; i++) {
      if (Constants.userModel!.email == form.sentTo![i] && i == 0) {
        isValidToSign = true;
      } else if (Constants.userModel!.email == form.sentTo![i]) {
        if (form.signedBy!.length == i) {
          isValidToSign = true;
        } else {
          isValidToSign = false;
        }
      }
    }
    return isValidToSign;
  }

  List<FormModel> fullSignedList = [];

  void getSentForms(String userId) async {
    sentForms.clear();
    fullSignedList.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sent_forms')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        var form = FormModel.fromJson(element.data());
        if (form.isFullySigned == true) {
          fullSignedList.add(form);
        } else {
          sentForms.add(form);
        }
      }
      sentForms.sort((a, b) {
        return b.sentDate!.microsecondsSinceEpoch
            .compareTo(a.sentDate!.microsecondsSinceEpoch);
      });
    });

    emit(GetSentForms());
  }
  //if isFullySigned is true put form in Signedbyme List

  List<FormModel> signedByMe = [];

  void getReceivedForms(String userId,) async {
    receivedForms.clear();
    signedByMe.clear();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('received_forms')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        DocumentReference<Map<String, dynamic>> receivedFormRef;
        receivedFormRef = await element['formRef'];
        print(receivedFormRef);
        await receivedFormRef.get().then((onValue) {
          var form = FormModel.fromJson(onValue.data());
          if (form.signedBy?.contains(Constants.userModel!.email) ?? false) {
            signedByMe.add(form);
          } else {
            receivedForms.add(form);
          }
        });
      }
      print(signedByMe);

      receivedForms.sort((a, b) {
        return b.sentDate!.microsecondsSinceEpoch
            .compareTo(a.sentDate!.microsecondsSinceEpoch);
      });
    });

    emit(GetSentForms());
  }



  bool isLoading = false;

  Future<Uint8List> saveWidgetsAsPdf(List<GlobalKey> globalKeys) async {
    if (globalKeys.isEmpty) {
      throw ArgumentError(
          'The number of global keys must match the number of image names.');
    }

    try {
      // emit(LoadingSave());

      final pdf = pw.Document();

      for (int i = 0; i < globalKeys.length; i++) {
        final globalKey = globalKeys[i];

        // Check if the global key's context is valid
        if (globalKey.currentContext == null) {
          print('Error: Global key context is null for index $i');
          continue; // Skip this key if the context is invalid
        }

        // Capture the widget as an image
        RenderRepaintBoundary boundary = globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(
            pixelRatio: 3.0); // Increase pixel ratio for better quality
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Add a page with the image
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(pngBytes),
                ),
              );
            },
          ),
        );
      }

      // Save the PDF to bytes
      Uint8List bytes = await pdf.save();

      // Trigger a download of the PDF file
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'images.pdf'; // Set the PDF file name
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
      // emit(SaveSuccess());

      return bytes;
    } catch (e) {
      print('Error saving widgets as PDF: $e');
      return [] as Uint8List;
    }
  }
}

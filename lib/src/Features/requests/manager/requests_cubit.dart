import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/src/intl/date_format.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/style/colors.dart';

import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;
import '../../../core/constants/constants.dart';
import '../../../core/models/form_model.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());

  static RequestsCubit get(context) => BlocProvider.of(context);
  List<FormModel> sentForms = [];
  List<FormModel> allForms = [];
  List<FormModel> allFormsView = [];
  List<FormModel> receivedForms = [];
  List<FormModel> receivedFormsView = [];

  List<FormModel> sentFormsView = [];
  List<FormModel> fullySignedView = [];

  getAllForms() async {
    allForms.clear();
    allFormsView.clear();
    emit(GetAllFormsLoading());
    await FirebaseFirestore.instance
        .collection('sentForms')
        .get()
        .then((onValue) async {
      for (var element in onValue.docs) {
        DocumentReference<Map<String, dynamic>> ref;
        ref = await element.data()['ref'];
        await ref.get().then((onValue) async {
          if ((await onValue.data()?['isFullySigned']) ?? false) {
            allForms.add(FormModel.fromJson(onValue.data()));
          }
        });
      }
    });
    allFormsView = allForms.toList();
    allFormsView.sort((a, b) {
      return b.sentDate!.microsecondsSinceEpoch
          .compareTo(a.sentDate!.microsecondsSinceEpoch);
    });
    emit(GetAllFormsDone());
  }

  dateQueryFullySigned(DateTimeRange? dateRange) {
    if (dateRange != null) {
      fullySignedView = fullySignedView.where((element) {
        return (element.sentDate!.toDate().isAfter(dateRange.start) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.start)) &&
            (element.sentDate!.toDate().isBefore(dateRange.end) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.end));
      }).toList();
      emit(Search());
    }
  }
  dateQueryAllForms(DateTimeRange? dateRange) {
    if (dateRange != null) {
      allFormsView = allFormsView.where((element) {
        return (element.sentDate!.toDate().isAfter(dateRange.start) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.start)) &&
            (element.sentDate!.toDate().isBefore(dateRange.end) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.end));
      }).toList();
      emit(Search());
    }
  }

  dateQueryPending(DateTimeRange? dateRange) {
    if (dateRange != null) {
      sentFormsView = sentFormsView.where((element) {
        return (element.sentDate!.toDate().isAfter(dateRange.start) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.start)) &&
            (element.sentDate!.toDate().isBefore(dateRange.end) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.end));
      }).toList();
      emit(Search());
    }
  }

  dateQueryReceivedForms(DateTimeRange? dateRange) {
    if (dateRange != null) {
      receivedFormsView = receivedFormsView.where((element) {
        return (element.sentDate!.toDate().isAfter(dateRange.start) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.start)) &&
            (element.sentDate!.toDate().isBefore(dateRange.end) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.end));
      }).toList();
      emit(Search());
    }
  }

  dateQuerySignedByMe(DateTimeRange? dateRange) {
    if (dateRange != null) {
      signedByMeView = signedByMeView.where((element) {
        return (element.sentDate!.toDate().isAfter(dateRange.start) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.start)) &&
            (element.sentDate!.toDate().isBefore(dateRange.end) ||
                element.sentDate!.toDate().isAtSameMomentAs(dateRange.end));
      }).toList();
      emit(Search());
    }
  }

  searchPendingRequests(String? title) {
    if (title == null || title.isEmpty) {
      sentFormsView = sentForms.toList();
      emit(Search());
      return;
    }
    sentFormsView.clear();
    sentFormsView =
        sentForms.where((element) => element.formTitle == title).toList();
    emit(Search());
  }
  searchAllForms(String? title) {
    if (title == null || title.isEmpty) {
      allFormsView = allForms.toList();
      emit(Search());
      return;
    }
    allFormsView.clear();
    allFormsView =
        allForms.where((element) => element.formTitle == title).toList();
    emit(Search());
  }

  searchSignedByMe(String? title) {
    if (title == null || title.isEmpty) {
      signedByMeView = signedByMe.toList();
      emit(Search());
      return;
    }
    signedByMeView.clear();
    signedByMeView =
        signedByMe.where((element) => element.formTitle == title).toList();
    emit(Search());
  }

  searchReceivedForms(String? title) {
    if (title == null || title.isEmpty) {
      receivedFormsView = receivedForms.toList();
      emit(Search());
      return;
    }
    receivedFormsView.clear();
    receivedFormsView =
        receivedForms.where((element) => element.formTitle == title).toList();
    emit(Search());
  }

  searchFullySignedRequests(String? title) {
    if (title == null || title.isEmpty) {
      fullySignedView = fullSignedList.toList();
      emit(Search());
      return;
    }
    fullySignedView.clear();
    fullySignedView =
        fullSignedList.where((element) => element.formTitle == title).toList();
    emit(Search());
  }

  Future signTheForm(
      List<GlobalKey> globalKeys, FormModel form, BuildContext context) async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'Loading',
            style: TextStyle(color: AppColors.mainColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));

      /// sign the form
      Uint8List pdfBytes = await AppFunctions.saveWidgetsAsPdf(globalKeys);

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
      if (form.sentTo!.length != form.signedBy!.length) {
        await AppFunctions.sendEmailTo(
            toEmail: form.sentTo?[form.signedBy?.length ?? 0] ?? '',
            fromEmail: form.sentBy ?? '');
      }
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
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
    emit(LoadingSentForms());
    print(userId);
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
      fullySignedView = fullSignedList.toList();
      sentFormsView = sentForms.toList();
      sentFormsView.sort((a, b) {
        return b.sentDate!.microsecondsSinceEpoch
            .compareTo(a.sentDate!.microsecondsSinceEpoch);
      });
    });

    emit(GetSentForms());
  }

  //if isFullySigned is true put form in Signedbyme List

  List<FormModel> signedByMe = [];
  List<FormModel> signedByMeView = [];

  void getReceivedForms(
    String userId,
  ) async {
    receivedForms.clear();
    signedByMe.clear();
    emit(LoadingReceivedForms());
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
      signedByMeView = signedByMe.toList();
      receivedFormsView = receivedForms.toList();
      receivedFormsView.sort((a, b) {
        return b.sentDate!.microsecondsSinceEpoch
            .compareTo(a.sentDate!.microsecondsSinceEpoch);
      });
    });

    emit(GetReceivedForms());
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

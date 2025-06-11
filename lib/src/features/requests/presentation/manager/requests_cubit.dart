import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/models/comment_model.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:signature_system/src/core/style/colors.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());

  static RequestsCubit get(context) => BlocProvider.of(context);
  List<FormModel> sentForms = [];
  List<FormModel> allForms = [];
  List<FormModel> allFormsView = [];
  List<FormModel> receivedForms = [];
  List<FormModel> receivedFormsView = [];
  TextEditingController commentsController = TextEditingController();
  List<FormModel> sentFormsView = [];
  List<FormModel> fullySignedView = [];

  Future<List<String>> getFinanceTeam() async {
    List<String> financeEmails = [];
    await FirebaseFirestore.instance.collection('users').get().then(
      (value) {
        for (var element in value.docs) {
          if (element.data()['department'] == 'Finance') {
            financeEmails.add(element.id);
          }
        }
      },
    );
    return financeEmails;
  }

  getFullySignedForms() async {
    allForms.clear();
    allFormsView.clear();
    emit(GetAllFormsLoading());
    await FirebaseFirestore.instance
        .collection('fullySignedForms')
        .get()
        .then((onValue) async {
      for (var element in onValue.docs) {
        DocumentReference<Map<String, dynamic>> ref;
        ref = await element.data()['ref'];
        await ref.get().then((onValue) async {
          allForms.add(FormModel.fromJson(onValue.data()));
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

  List<CommentModel> comments = [];

  void getComments(FormModel formModel) {
    comments.clear();
    DocumentReference<Map<String, dynamic>> ref = formModel.formReference!;
    ref.get().then((onValue) {
      final data = onValue.data();
      if (data != null && data['comments'] != null) {
        List<dynamic> commentList = data['comments'];
        comments = commentList.map((e) => CommentModel.fromJson(e)).toList();
      }
      emit(GetComments());
    }).catchError((error) {});
  }

  Future addComment(FormModel formModel) async {
    print(formModel.comments?.length);
    comments = formModel.comments!.toList();
    print(comments.length);
    comments.add(CommentModel(
      userID: Constants.userModel?.userId,
      comment: commentsController.text,
    ));
    await formModel.formReference?.update({
      'comments': List.generate(
        comments.length,
        (index) => comments[index].toMap(),
      )
    });
  }

  Future signTheForm(
    FormModel form,
    BuildContext context,
  ) async {
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
      bool isLastRequiredEmail = false;
      form.signedBy!.add(SignatureModel(
        email: Constants.userModel?.email ?? 'No Email',
        name: Constants.userModel?.name ?? 'No Name',
        signatureLink: Constants.userModel?.mainSignature ?? 'No Signature',
      ));
      List<Map<String, dynamic>> signedByMeList = List.generate(
        form.signedBy?.length ?? 0,
        (index) => form.signedBy![index].toMap(),
      );
      if (form.sentTo!.length == form.signedBy!.length) {
        isLastRequiredEmail = true;
        await FirebaseFirestore.instance
            .collection('fullySignedForms')
            .add({'ref': form.formReference});
      }
      await form.formReference!.update({
        'signedBy': signedByMeList,
        'isFullySigned': isLastRequiredEmail,
      });
      if (isLastRequiredEmail && form.formName!.contains('PaymentRequest')) {
        List<String> financeEmails = await getFinanceTeam();
        print(financeEmails);
        for (String financeEmail in financeEmails) {
          await AppFunctions.sendEmailToFinance(
              title: form.formTitle ?? '',
              toEmail: financeEmail,
              fromEmail: form.sentBy ?? '');
        }
      }
      if (form.sentTo!.length != form.signedBy!.length) {
        await AppFunctions.sendEmailTo(
            toEmail: form.sentTo?[form.signedBy?.length ?? 0] ?? '',
            fromEmail: form.sentBy ?? '');
      }
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Sign Error: $e');
    }
  }
  late bool isValidToSign;
  bool checkIfValidToSign(FormModel form) {

    for (int i = 0; i < form.sentTo!.length; i++) {
      if (Constants.userModel!.email == form.sentTo![i] && i == 0) {
        isValidToSign = true;
        return isValidToSign;
      } else if (Constants.userModel!.email == form.sentTo![i]) {
        if (form.signedBy!.length == i) {
          isValidToSign = true;
          return isValidToSign;
        } else {
          isValidToSign = false;
          return isValidToSign;
        }
      }
    }
    return isValidToSign;
  }
  Future<void> deleteSentDocument({
    required String formID,
    required FormModel formModel,
    required userId,
    required List<String> emailsToRemoveFrom,
  }) async {
    for (String email in emailsToRemoveFrom) {
      DocumentReference formDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('received_forms')
          .doc(formID);

      await formDocRef.delete().then((_) {}).catchError((error) {});
      emit(DeletedSuccessfully());
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sent_forms')
        .doc(formID)
        .delete();
    await FirebaseFirestore.instance
        .collection('sentForms')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        if (element.data()['ref'] == formModel.formReference) {
          await FirebaseFirestore.instance
              .collection('sentForms')
              .doc(element.id)
              .delete();
        }
      }
    });
    emit(DeletedSuccessfully());
    getSentForms(Constants.userModel!.email!);
  }

  List<FormModel> fullSignedList = [];

  void getSentForms(String userId) async {
    emit(LoadingSentForms());
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
        await receivedFormRef.get().then((onValue) {
          var form = FormModel.fromJson(onValue.data());
          bool isValid= checkIfValidToSign(form);
          if (form.signedBy?.any(
                  (element) => element.email == Constants.userModel?.email) ??
              false) {
            signedByMe.add(form);
          } else {
            if (isValid) {
              receivedForms.add(form);
            }
          }
        });
      }
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
}

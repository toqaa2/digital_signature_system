import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:signature_system/src/features/requests/presentation/manager/requests_cubit.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/received_requests/received_requests_view.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/view_single_page_with_signature.dart';

class SignTheDocumentWidget extends StatefulWidget {
  const SignTheDocumentWidget(
      {super.key,
      required this.document,
      required this.index,
      required this.paintKey,
      required this.formModel,
      required this.cubit});

  final FormModel formModel;

  final GlobalKey<State<StatefulWidget>> paintKey;
  final Uint8List document;
  final int index;
  final RequestsCubit cubit;

  @override
  State<SignTheDocumentWidget> createState() => _SignTheDocumentWidgetState();
}

class _SignTheDocumentWidgetState extends State<SignTheDocumentWidget> {
  bool showSignature = false;
  final SignatureModel signatureModel = SignatureModel(
    page: 0,
    scale: 100,
    signatureY: 100,
    signatureX: 100,
  );
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    signatureModel.page = widget.index;
    widgets = AppFunctions.viewSignatures(widget.formModel, widget.index);
  }

  Future<void> _moveDown(num increase, DragUpdateDetails details) async {
    setState(() {
      scrollController.animateTo(scrollController.offset + increase,
          curve: Curves.linear, duration: Duration(milliseconds: 500));
      signatureModel.signatureY += 3;
    });
    await Future.delayed(Duration(minutes: 2));
  }

  bool rescale = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonWidget(
          isHollow: true,
          borderColor: AppColors.mainColor,
          buttonColor: Colors.white,
          verticalMargin: 2,
          minWidth: 200,
          height: 35,
          textStyle: TextStyle(
              fontSize: 10,
              color: !showSignature ? AppColors.mainColor : Colors.redAccent),
          text: !showSignature
              ? "Add Signature to this Page"
              : "Remove Signature from this Page",
          onTap: () {
            signatureModel.page = widget.index;
            setState(() {
              showSignature = !showSignature;
              if (showSignature) {
                widget.cubit.signatureSet.add(signatureModel);
              }
              if (!showSignature) {
                widget.cubit.signatureSet.remove(signatureModel);
              }
            });
          },
        ),
        Stack(
          children: <Widget>[
            ViewSinglePageWithSignature(
              formModel: widget.formModel,
              documentBytes: widget.document,
              page: widget.index,
            ),
            if (showSignature)
              Positioned(
                left: signatureModel.signatureX.toDouble(),
                top: signatureModel.signatureY.toDouble(),
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      rescale = !rescale;
                    });
                  },
                  onPanEnd: (details) {
                    widget.cubit.signatureSet.add(signatureModel);
                  },
                  onPanUpdate: (details) async {
                    if (details.globalPosition.dy >
                        MediaQuery.of(context).size.height - 40) {
                      await _moveDown(100, details);
                    }
                    if (signatureModel.signatureY <= 1377 &&
                        signatureModel.signatureY >= 0) {
                      setState(() {
                        signatureModel.signatureX += details.delta.dx;
                        signatureModel.signatureY += details.delta.dy;
                      });
                    } else if (signatureModel.signatureY > 1377) {
                      setState(() {
                        signatureModel.signatureY = 1377;
                      });
                    } else if (signatureModel.signatureY < 0) {
                      setState(() {
                        signatureModel.signatureY = 0;
                      });
                    }
                    if (signatureModel.signatureX > 1000) {
                      setState(() {
                        signatureModel.signatureX = 1000;
                      });
                    } else if (signatureModel.signatureX < 0) {
                      setState(() {
                        signatureModel.signatureX = 0;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      if (rescale)
                        Slider(
                          value: signatureModel.scale.toDouble(),
                          min: 1,
                          max: 400,
                          onChangeEnd: (value) {
                            widget.cubit.signatureSet.add(signatureModel);
                            setState(() {
                              rescale = false;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              signatureModel.scale = value;
                            });
                          },
                        ),
                      Image.network(
                        width: signatureModel.scale.toDouble(),
                        height: signatureModel.scale.toDouble() / 2,
                        Constants.userModel?.mainSignature ?? '',
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

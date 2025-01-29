import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  final List<String> stepNames = ['Choose From', 'Fill From', 'Send Request'];
  final List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
  String? selectedItem;
  int currentStep = 0;

  void selectItem(String? newValue) {
    selectedItem = newValue!;
    emit(ChangeValue());
  }
  void changeStepPrev() {
    currentStep--;
    emit(ChangeStepPrev());
  }
  void changeStepNext() {
    currentStep++;
    emit(ChangeStepNext());
  }
}

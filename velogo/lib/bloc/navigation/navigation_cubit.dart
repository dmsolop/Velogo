import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void selectTab(NavigationTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }
}

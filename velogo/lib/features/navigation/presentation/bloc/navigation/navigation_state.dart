import 'package:equatable/equatable.dart';
import '../../../domain/entities/navigation_entity.dart';

class NavigationState extends Equatable {
  final NavigationTab selectedTab;

  const NavigationState({this.selectedTab = NavigationTab.home});

  NavigationState copyWith({NavigationTab? selectedTab}) {
    return NavigationState(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object> get props => [selectedTab];
}

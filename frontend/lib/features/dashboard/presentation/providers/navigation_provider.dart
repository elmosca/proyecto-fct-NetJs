import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_provider.freezed.dart';
part 'navigation_provider.g.dart';

@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default('/app/dashboard') String currentRoute,
    @Default([]) List<Breadcrumb> breadcrumbs,
    @Default(0) int currentIndex,
  }) = _NavigationState;
}

@freezed
class Breadcrumb with _$Breadcrumb {
  const factory Breadcrumb({
    required String title,
    required String route,
    @Default(false) bool isActive,
  }) = _Breadcrumb;
}

@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  @override
  NavigationState build() {
    return const NavigationState();
  }

  void setCurrentRoute(String route, List<Breadcrumb> breadcrumbs) {
    state = state.copyWith(
      currentRoute: route,
      breadcrumbs: breadcrumbs,
    );
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void addBreadcrumb(Breadcrumb breadcrumb) {
    final updatedBreadcrumbs = [...state.breadcrumbs, breadcrumb];
    state = state.copyWith(breadcrumbs: updatedBreadcrumbs);
  }

  void clearBreadcrumbs() {
    state = state.copyWith(breadcrumbs: []);
  }
}

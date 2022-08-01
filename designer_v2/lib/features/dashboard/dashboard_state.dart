import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer_v2/features/dashboard/studies_filter.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class DashboardState extends Equatable {
  static const defaultFilter = StudiesFilter.owned;

  const DashboardState({
    this.studies = const AsyncValue.loading(),
    this.studiesFilter = defaultFilter,
    required this.currentUser,
  });

  /// The list of studies that can be accessed by the current user
  /// Wrapped in an [AsyncValue] to represent loading / error states
  final AsyncValue<List<Study>> studies;

  /// Currently selected filter to be applied to the list of studies
  /// in order to determine the [visibleStudies]
  final StudiesFilter studiesFilter;

  /// Currently authenticated user (used for filtering studies)
  final User currentUser;

  /// The currently visible list of studies as by the selected filter
  ///
  /// Wrapped in an [AsyncValue] that mirrors the [studies]' async states,
  /// but resolves to a different subset of studies based on the [studiesFilter]
  AsyncValue<List<Study>> get visibleStudies {
    return studies.when(
        data: (studies) => AsyncValue.data(_filterAndSortStudies(studies)),
        error: (error, _) => AsyncValue.error(error),
        loading: () => const AsyncValue.loading(),
    );
  }

  List<Study> _filterAndSortStudies(List<Study> studies) {
    final filteredStudies = studiesFilter.apply(
        studies: studies, user: currentUser).toList();
    filteredStudies.sort(
            (study, other) => study.title!.compareTo(other.title!));
    return filteredStudies;
  }

  DashboardState copyWith({
    AsyncValue<List<Study>> Function()? studies,
    StudiesFilter Function() ? studiesFilter,
    User Function() ? currentUser,
  }) {
    return DashboardState(
      studies: studies != null ? studies() : this.studies,
      studiesFilter: studiesFilter != null ? studiesFilter() : this.studiesFilter,
      currentUser: currentUser != null ? currentUser() : this.currentUser,
    );
  }

  // - Equatable

  @override
  List<Object?> get props => [studies, studiesFilter];
}

extension DashboardStateSafeViewProps on DashboardState {
  String get visibleListTitle {
    switch(studiesFilter) {
      case StudiesFilter.public:
        return "Study registry".hardcoded;
      case StudiesFilter.owned:
        return "My studies".hardcoded;
      case StudiesFilter.shared:
        return "Shared with me".hardcoded;
      case StudiesFilter.all:
        return "All studies".hardcoded;
    }
  }
}
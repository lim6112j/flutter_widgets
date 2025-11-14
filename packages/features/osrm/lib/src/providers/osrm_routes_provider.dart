import 'package:riverpod/riverpod.dart';
import '../repository/osrm_routes_repository.dart';
import '../models/osrm_location.dart';
import '../models/osrm_route_resopnse.dart';
import '../models/osrm_result.dart';

// Repository provider
final osrmRoutesRepositoryProvider = Provider<OSRMRoutesRepository>((ref) {
  return OSRMRoutesRepository();
});

// State class for route data
class OsrmRoutesState {
  final bool isLoading;
  final String? error;
  final OsrmRouteResponse? routeResponse;
  final List<OsrmRoute> routes;

  const OsrmRoutesState({
    this.isLoading = false,
    this.error,
    this.routeResponse,
    this.routes = const [],
  });

  OsrmRoutesState copyWith({
    bool? isLoading,
    String? error,
    OsrmRouteResponse? routeResponse,
    List<OsrmRoute>? routes,
  }) {
    return OsrmRoutesState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      routeResponse: routeResponse ?? this.routeResponse,
      routes: routes ?? this.routes,
    );
  }
}

// StateNotifier for managing route state
class OsrmRoutesNotifier extends StateNotifier<OsrmRoutesState> {
  final OSRMRoutesRepository _repository;

  OsrmRoutesNotifier(this._repository) : super(const OsrmRoutesState());

  Future<void> getRoutes(List<OsrmLocation> locations) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getRoutes(locations);

      if (result.isSuccess && result.data != null) {
        state = state.copyWith(
          isLoading: false,
          routeResponse: result.data,
          routes: result.data!.routes ?? [],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error ?? 'Failed to get routes',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  Future<void> getOptimalRoutes(
    List<OsrmLocation> locations, {
    int maxRoutes = 3,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getOptimalRoutes(
        locations,
        maxRoutes: maxRoutes,
      );

      if (result.isSuccess && result.data != null) {
        state = state.copyWith(
          isLoading: false,
          routes: result.data!,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error ?? 'Failed to get optimal routes',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  void reset() {
    state = const OsrmRoutesState();
  }
}

// StateNotifierProvider for route management
final osrmRoutesProvider =
    StateNotifierProvider<OsrmRoutesNotifier, OsrmRoutesState>((ref) {
  final repository = ref.read(osrmRoutesRepositoryProvider);
  return OsrmRoutesNotifier(repository);
});

// FutureProvider for one-time route fetching
final osrmRoutesFutureProvider =
    FutureProvider.family<RouteResult<OsrmRouteResponse>, List<OsrmLocation>>(
        (ref, locations) async {
  final repository = ref.read(osrmRoutesRepositoryProvider);
  return repository.getRoutes(locations);
});

// FutureProvider for optimal routes
final osrmOptimalRoutesFutureProvider = FutureProvider.family<
    RouteResult<List<OsrmRoute>>,
    ({List<OsrmLocation> locations, int maxRoutes})>((ref, params) async {
  final repository = ref.read(osrmRoutesRepositoryProvider);
  return repository.getOptimalRoutes(params.locations,
      maxRoutes: params.maxRoutes);
});

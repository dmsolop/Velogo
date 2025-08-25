import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/exceptions.dart';
import '../models/route_model.dart';

abstract class RouteRemoteDataSource {
  Future<List<RouteModel>> getAllRoutes();
  Future<RouteModel> getRouteById(String routeId);
  Future<List<RouteModel>> getRoutesByUserId(String userId);
  Future<List<RouteModel>> getPublicRoutes();
  Future<RouteModel> createRoute(RouteModel route);
  Future<RouteModel> updateRoute(RouteModel route);
  Future<void> deleteRoute(String routeId);
  Future<RouteModel> createAutomaticRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    required String difficulty,
    required double distance,
    String? userId,
  });
}

class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  final FirebaseFirestore firestore;

  RouteRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<RouteModel>> getAllRoutes() async {
    try {
      final querySnapshot = await firestore.collection('routes').get();
      return querySnapshot.docs.map((doc) => RouteModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get routes: $e');
    }
  }

  @override
  Future<RouteModel> getRouteById(String routeId) async {
    try {
      final doc = await firestore.collection('routes').doc(routeId).get();
      if (!doc.exists) {
        throw ServerException('Route not found');
      }
      return RouteModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to get route: $e');
    }
  }

  @override
  Future<List<RouteModel>> getRoutesByUserId(String userId) async {
    try {
      final querySnapshot = await firestore.collection('routes').where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => RouteModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get user routes: $e');
    }
  }

  @override
  Future<List<RouteModel>> getPublicRoutes() async {
    try {
      final querySnapshot = await firestore.collection('routes').where('isPublic', isEqualTo: true).get();
      return querySnapshot.docs.map((doc) => RouteModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get public routes: $e');
    }
  }

  @override
  Future<RouteModel> createRoute(RouteModel route) async {
    try {
      final docRef = await firestore.collection('routes').add(route.toFirestore());
      final doc = await docRef.get();
      return RouteModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to create route: $e');
    }
  }

  @override
  Future<RouteModel> updateRoute(RouteModel route) async {
    try {
      await firestore.collection('routes').doc(route.id).update(route.toFirestore());
      return await getRouteById(route.id);
    } catch (e) {
      throw ServerException('Failed to update route: $e');
    }
  }

  @override
  Future<void> deleteRoute(String routeId) async {
    try {
      await firestore.collection('routes').doc(routeId).delete();
    } catch (e) {
      throw ServerException('Failed to delete route: $e');
    }
  }

  @override
  Future<RouteModel> createAutomaticRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    required String difficulty,
    required double distance,
    String? userId,
  }) async {
    try {
      // TODO: Implement automatic route creation logic
      // This would integrate with external routing services
      final route = RouteModel(
        id: '',
        name: 'Auto Route',
        description: 'Automatically generated route',
        coordinates: [startPoint, endPoint],
        totalDistance: distance,
        totalElevationGain: 0.0,
        averageDifficulty: 0.0,
        difficulty: difficulty,
        sections: [],
        pointsOfInterest: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: userId,
        isPublic: false,
        isFavorite: false,
      );

      return await createRoute(route);
    } catch (e) {
      throw ServerException('Failed to create automatic route: $e');
    }
  }
}

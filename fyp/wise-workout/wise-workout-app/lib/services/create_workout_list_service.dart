import 'package:flutter/foundation.dart';
import 'create_workout_plan_service.dart';

/// A simple state holder (MVC-friendly) that loads and exposes the user's plans.
/// You can use this with a StatefulWidget (addListener/removeListener) or a
/// ChangeNotifierProvider if you prefer Provider/Riverpod later.
class CreateWorkoutListService extends ChangeNotifier {
  final CreateWorkoutPlanService _planService;

  CreateWorkoutListService({CreateWorkoutPlanService? service})
      : _planService = service ?? CreateWorkoutPlanService();

  bool _loading = false;
  String? _error;
  List<WorkoutPlan> _plans = [];

  bool get loading => _loading;
  String? get error => _error;
  List<WorkoutPlan> get plans => List.unmodifiable(_plans);

  Future<void> loadPlans() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _planService.getMyPlans();
      _plans = data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadPlans();

  /// Convenience passthroughs if you want to manage from this layer:

  Future<WorkoutPlan> createPlan(String title) async {
    final p = await _planService.createPlan(planTitle: title);
    await loadPlans();
    return p;
  }

  Future<void> deletePlan(int planId) async {
    await _planService.deletePlan(planId);
    _plans.removeWhere((p) => p.planId == planId);
    notifyListeners();
  }

  Future<List<WorkoutPlanItem>> getItems(int planId) {
    return _planService.getPlanItems(planId);
  }

  // Optional add item helpers if your backend exposes them
  Future<int> addOneItem({
    required int planId,
    required WorkoutPlanItem item,
  }) async {
    final id = await _planService.addOneItem(planId: planId, item: item);
    return id;
  }

  Future<int> addItemsBulk({
    required int planId,
    required List<WorkoutPlanItem> items,
  }) async {
    final count = await _planService.addItemsBulk(planId: planId, items: items);
    return count;
  }
}

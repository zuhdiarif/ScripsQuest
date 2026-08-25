import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/thesis_journey_model.dart';
import 'package:raion_hackjam/data/repositories/journey_repository.dart';

class OnboardingViewModel extends ChangeNotifier {
  final JourneyRepository _journeyRepository;

  bool _isLoading = false;
  String? _errorMessage;
  ThesisStage? _selectedStage;
  String _topic = '';
  String _currentGoal = '';
  int _currentStep = 0;

  OnboardingViewModel(this._journeyRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ThesisStage? get selectedStage => _selectedStage;
  String get topic => _topic;
  String get currentGoal => _currentGoal;
  int get currentStep => _currentStep;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setStage(ThesisStage stage) {
    _selectedStage = stage;
    notifyListeners();
  }

  void setTopic(String topic) {
    _topic = topic;
    notifyListeners();
  }

  void setGoal(String goal) {
    _currentGoal = goal;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 5) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void reset() {
    _selectedStage = null;
    _topic = '';
    _currentGoal = '';
    _currentStep = 0;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<ThesisJourneyModel?> submitJourney(String userId) async {
    if (_selectedStage == null) {
      _errorMessage = 'Thesis stage is required';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final journey = ThesisJourneyModel(
        id: '',
        userId: userId,
        stage: _selectedStage!,
        topic: _topic.isEmpty ? null : _topic,
        currentGoal: _currentGoal,
        status: JourneyStatus.active,
        createdAt: DateTime.now(),
      );

      final createdJourney = await _journeyRepository.createJourney(journey);
      _isLoading = false;
      notifyListeners();
      return createdJourney;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}

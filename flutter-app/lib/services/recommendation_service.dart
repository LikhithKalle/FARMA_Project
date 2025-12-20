import '../models/farmer_context.dart';
import '../models/recommendation.dart';

class RecommendationService {
  /// Mock function to get crop recommendations.
  ///
  /// In a real app, this would make a network request to a backend AI service.
  Future<List<Recommendation>> getRecommendations(FarmerContext context) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock logic: Return a fixed list of recommendations for demonstration.
    // In a real implementation, the recommendations would be based on the
    // provided FarmerContext.
    return [
      Recommendation(
        cropName: 'Paddy (Rice)',
        suitabilityExplanation: 'The soil and water availability in your area are ideal for Paddy cultivation during this season.',
        waterRequirement: 'High',
        riskLevel: RiskLevel.Low,
      ),
      Recommendation(
        cropName: 'Maize',
        suitabilityExplanation: 'Maize is a good alternative crop for your region, requiring less water than Paddy.',
        waterRequirement: 'Medium',
        riskLevel: RiskLevel.Low,
      ),
      Recommendation(
        cropName: 'Cotton',
        suitabilityExplanation: 'Cotton can be a profitable cash crop, but is susceptible to pests and requires careful management.',
        waterRequirement: 'Medium',
        riskLevel: RiskLevel.Medium,
      ),
    ];
  }
}

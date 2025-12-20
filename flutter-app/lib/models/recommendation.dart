enum RiskLevel { Low, Medium, High }

class Recommendation {
  final String cropName;
  final String suitabilityExplanation;
  final String waterRequirement;
  final RiskLevel riskLevel;

  Recommendation({
    required this.cropName,
    required this.suitabilityExplanation,
    required this.waterRequirement,
    required this.riskLevel,
  });
}

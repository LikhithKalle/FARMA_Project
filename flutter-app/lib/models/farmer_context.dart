class FarmerContext {
  String? district;
  String? state;
  String? soilType;
  String? season;
  double? landArea;
  bool? hasIrrigation;

  FarmerContext({
    this.district,
    this.state,
    this.soilType,
    this.season,
    this.landArea,
    this.hasIrrigation,
  });

  /// A method to check if the context is complete and valid before submission.
  bool get isComplete {
    return district != null &&
        state != null &&
        soilType != null &&
        season != null &&
        landArea != null &&
        hasIrrigation != null;
  }
}

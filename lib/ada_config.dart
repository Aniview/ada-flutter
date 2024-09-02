class AdaConfig {
  final String publisherId;
  final String tagId;
  final String? environment;
  final bool? enableAutoRefresh;

  const AdaConfig({
    required this.publisherId,
    required this.tagId,
    this.environment,
    this.enableAutoRefresh,
  });
}

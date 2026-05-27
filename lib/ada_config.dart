///
/// Configuration object for the placement.
///
class AdaConfig {
  ///
  /// Publisher ID used to load ads.
  ///
  final String publisherId;

  ///
  /// Tag ID used to load ads.
  ///
  final String tagId;

  ///
  /// Override environment from which to load ads.
  ///
  final String? environment;

  ///
  /// Enable ads auto refresh.
  ///
  final bool? enableAutoRefresh;

  ///
  /// Controls how AD content should be scaled in the placement.
  ///
  final AdaScaleType? scaleType;

  ///
  /// Package name used for requesting ADs and analytics.
  ///
  final String? packageName;

  ///
  /// Additional macros that will be passed to the player.
  ///
  final Map<String, String>? macros;

  const AdaConfig({
    required this.publisherId,
    required this.tagId,
    this.environment,
    this.enableAutoRefresh,
    this.scaleType,
    this.packageName,
    this.macros,
  });
}

///
/// Options for scaling the bounds of the content to the bounds of the parent.
///
enum AdaScaleType {
  ///
  /// Scale in X and Y independently, so that src matches dst exactly. This may change the aspect ratio of the src.
  ///
  fill,

  ///
  /// Center the content in the parent, but perform no scaling.
  ///
  center,

  ///
  /// Scale the content uniformly (maintain aspect ratio) so that both dimensions (width and height)
  /// of the content will be equal to or larger than the corresponding dimension of the parent.
  ///
  centerCrop,

  ///
  /// Scale the content uniformly (maintain aspect ratio) so that both dimensions (width and height)
  /// of the content will be equal to or less than the corresponding dimension of the parent.
  ///
  centerInside,
}

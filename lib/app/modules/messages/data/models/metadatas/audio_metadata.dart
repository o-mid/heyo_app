class AudioMetadata {
  static const durationInSecondsSerializedName = 'durationInSeconds';

  final int durationInSeconds;
  AudioMetadata({required this.durationInSeconds});

  factory AudioMetadata.fromJson(Map<String, dynamic> json) => AudioMetadata(
        durationInSeconds: json[durationInSecondsSerializedName] as int,
      );

  Map<String, dynamic> toJson() => {
        durationInSecondsSerializedName: durationInSeconds,
      };
}

abstract class Metadata {}

class AudioMetadata extends Metadata {
  final int durationInSeconds;
  AudioMetadata({required this.durationInSeconds});
}

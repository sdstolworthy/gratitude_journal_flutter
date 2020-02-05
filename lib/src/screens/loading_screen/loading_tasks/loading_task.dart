abstract class LoadingTask {
  Future<void> execute();

  final String loadingText;
  LoadingTask(this.loadingText);
}
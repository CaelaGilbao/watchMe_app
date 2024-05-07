import 'dart:async';

class BottomNavBarBloc {
  final StreamController<int> _indexController = StreamController<int>();

  Stream<int> get indexStream => _indexController.stream;

  void updateIndex(int index) {
    _indexController.sink.add(index);
  }

  void dispose() {
    _indexController.close();
  }
}

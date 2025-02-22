import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

mixin PhotoDataProvider on ChangeNotifier {
  /// current gallery album
  final currentPathNotifier = ValueNotifier<AssetPathEntity?>(null);
  AssetPathEntity? _current;
  AssetPathEntity? get currentPath => _current;
  set currentPath(AssetPathEntity? current) {
    if (_current != current) {
      _current = current;
      currentPathNotifier.value = current;
    }
  }

  /// save path in list
  List<AssetPathEntity> pathList = [];
  final pathListNotifier = ValueNotifier<List<AssetPathEntity>>([]);

  /// order path by date
  static int _defaultSort(
    AssetPathEntity a,
    AssetPathEntity b,
  ) {
    if (a.isAll) {
      return -1;
    }
    if (b.isAll) {
      return 1;
    }
    return 0;
  }

  /// add assets to a list
  void resetPathList(
    List<AssetPathEntity> list, {
    int defaultIndex = 0,
    int Function(
      AssetPathEntity a,
      AssetPathEntity b,
    )
        sortBy = _defaultSort,
  }) {
    list.sort(sortBy);
    pathList.clear();
    pathList.addAll(list);
    currentPath = list.isNotEmpty ? list[defaultIndex] : null;
    pathListNotifier.value = pathList;
    notifyListeners();
  }
}

class PickerDataProvider extends ChangeNotifier with PhotoDataProvider {
  /// Notification when max is modified.
  final maxNotifier = ValueNotifier(14);

  static var obs;
  int get max => maxNotifier.value;
  set max(int value) => maxNotifier.value = value;
  final onPickMax = ChangeNotifier();

  bool singlePickMode = false;

  /// pick asset entity
  /// notify changes
  final pickedNotifier = ValueNotifier<List<AssetEntity>>([]);
  List<AssetEntity> picked = [];
  void pickEntity(AssetEntity entity) {
    if (singlePickMode) {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        picked.clear();
        picked.add(entity);
      }
    } else {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        if (picked.length == max) {
          onPickMax.notifyListeners();
          return;
        }
        picked.add(entity);
      }
    }
    pickedNotifier.value = picked;
    pickedNotifier.notifyListeners();
    notifyListeners();
  }

  /// metadata map
  final pickedFileNotifier = ValueNotifier<List<Map<String, dynamic>>>([{}]);
  List<Map<String, dynamic>> pickedFile = [];
  void pickPath(Map<String, dynamic> path) {
    if (singlePickMode) {
      if (pickedFile
          .where((element) => element['id'] == path['id'])
          .isNotEmpty) {
        pickedFile.removeWhere((val) => val['id'] == path['id']);
      } else {
        pickedFile.clear();
        pickedFile.add(path);
      }
    } else {
      if (pickedFile
          .where((element) => element['id'] == path['id'])
          .isNotEmpty) {
        pickedFile.removeWhere((val) => val['id'] == path['id']);
      } else {
        if (pickedFile.length == max) {
          onPickMax.notifyListeners();
          return;
        }
        pickedFile.add(path);
      }
    }
    pickedFileNotifier.value = pickedFile;
    pickedFileNotifier.notifyListeners();
    notifyListeners();
  }

  /// picked path index
  int pickIndex(AssetEntity entity) {
    return picked.indexOf(entity);
  }
}

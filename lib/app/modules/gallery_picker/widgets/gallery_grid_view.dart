import 'package:flutter/material.dart';
import 'package:heyo/app/modules/gallery_picker/provider/gallery_provider.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/thumbnail_widget.dart';
import 'package:photo_manager/photo_manager.dart';

typedef OnAssetItemClick = void Function(BuildContext context, AssetEntity entity, int index);

class GalleryGridView extends StatefulWidget {
  /// asset album
  final AssetPathEntity? path;

  /// load if scrolling is false
  final bool loadWhenScrolling;

  /// on tap thumbnail
  final OnAssetItemClick? onAssetItemClick;

  /// picker data provider
  final PickerDataProvider provider;

  /// gallery gridview crossAxisCount
  final int crossAxisCount;

  /// gallery gridview aspect ratio
  final double childAspectRatio;

  /// gridView background color
  final Color gridViewBackgroundColor;

  /// gridView Padding
  final EdgeInsets? padding;

  /// gridView physics
  final ScrollPhysics? gridViewPhysics;

  /// gridView controller
  final ScrollController? gridViewController;

  /// selected background color
  final Color selectedBackgroundColor;

  /// selected check color
  final Color selectedCheckColor;

  /// selected Check Background Color
  final Color selectedCheckBackgroundColor;

  /// background image color
  final Color imageBackgroundColor;

  /// thumbnail box fit
  final BoxFit thumbnailBoxFix;

  /// image quality thumbnail
  final int? thumbnailQuality;

  const GalleryGridView(
      {Key? key,
      required this.path,
      required this.provider,
      this.onAssetItemClick,
      this.loadWhenScrolling = false,
      this.childAspectRatio = 0.5,
      this.gridViewBackgroundColor = Colors.white,
      this.crossAxisCount = 3,
      this.padding,
      this.gridViewController,
      this.gridViewPhysics,
      this.selectedBackgroundColor = Colors.black,
      this.selectedCheckColor = Colors.white,
      this.imageBackgroundColor = Colors.white,
      this.thumbnailBoxFix = BoxFit.cover,
      this.selectedCheckBackgroundColor = Colors.white,
      this.thumbnailQuality = 200})
      : super(key: key);

  @override
  _GalleryGridViewState createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends State<GalleryGridView> {
  static Map<int?, AssetEntity?> _createMap() {
    return {};
  }

  /// create cache for images
  var cacheMap = _createMap();

  /// notifier for scroll events
  final scrolling = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    /// generate thumbnail grid view
    return widget.path != null
        ? NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: Container(
              color: widget.gridViewBackgroundColor,
              child: GridView.builder(
                key: ValueKey(widget.path),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: widget.gridViewPhysics ?? const ScrollPhysics(),
                controller: widget.gridViewController ?? ScrollController(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: widget.childAspectRatio,
                  crossAxisCount: widget.crossAxisCount,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),

                /// render thumbnail
                itemBuilder: (context, index) => _buildItem(context, index, widget.provider),
                itemCount: 0,
                addRepaintBoundaries: true,
              ),
            ),
          )
        : Container();
  }

  Widget _buildItem(BuildContext context, index, PickerDataProvider provider) {
    return GestureDetector(
      /// on tap thumbnail
      onTap: () async {
        AssetEntity asset = cacheMap[index] as AssetEntity;
        if (asset == null) {
          asset = (await widget.path!.getAssetListRange(start: index as int, end: index + 1))[0];
          cacheMap[index] = asset;
        }
        ;
        widget.onAssetItemClick?.call(context, asset, index);
      },

      /// render thumbnail
      child: _buildScrollItem(context, index as int, provider),
    );
  }

  Widget _buildScrollItem(BuildContext context, int index, PickerDataProvider provider) {
    /// load cache images
    final asset = cacheMap[index];
    if (asset != null) {
      return ThumbnailWidget(
        asset: asset as AssetEntity,
        provider: provider,
        index: index,
        thumbnailQuality: widget.thumbnailQuality!,
        selectedBackgroundColor: widget.selectedBackgroundColor,
        selectedCheckColor: widget.selectedCheckColor,
        imageBackgroundColor: widget.imageBackgroundColor,
        thumbnailBoxFix: widget.thumbnailBoxFix,
        selectedCheckBackgroundColor: widget.selectedCheckBackgroundColor,
      );
    } else {
      /// read the assets from selected album
      return FutureBuilder<List<AssetEntity>>(
        future: widget.path!.getAssetListRange(start: index, end: index + 1),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: widget.gridViewBackgroundColor,
            );
          }
          final asset = snapshot.data![0];
          cacheMap[index] = asset;

          /// thumbnail widget
          return ThumbnailWidget(
            asset: asset,
            index: index,
            provider: provider,
            thumbnailQuality: widget.thumbnailQuality!,
            selectedBackgroundColor: widget.selectedBackgroundColor,
            selectedCheckColor: widget.selectedCheckColor,
            imageBackgroundColor: widget.imageBackgroundColor,
            thumbnailBoxFix: widget.thumbnailBoxFix,
            selectedCheckBackgroundColor: widget.selectedCheckBackgroundColor,
          );
        },
      );
    }
  }

  /// scroll notifier
  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      scrolling.value = false;
    } else if (notification is ScrollStartNotification) {
      scrolling.value = true;
    }
    return false;
  }

  /// update widget on scroll
  @override
  void didUpdateWidget(GalleryGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      cacheMap.clear();
      scrolling.value = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}

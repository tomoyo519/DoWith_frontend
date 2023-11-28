import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MyRoomViewModel with ChangeNotifier {
  int _roomOwner = 0;

  final Map<String, AssetImage> _backgrounds = {
    'bg1': AssetImage('assets/background.png'),
    'bg2': AssetImage('assets/wallpaper.jpg'),
    'bg3': AssetImage('assets/background4.png'),
  };

  // TODO get assets from DB
  final Map<String, dynamic> _assets = {
    'fish': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/koi_fish.glb',
      alt: 'koi fish',
      autoPlay: true,
      disableZoom: true,
      cameraControls: false,
      animationName: 'morphBake',
      cameraOrbit: '30deg 60deg 0m',
      cameraTarget: '4m 6m 2m',
    ),
    'astronaut': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/koi_fish.glb',
      alt: 'astronaut',
      // autoRotate: true,
      autoPlay: true,
      disableZoom: true,
      cameraControls: false,
      // animationName: "walk",
      cameraOrbit: "40deg 60eg 0m",
      // theta, phi, radius
      cameraTarget: "0.5m 1.5m 2m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
    ),
    'robot': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/robot_walk_idle.usdz',
      alt: 'robot',
      // autoRotate: true,
      autoPlay: true,
      disableZoom: true,
      cameraControls: false,
      animationName: "walk",
      cameraOrbit: "30deg 60deg 0m",
      // theta, phi, radius
      cameraTarget: "1m 4m 4m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
    ),
    'animals': ModelViewer(
      // loading: Loading.eager,
      // shadowIntensity: 1,
      src: 'assets/aa.glb',
      alt: 'animals',
      // autoRotate: true,
      autoPlay: true,
      disableZoom: true,
      // cameraControls: false,
      // animationName: "walk",
      cameraOrbit: "30deg 30deg 2m",
      // theta, phi, radius
      cameraTarget: "2m 2m 2m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
    ),
    'cat': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/cat.glb',
      alt: 'cuttest pet ever',
      // autoRotate: true,
      autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      cameraOrbit: "30deg,180deg, 0m",
      cameraTarget: "0m 300m 300m",
      disableZoom: true,
    ),
    'kitsune': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/kitsune.glb',
      alt: 'kitsune',
      // autoRotate: true,
      autoPlay: true,
      animationName: "walk",
      cameraOrbit: "30deg, 0deg, 0m",
      cameraTarget: "0m 1m 0.4m",
      disableZoom: true,
    ),
    'kitsune_ani': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/kitsune_ani.glb',
      alt: 'kitsune',
      // autoRotate: true,
      // autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      cameraOrbit: "330deg, 0deg, 0m",
      cameraTarget: "0m 2m 1m",
      disableZoom: true,
    ),
    'small_fox': ModelViewer(
      loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/small_fox.glb',
      alt: 'kitsune',
      // autoRotate: true,
      autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      animationName: "Jump",
      cameraTarget: "0.3m 1.1m 0.7m",
      interactionPrompt: InteractionPrompt.none,
      cameraOrbit: "330deg,0deg, 0m",
      disableZoom: true,
    ),
    'mid_fox': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/mid_fox.glb',
      alt: 'kitsune',
      // autoRotate: true,
      autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      cameraTarget: "0m 0.8m 0.4m",
      animationName: "Idle_A",
      cameraOrbit: "30deg, 150deg, 0m",
      interactionPrompt: InteractionPrompt.none,
      disableZoom: true,
    ),
  };

  set roomOwner(int roomOwnerId) {
    _roomOwner = roomOwnerId;
  }

  bool isMyRoom() => _roomOwner == 0;

  // 방에 놓을 오브젝트들
  List<Widget> getObjects() {
    if (isMyRoom()) {
      return [_assets['small_fox']!];
    } else {
      return [_assets['small_fox'], _assets['mid_fox']!];
    }
  }

  AssetImage getBackground() {
    if (isMyRoom()) {
      return _backgrounds['bg1']!;
    } else {
      return _backgrounds['bg2']!;
    }
  }
}

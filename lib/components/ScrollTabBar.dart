import 'package:flutter/material.dart';

typedef TabBuilder = Widget Function(BuildContext context, int index, bool select);
typedef DividerBuilder = Widget Function(BuildContext context);

/// tab 点击后动画交互模式
enum TabAnimMode {
  none, // 0 无动画
  middle, // 1 被点击 tab 居中
}

/// 可滑动 TabBar
class ScrollTabBar extends StatefulWidget {
  final int tabCount;
  final int visibleCount;
  final int currentIndex;

  final double width;
  final double height;
  final Color backgroundColor;
  final TabAnimMode animMode;

  final TabBuilder tabBuilder;
  final Function(int index)? onTabClick;
  final DividerBuilder? dividerBuilder;
  final ScrollTabBarController? controller;

  /// [visibleCount] 展示数量【实际可见数量 + 半个】
  /// [tabBuilder] tab构建函数
  /// [dividerBuilder] TabBar 最下端分隔 divider
  /// [width] TabBar 可见宽度
  /// [height] TabBar 高度
  /// [onTabClick] TabBar 点击回调
  const ScrollTabBar({
    Key? key,
    required this.tabCount,
    this.visibleCount = 3,
    this.currentIndex = 0,
    required this.width,
    required this.height,
    this.backgroundColor = Colors.white,
    this.animMode = TabAnimMode.none,
    required this.tabBuilder,
    this.onTabClick,
    this.dividerBuilder,
    this.controller,
  })  : assert(tabCount > 0),
        assert(visibleCount > 0),
        assert(currentIndex >= 0),
        assert((width > 0) && (height > 0)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ScrollTabBarState();
}

class _ScrollTabBarState<T> extends State<ScrollTabBar> {
  final ScrollController scrollController = ScrollController();

  int _tabCount = 0;
  int _visibleCount = 0;
  int _currentIndex = 0;
  double _tabWidth = 0;

  void resetConfig({
    required int tabCount,
    required int visibleCount,
    required int currentIndex,
  }) {
    _tabCount = tabCount;
    _visibleCount = ((tabCount >= visibleCount) ? visibleCount : 3);
    _currentIndex = ((tabCount > currentIndex) ? currentIndex : 0);
    _tabWidth = (_tabCount <= _visibleCount)
        ? (widget.width / _tabCount)
        : (widget.width / (_visibleCount + 0.5));
  }

  void changeTab(int index) {
    widget.onTabClick?.call(index);
    setState(() {
      _currentIndex = index;
    });
    // tab 点击后交互动画
    if (widget.animMode == TabAnimMode.middle) {
      double offset = (index == 0)
          ? 0
          : ((index * _tabWidth + _tabWidth / 2) - widget.width / 2);
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    resetConfig(
      tabCount: widget.tabCount,
      visibleCount: widget.visibleCount,
      currentIndex: widget.currentIndex,
    );

    widget.controller?.setOnListener(
      getCurrentIndex: () => _currentIndex,
      jumpTo: (index) {
        if ((index == _currentIndex) || (index >= _tabCount)) {
          return;
        }
        changeTab(index);
      },
      reset: ({
        int? tabCount,
        int? visibleCount,
        int? currentIndex,
      }) {
        setState(() {
          resetConfig(
            tabCount: (tabCount == null) ? _tabCount : tabCount,
            visibleCount: (visibleCount == null) ? _visibleCount : visibleCount,
            currentIndex: (currentIndex == null) ? _currentIndex : currentIndex,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: (widget.dividerBuilder == null)
                ? const SizedBox()
                : widget.dividerBuilder!(context),
          ),
          ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _tabCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => changeTab(index),
                child: SizedBox(
                  width: _tabWidth,
                  child: widget.tabBuilder(
                      context, index, (index == _currentIndex)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

typedef JumpTo = void Function(int index);
typedef ResetTabBar = void Function({
  int? tabCount,
  int? visibleCount,
  int? currentIndex,
});

class ScrollTabBarController {
  void setOnListener({
    Function? getCurrentIndex,
    required JumpTo? jumpTo,
    required ResetTabBar? reset,
  }) {
    _jumpTo = jumpTo;
    _reset = reset;
  }

  /// 获取当前index
  Function? _getCurrentIndex;

  int get currentIndex {
    if (_getCurrentIndex != null) {
      return _getCurrentIndex!();
    }
    return 0;
  }

  JumpTo? _jumpTo;

  /// 跳转指定 tab
  void jumpTo(int index) {
    if (_jumpTo != null) {
      _jumpTo!(index);
    }
  }

  ResetTabBar? _reset;

  /// 重置TabBar
  void reset({
    int? tabCount,
    int? visibleCount,
    int? currentIndex,
  }) {
    if (tabCount != null) assert(tabCount > 0);
    if (visibleCount != null) assert(visibleCount > 0);
    if (currentIndex != null) assert(currentIndex >= 0);
    if (_reset != null) {
      _reset!.call(
        tabCount: tabCount,
        visibleCount: visibleCount,
        currentIndex: currentIndex,
      );
    }
  }
}


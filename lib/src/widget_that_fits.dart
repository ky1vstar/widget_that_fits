import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WidgetThatFits extends MultiChildRenderObjectWidget {
  const WidgetThatFits({super.key, this.direction = Axis.horizontal, required super.children});

  final Axis direction;

  @override
  RenderWidgetThatFits createRenderObject(BuildContext context) {
    return RenderWidgetThatFits(direction: direction);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderWidgetThatFits renderObject) {
    renderObject.direction = direction;
  }

  @override
  MultiChildRenderObjectElement createElement() => _WidgetThatFitsElement(this);
}

class _WidgetThatFitsElement extends MultiChildRenderObjectElement {
  _WidgetThatFitsElement(WidgetThatFits super.widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    for (final child in children) {
      final childParentData = child.renderObject!.parentData! as _WidgetThatFitsParentData;
      if (childParentData.isVisible) {
        visitor(child);
      }
    }
  }
}

class _WidgetThatFitsParentData extends ParentData with ContainerParentDataMixin<RenderBox> {
  bool isVisible = false;

  @override
  String toString() => 'isVisible=$isVisible';
}

class RenderWidgetThatFits extends RenderBox with ContainerRenderObjectMixin<RenderBox, _WidgetThatFitsParentData> {
  RenderWidgetThatFits({required Axis direction}) : _direction = direction;

  Axis get direction => _direction;
  Axis _direction;

  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _WidgetThatFitsParentData) {
      child.parentData = _WidgetThatFitsParentData();
    }
  }

  @override
  void performLayout() {
    size = _layout(constraints, isDryLayout: false);
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _layout(constraints, isDryLayout: true);
  }

  Size _layout(BoxConstraints constraints, {required bool isDryLayout}) {
    final childLayouter = isDryLayout ? ChildLayoutHelper.dryLayoutChild : ChildLayoutHelper.layoutChild;
    var size = Size.zero;
    final mainAxisConstraints = switch (direction) {
      Axis.horizontal => constraints.copyWith(minWidth: 0, maxWidth: double.infinity),
      Axis.vertical => constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
    };
    final crossAxisConstraints = switch (direction) {
      Axis.horizontal => constraints.copyWith(minWidth: 0, minHeight: 0, maxHeight: double.infinity),
      Axis.vertical => constraints.copyWith(minHeight: 0, minWidth: 0, maxWidth: double.infinity),
    };

    var child = firstChild;
    var lastChild = child;
    var isAnyChildVisible = false;
    while (child != null) {
      lastChild = child;
      final childParentData = child.parentData! as _WidgetThatFitsParentData;

      var childSize = childLayouter(child, mainAxisConstraints);
      if (!isAnyChildVisible && crossAxisConstraints.isSatisfiedBy(childSize)) {
        isAnyChildVisible = true;
        if (!isDryLayout) childParentData.isVisible = true;
        if (!constraints.isSatisfiedBy(childSize)) {
          // If the child fits in the main axis but not in the cross axis,
          // we need to layout the child again with the cross axis constraints.
          childSize = childLayouter(child, constraints);
        }
        size = constraints.constrain(childSize);
      } else {
        if (!isDryLayout) childParentData.isVisible = false;
      }

      child = childParentData.nextSibling;
    }

    if (!isAnyChildVisible && lastChild != null) {
      final childParentData = lastChild.parentData! as _WidgetThatFitsParentData;
      if (!isDryLayout) childParentData.isVisible = true;
      size = childLayouter(lastChild, constraints);
    }

    return size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as _WidgetThatFitsParentData;
      if (childParentData.isVisible) {
        context.paintChild(child, offset);
        return;
      }
      child = childParentData.nextSibling;
    }
  }
}

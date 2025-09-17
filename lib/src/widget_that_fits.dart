import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A widget that displays the first child that fits the available space.
///
/// `WidgetThatFits` evaluates its children in the order they are provided and
/// displays the first child whose size fits within the constraints along the
/// specified [axes]. This allows you to provide multiple layout options and
/// have the most preferred one shown when it fits.
///
/// This is similar in spirit to [FittedBox], [LayoutBuilder], or [Wrap], but
/// instead of scaling or wrapping, it simply picks the first child that fits.
///
/// The [axes] parameter controls which axes are considered when determining if
/// a child fits. By default, both [Axis.horizontal] and [Axis.vertical] are
/// used. If [axes] is empty, the first child is always used.
///
/// ## Sample usage
///
/// The following example shows how to use [WidgetThatFits] to display upload
/// progress in one of three ways, depending on the available width:
///
/// ```dart
/// class UploadProgressWidget extends StatelessWidget {
///   const UploadProgressWidget({super.key, required this.uploadProgress});
///
///   static final _percentFormatter = intl.NumberFormat.percentPattern();
///
///   final double uploadProgress;
///
///   @override
///   Widget build(BuildContext context) {
///     return WidgetThatFits(
///       axes: const {Axis.horizontal},
///       children: [
///         Row(
///           children: [
///             Text(_percentFormatter.format(uploadProgress)),
///             SizedBox(
///               width: 100,
///               child: LinearProgressIndicator(value: uploadProgress),
///             ),
///           ],
///         ),
///         SizedBox(
///           width: 100,
///           child: LinearProgressIndicator(value: uploadProgress),
///         ),
///         Text(_percentFormatter.format(uploadProgress)),
///       ],
///     );
///   }
/// }
/// ```
///
/// This will show the most detailed layout that fits the available width.
///
/// See also:
///
///  * [FittedBox], which scales its child to fit the available space.
///  * [LayoutBuilder], which builds a widget tree based on parent constraints.
///  * [Wrap], which lays out children in multiple horizontal or vertical runs.
///  * [Visibility], which can show or hide widgets based on a condition.
class WidgetThatFits extends MultiChildRenderObjectWidget {
  const WidgetThatFits({super.key, this.axes = const {Axis.horizontal, Axis.vertical}, required super.children});

  /// A set of axes to constrain children to. The set may
  /// contain ``Axis/horizontal``, ``Axis/vertical``, or both of these.
  /// `ViewThatFits` chooses the first child whose size fits within the
  /// proposed size on these axes. If `axes` is an empty set,
  /// `ViewThatFits` uses the first child view. By default,
  /// `ViewThatFits` uses both axes.
  ///
  /// If the set contains [Axis.horizontal], the width of each child is
  /// compared to the available width. If it contains [Axis.vertical], the
  /// height is compared to the available height. If both axes are included
  /// (the default), both width and height must fit. If the set is empty,
  /// the first child is always used, regardless of its size.
  final Set<Axis> axes;

  /// The list of children to be evaluated for fitting.
  ///
  /// The children are evaluated in order, and the first child that fits
  /// the constraints along the specified [axes] is displayed. All other
  /// children are not rendered.
  @override
  List<Widget> get children => super.children;

  @override
  RenderWidgetThatFits createRenderObject(BuildContext context) {
    return RenderWidgetThatFits(axes: axes);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderWidgetThatFits renderObject) {
    renderObject.axes = axes;
  }

  @override
  MultiChildRenderObjectElement createElement() => _WidgetThatFitsElement(this);
}

class _WidgetThatFitsElement extends MultiChildRenderObjectElement {
  _WidgetThatFitsElement(WidgetThatFits super.widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    for (final child in children) {
      final childParentData = child.renderObject!.parentData! as WidgetThatFitsParentData;
      if (childParentData.isVisible) {
        visitor(child);
      }
    }
  }
}

/// Parent data for use with [RenderWidgetThatFits].
class WidgetThatFitsParentData extends ParentData with ContainerParentDataMixin<RenderBox> {
  bool isVisible = false;

  @override
  String toString() => 'isVisible=$isVisible';
}

/// Render object for [WidgetThatFits].
class RenderWidgetThatFits extends RenderBox with ContainerRenderObjectMixin<RenderBox, WidgetThatFitsParentData> {
  RenderWidgetThatFits({required Set<Axis> axes}) : _axes = axes;

  Set<Axis> get axes => _axes;
  Set<Axis> _axes;

  set axes(Set<Axis> value) {
    if (const DeepCollectionEquality.unordered().equals(_axes, value)) return;
    _axes = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! WidgetThatFitsParentData) {
      child.parentData = WidgetThatFitsParentData();
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
    final layoutChild = isDryLayout ? ChildLayoutHelper.dryLayoutChild : ChildLayoutHelper.layoutChild;
    var size = Size.zero;

    // Unbounded constraints for widgets like Text that can be truncated in
    // order to fit the available space.
    final constraintsForLayout = axes.fold(
      constraints,
      (constraintsForLayout, axis) => switch (axis) {
        Axis.horizontal => constraintsForLayout.copyWith(maxWidth: double.infinity),
        Axis.vertical => constraintsForLayout.copyWith(maxHeight: double.infinity),
      },
    );

    final constraintsForTest = axes.fold(
      const BoxConstraints(),
      (constraintsForTest, axis) => switch (axis) {
        Axis.horizontal => constraintsForTest.copyWith(maxWidth: constraints.maxWidth),
        Axis.vertical => constraintsForTest.copyWith(maxHeight: constraints.maxHeight),
      },
    );

    var child = firstChild;
    var lastChild = child;
    var lastChildSize = Size.zero;
    var isAnyChildVisible = false;
    while (child != null) {
      final childParentData = child.parentData! as WidgetThatFitsParentData;

      var childSize = layoutChild(child, constraintsForLayout);
      if (!isAnyChildVisible && (axes.isEmpty || constraintsForTest.isSatisfiedBy(childSize))) {
        isAnyChildVisible = true;
        if (!isDryLayout) childParentData.isVisible = true;
        if (!constraints.isSatisfiedBy(childSize)) {
          // If the child fits in the main axis but not in the cross axis,
          // we need to layout the child again with the cross axis constraints.
          childSize = layoutChild(child, constraints);
        }
        size = childSize;
      } else {
        if (!isDryLayout) childParentData.isVisible = false;
      }

      lastChild = child;
      lastChildSize = childSize;
      child = childParentData.nextSibling;
    }

    if (!isAnyChildVisible && lastChild != null) {
      final childParentData = lastChild.parentData! as WidgetThatFitsParentData;
      if (!isDryLayout) childParentData.isVisible = true;
      var childSize = lastChildSize;
      if (!constraints.isSatisfiedBy(childSize)) {
        // If the child fits in the main axis but not in the cross axis,
        // we need to layout the child again with the cross axis constraints.
        childSize = layoutChild(lastChild, constraints);
      }
      size = childSize;
    }

    return size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as WidgetThatFitsParentData;
      if (childParentData.isVisible) {
        context.paintChild(child, offset);
        return;
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;
    while (child != null) {
      final childParentData = child.parentData! as WidgetThatFitsParentData;
      if (childParentData.isVisible) {
        return child.hitTest(result, position: position);
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}

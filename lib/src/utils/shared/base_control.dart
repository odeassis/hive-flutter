import 'package:flutter/material.dart';

import '../../theme/effects/effects.dart';
import '../../theme/hive_theme.dart';
import '../../theme/tokens/tokens.dart';
import '../utils.dart' as utils;
import 'common/common.dart';

typedef HiveBaseControlBuilder = Widget Function(
  BuildContext context,
  bool isEnabled,
  bool isHovered,
  bool isFocused,
  bool isPressed,
);

class HiveBaseControl extends StatefulWidget {
  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Whether to absorb the drag events of the base control.
  final bool absorbDragEvents;

  /// Whether the base control is focusable.
  final bool isFocusable;

  /// Whether to ensure a minimum touch target size for the base control.
  final bool ensureMinimalTouchTargetSize;

  /// Whether the semantic type of the base control is button.
  final bool semanticTypeIsButton;

  /// Whether to propagate gestures to the child of the base control.
  final bool propagateGesturesToChild;

  /// Whether the base control shows a focus effect.
  final bool showFocusEffect;

  /// Whether the base control shows a pulse effect.
  final bool showPulseEffect;

  /// Whether the base control shows a jiggle during the pulse effect.
  final bool showPulseEffectJiggle;

  /// Whether the base control shows a scale effect.
  final bool showScaleEffect;

  /// The border radius of the base control.
  final BorderRadiusGeometry? borderRadius;

  /// The background color of the base control.
  final Color? backgroundColor;

  /// The color of the base control focus effect.
  final Color? focusEffectColor;

  /// The color of the base control pulse effect.
  final Color? pulseEffectColor;

  /// The opacity value of the base control when disabled.
  final double? disabledOpacityValue;

  final double? hoverOpacityValue;

  /// The minimum size of the base control touch target.
  final double minTouchTargetSize;

  /// The extent of the base control focus effect.
  final double? focusEffectExtent;

  /// The extent of the base control pulse effect.
  final double? pulseEffectExtent;

  /// The degree of scaling applied during the scale effect.
  final double? scaleEffectScalar;

  /// The duration of the focus effect.
  final Duration? focusEffectDuration;

  /// The duration of the pulse effect.
  final Duration? pulseEffectDuration;

  /// The duration of the scale effect.
  final Duration? scaleEffectDuration;

  /// The curve of the focus effect.
  final Curve? focusEffectCurve;

  /// The curve of the pulse effect.
  final Curve? pulseEffectCurve;

  /// The curve of the scale effect.
  final Curve? scaleEffectCurve;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// A builder to build a custom child for the base control.
  /// Cannot be used in conjunction with the [child] property, one of them must be null.
  final HiveBaseControlBuilder? builder;

  /// The mouse cursor of the base control.
  final MouseCursor cursor;

  /// The semantic label for the base control.
  final String? semanticLabel;

  /// The callback that is called when the base control focus state changes.
  final void Function(bool)? onFocus;

  /// The callback that is called when the base control hover state changes.
  final void Function(bool)? onHover;

  /// The callback that is called when the base control is tapped or pressed.
  final VoidCallback? onTap;

  /// The callback that is called when the base control is long-pressed.
  final VoidCallback? onLongPress;

  /// The child of the base control.
  /// Cannot be used in conjunction with the [builder] property, one of them must be null.
  final Widget? child;

  /// Creates a Hive Design base control.
  const HiveBaseControl({
    super.key,
    this.autofocus = false,
    this.absorbDragEvents = false,
    this.isFocusable = true,
    this.ensureMinimalTouchTargetSize = false,
    this.semanticTypeIsButton = false,
    this.propagateGesturesToChild = false,
    this.showFocusEffect = true,
    this.showPulseEffect = false,
    this.showPulseEffectJiggle = true,
    this.showScaleEffect = false,
    this.borderRadius = BorderRadius.zero,
    this.backgroundColor,
    this.focusEffectColor,
    this.pulseEffectColor,
    this.disabledOpacityValue,
    this.hoverOpacityValue,
    this.minTouchTargetSize = 40.0,
    this.focusEffectExtent,
    this.pulseEffectExtent,
    this.scaleEffectScalar,
    this.focusEffectDuration,
    this.pulseEffectDuration,
    this.scaleEffectDuration,
    this.focusEffectCurve,
    this.pulseEffectCurve,
    this.scaleEffectCurve,
    this.focusNode,
    this.builder,
    this.cursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.onFocus,
    this.onHover,
    this.onTap,
    this.onLongPress,
    this.child,
  }) : assert(
          (child == null) != (builder == null),
          "Only either a child or a builder can be provided, not both.",
        );

  @override
  State<HiveBaseControl> createState() => _HiveBaseControlState();
}

class _HiveBaseControlState extends State<HiveBaseControl> {
  late Map<Type, Action<Intent>> _actions;

  FocusNode? _focusNode;

  bool _isFocused = false;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isLongPressed = false;

  bool get _isEnabled => widget.onTap != null || widget.onLongPress != null;

  bool get _canAnimateFocus =>
      widget.showFocusEffect && _isEnabled && _isFocused;

  bool get _canAnimatePulse => widget.showPulseEffect && _isEnabled;

  bool get _canAnimateScale =>
      widget.showScaleEffect && _isEnabled && (_isPressed || _isLongPressed);

  MouseCursor get _cursor =>
      _isEnabled ? widget.cursor : SystemMouseCursors.basic;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ??
      (_focusNode ??= FocusNode(skipTraversal: !widget.isFocusable));

  void _handleHover(bool hover) {
    if (hover != _isHovered) {
      setState(() => _isHovered = hover);

      widget.onHover?.call(hover);
    }
  }

  void _handleFocus(bool focus) {
    if (focus != _isFocused) {
      setState(() => _isFocused = focus);

      widget.onFocus?.call(focus);
    }
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;

      if (!hasFocus) {
        _isPressed = false;
      }
    });
  }

  void _handleTap() {
    if (_isEnabled) {
      setState(() => _isPressed = true);

      widget.onTap?.call();

      setState(() => _isPressed = false);
    }
  }

  void _handleTapDown(_) {
    if (!_isPressed) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(_) {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress == null) return;

    if (_isEnabled) {
      widget.onLongPress?.call();
    }
  }

  void _handleLongPressStart(_) {
    if (!_isLongPressed) {
      setState(() => _isLongPressed = true);
    }

    if (!_isPressed) {
      setState(() => _isPressed = true);
    }
  }

  void _handleLongPressUp() {
    if (widget.onLongPress == null) {
      widget.onTap?.call();
    }

    if (_isLongPressed) {
      setState(() => _isLongPressed = false);
    }

    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleHorizontalDragStart(DragStartDetails dragStartDetails) =>
      _handleTapDown(null);

  void _handleHorizontalDragEnd(DragEndDetails dragEndDetails) =>
      _handleTapUp(null);

  void _handleVerticalDragStart(DragStartDetails dragStartDetails) =>
      _handleTapDown(null);

  void _handleVerticalDragEnd(DragEndDetails dragEndDetails) =>
      _handleTapUp(null);

  @override
  void initState() {
    super.initState();

    _actions = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => _handleTap())
    };

    _focusNode = FocusNode(
        canRequestFocus: _isEnabled, skipTraversal: !widget.isFocusable);
    _effectiveFocusNode.canRequestFocus = _isEnabled;

    if (widget.autofocus) {
      _effectiveFocusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(HiveBaseControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.onTap != oldWidget.onTap ||
        widget.onLongPress != oldWidget.onLongPress) {
      if (!_isEnabled) {
        _isHovered = _isPressed = false;
      }
    }

    _effectiveFocusNode.canRequestFocus = _isEnabled;
  }

  @override
  void dispose() {
    _focusNode!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveDisabledOpacityValue = widget.disabledOpacityValue ??
        context.hiveTheme?.tokens.opacities.disabled ??
        HiveOpacities.opacities.disabled;

    final Color effectiveFocusEffectColor = widget.focusEffectColor ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectColor;

    final double effectiveFocusEffectExtent = widget.focusEffectExtent ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectExtent;

    final Duration effectiveFocusEffectDuration = widget.focusEffectDuration ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectDuration;

    final Curve effectiveFocusEffectCurve = widget.focusEffectCurve ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectCurve;

    // Pulse effect properties.
    final Color effectivePulseEffectColor = widget.pulseEffectColor ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlPulseEffect
            .effectColor!;

    final double effectivePulseEffectExtent = widget.pulseEffectExtent ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlPulseEffect
            .effectExtent!;

    final Duration effectivePulseEffectDuration = widget.pulseEffectDuration ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlPulseEffect
            .effectDuration;

    final Curve effectivePulseEffectCurve = widget.pulseEffectCurve ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlPulseEffect
            .effectCurve;

    // Scale effect properties.
    final double effectiveScaleEffectScalar = widget.scaleEffectScalar ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlScaleEffect
            .effectScalar!;

    final Duration effectiveScaleEffectDuration = widget.scaleEffectDuration ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlScaleEffect
            .effectDuration;

    final Curve effectiveScaleEffectCurve = widget.scaleEffectCurve ??
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlScaleEffect
            .effectCurve;

    final Widget child = widget.child ??
        widget.builder!(
          context,
          _isEnabled,
          _isHovered,
          _isFocused,
          _isPressed,
        );

    return MergeSemantics(
      child: Semantics(
        label: widget.semanticLabel,
        button: widget.semanticTypeIsButton,
        enabled: _isEnabled,
        focusable: _isEnabled,
        focused: _isFocused,
        child: AbsorbPointer(
          absorbing: !_isEnabled,
          child: FocusableActionDetector(
            enabled: _isEnabled,
            actions: _actions,
            mouseCursor: _cursor,
            focusNode: _effectiveFocusNode,
            autofocus: _isEnabled && widget.isFocusable && widget.autofocus,
            descendantsAreFocusable: _isEnabled,
            descendantsAreTraversable: _isEnabled,
            onFocusChange: _handleFocusChange,
            onShowFocusHighlight: _handleFocus,
            onShowHoverHighlight: _handleHover,
            child: GestureDetector(
              excludeFromSemantics: true,
              onTap: _handleTap,
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onLongPress: _handleLongPress,
              onLongPressStart: _handleLongPressStart,
              onLongPressUp: _handleLongPressUp,
              onTapCancel: _handleTapCancel,
              onHorizontalDragStart:
                  widget.absorbDragEvents ? _handleHorizontalDragStart : null,
              onHorizontalDragEnd:
                  widget.absorbDragEvents ? _handleHorizontalDragEnd : null,
              onVerticalDragStart:
                  widget.absorbDragEvents ? _handleVerticalDragStart : null,
              onVerticalDragEnd:
                  widget.absorbDragEvents ? _handleVerticalDragEnd : null,
              child: utils.TouchTargetPadding(
                minSize: widget.ensureMinimalTouchTargetSize
                    ? Size(widget.minTouchTargetSize, widget.minTouchTargetSize)
                    : Size.zero,
                child: AbsorbPointer(
                  absorbing: !widget.propagateGesturesToChild,
                  child: RepaintBoundary(
                    child: AnimatedScale(
                      scale: _canAnimateScale ? effectiveScaleEffectScalar : 1,
                      duration: effectiveScaleEffectDuration,
                      curve: effectiveScaleEffectCurve,
                      child: HivePulseEffect(
                        show: _canAnimatePulse,
                        showJiggle: widget.showPulseEffectJiggle,
                        childBorderRadius: widget.borderRadius,
                        effectColor: effectivePulseEffectColor,
                        effectExtent: effectivePulseEffectExtent,
                        effectCurve: effectivePulseEffectCurve,
                        effectDuration: effectivePulseEffectDuration,
                        child: AnimatedOpacity(
                          opacity:
                              _isEnabled ? 1 : effectiveDisabledOpacityValue,
                          duration: context.hiveTheme?.tokens.transitions
                                  .transitionDuration ??
                              HiveTransitions.transitions.transitionDuration,
                          curve: context.hiveTheme?.tokens.transitions
                                  .transitionCurve ??
                              HiveTransitions.transitions.transitionCurve,
                          child: HiveFocusEffect(
                            show: _canAnimateFocus,
                            effectColor: effectiveFocusEffectColor,
                            effectExtent: effectiveFocusEffectExtent,
                            effectCurve: effectiveFocusEffectCurve,
                            effectDuration: effectiveFocusEffectDuration,
                            childBorderRadius: widget.borderRadius,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

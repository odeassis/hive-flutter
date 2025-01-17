import 'package:flutter/material.dart';

import '../../theme/effects/effects.dart';
import '../../theme/theme.dart';
import '../../theme/tokens/tokens.dart';
import '../../utils/utils.dart' as utils;

class HiveRadio<T> extends StatefulWidget {
  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Set to true if this radio button is allowed to be returned to an
  /// indeterminate state by selecting it again when selected.
  ///
  /// To indicate returning to an indeterminate state, [onChanged] is called with null.
  ///
  /// If true, [onChanged] is called with [value] when selected while [groupValue] != [value],
  /// or with null when selected again while [groupValue] == [value].
  ///
  /// If false, [onChanged] is called with [value] when selected while [groupValue] != [value],
  /// and only by selecting another radio button in the group (i.e. changing the value of [groupValue])
  /// can this radio button be unselected.
  final bool toggleable;

  /// The color of the active (selected) radio button.
  final Color? activeColor;

  /// The background color of the inactive (unselected) radio button.
  final Color? inactiveColor;

  /// The size of the radio button tap target.
  ///
  /// Defaults to 40.
  final double tapAreaSizeValue;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// The semantic label for the radio button.
  final String? semanticLabel;

  /// The value of the radio button.
  final T value;

  /// The value of a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the [groupValue].
  final T? groupValue;

  /// The callback that is called when the user selects the radio button.
  ///
  /// The radio button passes its [value] as a parameter to [onChanged] callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button is displayed as disabled.
  ///
  /// The provided callback is not invoked if this radio button is already selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent gets rebuilt.
  final ValueChanged<T?>? onChanged;

  /// Creates a Hive Design radio button.
  const HiveRadio({
    super.key,
    this.autofocus = false,
    this.toggleable = false,
    this.activeColor,
    this.inactiveColor,
    this.tapAreaSizeValue = 40,
    this.focusNode,
    this.semanticLabel,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  /// Creates a Hive Design radio button with label.
  @Deprecated("Use HiveMenuItem with HiveRadio as a trailing widget instead.")
  static Widget withLabel<T>(
    BuildContext context, {
    Key? key,
    bool autofocus = false,
    bool toggleable = false,
    Color? activeColor,
    Color? inactiveColor,
    double tapAreaSizeValue = 40,
    FocusNode? focusNode,
    TextStyle? textStyle,
    required String label,
    required T value,
    required T? groupValue,
    required ValueChanged<T?>? onChanged,
  }) {
    final bool isInteractive = onChanged != null;

    final Color effectiveTextColor =
        context.hiveTheme?.radioTheme.colors.textColor ??
            HiveTokens.light.modes.content.primary;

    final TextStyle effectiveTextStyle =
        context.hiveTheme?.radioTheme.properties.textStyle ??
            HiveTokens.light.typography.label.md;

    final TextStyle resolvedTextStyle =
        effectiveTextStyle.copyWith(color: effectiveTextColor).merge(textStyle);

    final double effectiveDisabledOpacityValue =
        HiveOpacities.opacities.disabled;

    final Duration effectiveFocusEffectDuration =
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectDuration;

    return GestureDetector(
      onTap: () => onChanged?.call(value),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor:
            isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: tapAreaSizeValue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedOpacity(
                opacity: isInteractive ? 1 : effectiveDisabledOpacityValue,
                duration: effectiveFocusEffectDuration,
                child: DefaultTextStyle(
                  style: resolvedTextStyle,
                  child: Text(label),
                ),
              ),
              const SizedBox(width: 12),
              HiveRadio<T>(
                key: key,
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                toggleable: toggleable,
                tapAreaSizeValue: 0,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                focusNode: focusNode,
                autofocus: autofocus,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _selected => value == groupValue;

  @override
  State<HiveRadio<T>> createState() => _RadioState<T>();
}

class _RadioState<T> extends State<HiveRadio<T>>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final utils.HiveRadioPainter _painter = utils.HiveRadioPainter();

  void _handleChanged(bool? selected) {
    if (selected == null) {
      widget.onChanged!(null);

      return;
    }
    if (selected) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didUpdateWidget(HiveRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._selected != oldWidget._selected) {
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();

    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => widget.toggleable;

  @override
  bool? get value => widget._selected;

  @override
  Widget build(BuildContext context) {
    const Size size = Size(16, 16);

    final Color effectiveActiveColor = widget.activeColor ??
        context.hiveTheme?.radioTheme.colors.activeColor ??
        HiveTokens.light.modes.action.active;

    final Color effectiveInactiveColor = widget.inactiveColor ??
        context.hiveTheme?.radioTheme.colors.inactiveColor ??
        HiveTokens.light.modes.action.disabled;

    final Color effectiveFocusEffectColor =
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectColor;

    final double effectiveFocusEffectExtent =
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectExtent;

    final Duration effectiveFocusEffectDuration =
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectDuration;

    final Curve effectiveFocusEffectCurve =
        HiveEffectsTheme(tokens: HiveTokens.light)
            .controlFocusEffect
            .effectCurve;

    final double effectiveDisabledOpacityValue =
        HiveOpacities.opacities.disabled;

    final WidgetStateProperty<MouseCursor> effectiveMouseCursor =
        WidgetStateProperty.resolveWith<MouseCursor>((Set<WidgetState> states) {
      return WidgetStateMouseCursor.clickable.resolve(states);
    });

    return Semantics(
      label: widget.semanticLabel,
      inMutuallyExclusiveGroup: true,
      checked: widget._selected,
      child: utils.TouchTargetPadding(
        minSize: Size(widget.tapAreaSizeValue, widget.tapAreaSizeValue),
        child: utils.HiveFocusEffect(
          show: states.contains(WidgetState.focused),
          effectExtent: effectiveFocusEffectExtent,
          childBorderRadius: BorderRadius.circular(8),
          effectColor: effectiveFocusEffectColor,
          effectCurve: effectiveFocusEffectCurve,
          effectDuration: effectiveFocusEffectDuration,
          child: RepaintBoundary(
            child: AnimatedOpacity(
              opacity: states.contains(WidgetState.disabled)
                  ? effectiveDisabledOpacityValue
                  : 1,
              duration: effectiveFocusEffectDuration,
              child: buildToggleable(
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                mouseCursor: effectiveMouseCursor,
                size: size,
                painter: _painter
                  ..position = position
                  ..activeColor = effectiveActiveColor
                  ..inactiveColor = effectiveInactiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

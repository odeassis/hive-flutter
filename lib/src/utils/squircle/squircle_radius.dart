import 'dart:ui';

/// A class representing a squircular radius with Bacon's smoothing algorithm.
class BaconSquircleRadius extends Radius {
  static const zero = BaconSquircleRadius(
    cornerRadius: 0,
    cornerSmoothing: 0,
  );

  /// The amount of corner smoothing applied to the squircle radius.
  final double cornerSmoothing;

  /// Constructs a BaconSquircleRadius with the given corner radius and corner smoothing.
  ///
  /// The value of 1 or 1.0 leads to NaN error in mobile web/PWA for some reason.
  /// So we use 0.9 instead as the default value for [cornerSmoothing].
  const BaconSquircleRadius({
    required double cornerRadius,
    this.cornerSmoothing = 0.9,
  }) : super.circular(cornerRadius);

  /// Getter for the corner radius.
  double get cornerRadius => x;

  /// Unary negation operator.
  ///
  /// Returns a Radius with the distances negated.
  ///
  /// Radiuses with negative values aren't geometrically meaningful, but could
  /// occur as part of expressions. For example, negating a radius of one pixel
  /// and then adding the result to another radius is equivalent to subtracting
  /// a radius of one pixel from the other.
  @override
  Radius operator -() => BaconSquircleRadius(
        cornerRadius: -cornerRadius,
        cornerSmoothing: cornerSmoothing,
      );

  /// Binary subtraction operator.
  ///
  /// Returns a radius whose [x] value is the left-hand-side operand's [x]
  /// minus the right-hand-side operand's [x] and whose [y] value is the
  /// left-hand-side operand's [y] minus the right-hand-side operand's [y].
  @override
  Radius operator -(Radius other) {
    if (other is BaconSquircleRadius) {
      return BaconSquircleRadius(
        cornerRadius: cornerRadius - other.cornerRadius,
        cornerSmoothing: (cornerSmoothing + other.cornerSmoothing) / 2,
      );
    }

    return BaconSquircleRadius(
      cornerRadius: cornerRadius - other.x,
      cornerSmoothing: cornerSmoothing,
    );
  }

  /// Binary addition operator.
  ///
  /// Returns a radius whose [x] value is the sum of the [x] values of the
  /// two operands, and whose [y] value is the sum of the [y] values of the
  /// two operands.
  @override
  Radius operator +(Radius other) {
    if (other is BaconSquircleRadius) {
      return BaconSquircleRadius(
        cornerRadius: cornerRadius + other.cornerRadius,
        cornerSmoothing: (cornerSmoothing + other.cornerSmoothing) / 2,
      );
    }

    return BaconSquircleRadius(
      cornerRadius: cornerRadius + other.x,
      cornerSmoothing: cornerSmoothing,
    );
  }

  /// Multiplication operator.
  ///
  /// Returns a radius whose coordinates are the coordinates of the
  /// left-hand-side operand (a radius) multiplied by the scalar
  /// right-hand-side operand (a double).
  @override
  BaconSquircleRadius operator *(double operand) => BaconSquircleRadius(
        cornerRadius: cornerRadius * operand,
        cornerSmoothing: cornerSmoothing * operand,
      );

  /// Division operator.
  ///
  /// Returns a radius whose coordinates are the coordinates of the
  /// left-hand-side operand (a radius) divided by the scalar right-hand-side
  /// operand (a double).
  @override
  BaconSquircleRadius operator /(double operand) => BaconSquircleRadius(
        cornerRadius: cornerRadius / operand,
        cornerSmoothing: cornerSmoothing / operand,
      );

  /// Integer (truncating) division operator.
  ///
  /// Returns a radius whose coordinates are the coordinates of the
  /// left-hand-side operand (a radius) divided by the scalar right-hand-side
  /// operand (a double), rounded towards zero.
  @override
  BaconSquircleRadius operator ~/(double operand) => BaconSquircleRadius(
        cornerRadius: (cornerRadius ~/ operand).toDouble(),
        cornerSmoothing: (cornerSmoothing ~/ operand).toDouble(),
      );

  /// Modulo (remainder) operator.
  ///
  /// Returns a radius whose coordinates are the remainder of dividing the
  /// coordinates of the left-hand-side operand (a radius) by the scalar
  /// right-hand-side operand (a double).
  @override
  BaconSquircleRadius operator %(double operand) => BaconSquircleRadius(
        cornerRadius: cornerRadius % operand,
        cornerSmoothing: cornerSmoothing % operand,
      );

  /// Linearly interpolate between two smooth radii.
  ///
  /// If either is null, this function substitutes [BaconSquircleRadius.zero] instead.
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [Curves.elasticInOut]).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  static BaconSquircleRadius? lerp(
      BaconSquircleRadius? a, BaconSquircleRadius? b, double t) {
    if (b == null) {
      if (a == null) {
        return null;
      } else {
        final double k = 1.0 - t;
        return BaconSquircleRadius(
          cornerRadius: a.cornerRadius * k,
          cornerSmoothing: a.cornerSmoothing * k,
        );
      }
    } else {
      if (a == null) {
        return BaconSquircleRadius(
          cornerRadius: b.cornerRadius * t,
          cornerSmoothing: b.cornerSmoothing * t,
        );
      } else {
        return BaconSquircleRadius(
          cornerRadius: lerpDouble(a.cornerRadius, b.cornerRadius, t) ?? 0,
          cornerSmoothing:
              lerpDouble(a.cornerSmoothing, b.cornerSmoothing, t) ?? 0,
        );
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    return other is BaconSquircleRadius &&
        other.cornerRadius == cornerRadius &&
        other.cornerSmoothing == cornerSmoothing;
  }

  @override
  int get hashCode => Object.hash(cornerRadius, cornerSmoothing);

  @override
  String toString() {
    return 'BaconSquircleRadius('
        'cornerRadius: ${cornerRadius.toStringAsFixed(2)}, '
        'cornerSmoothing: ${cornerSmoothing.toStringAsFixed(2)}, '
        ')';
  }
}

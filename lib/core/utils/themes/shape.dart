import 'package:flutter/material.dart';

class ShapeConstants {
  static const double shapeRadiusS = 0.0;
  static const double shapeRadiusM = 0.0;
  static const double shapeRadiusL = 0.0;
  static const double shapeRadiusXL = 0.0;
  static const double shapeRadiusXXL = 0.0;
}

class Shape {
  static final BorderRadiusGeometry roundedS = BorderRadius.zero;
  static final BorderRadiusGeometry roundedM = BorderRadius.zero;
  static final BorderRadiusGeometry roundedL = BorderRadius.zero;
  static final BorderRadiusGeometry roundedXL = BorderRadius.zero;
  static final BorderRadiusGeometry roundedXXL = BorderRadius.zero;
  static final RoundedRectangleBorder roundedRectangleS =
      RoundedRectangleBorder(borderRadius: Shape.roundedS);
  static final RoundedRectangleBorder roundedRectangleM =
      RoundedRectangleBorder(borderRadius: Shape.roundedM);
  static final RoundedRectangleBorder roundedRectangleL =
      RoundedRectangleBorder(borderRadius: Shape.roundedL);
  static final RoundedRectangleBorder roundedRectangleXL =
      RoundedRectangleBorder(borderRadius: Shape.roundedXL);
  static final RoundedRectangleBorder roundedRectangleXXL =
      RoundedRectangleBorder(borderRadius: Shape.roundedXXL);
  static final RoundedRectangleBorder cardBorder = RoundedRectangleBorder(
    borderRadius: Shape.roundedM,
  );
}

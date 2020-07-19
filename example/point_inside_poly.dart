import 'dart:math';

import 'package:poly_collisions/poly_collisions.dart';

bool areOverlapping = PolygonCollision.isPointInPolygon(
  [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
  new Point(1, 1),
);
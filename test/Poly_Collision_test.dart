import 'dart:math' show Point;

import 'package:Poly_Collision/poly_collisions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Polygon tests', () {
    expect(
        PolygonCollision.doesOverlap(
          [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
          [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
        ),
        true);
    expect(
        PolygonCollision.doesOverlap(
          [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
          [new Point(2, 2), new Point(3, 2), new Point(3, 3), new Point(2, 3)],
        ),
        true);
    expect(
        PolygonCollision.doesOverlap(
          [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
          [new Point(3, 3), new Point(4, 3), new Point(4, 4), new Point(3, 4)],
        ),
        false);
    expect(
        PolygonCollision.doesOverlap(
          [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
          [
            new Point(3, 3),
            new Point(4, 3),
            new Point(4, 4),
            new Point(3, 4),
            new Point(1, 1)
          ],
        ),
        true);
    expect(
        PolygonCollision.doesOverlap(
          [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
          [
            new Point(3, 3),
            new Point(4, 3),
            new Point(4, 4),
            new Point(3, 4),
            new Point(0, 0)
          ],
        ),
        true);
    expect(
        PolygonCollision.doesOverlap(
          [new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(1, 2)],
          [
            new Point(1.25, 1.25),
            new Point(1.5, 1.25),
            new Point(1.5, 1.5),
            new Point(1.25, 1.5),
            new Point(1, 1)
          ],
        ),
        true);
  });
  test(
      "Point in polygon tests",
      () => {
            expect(
                PolygonCollision.isPointInPolygon([
                  new Point(1, 1),
                  new Point(2, 1),
                  new Point(2, 2),
                  new Point(1, 2)
                ], new Point(1.5, 1.5)),
                true),
            expect(
                PolygonCollision.isPointInPolygon([
                  new Point(1, 1),
                  new Point(2, 1),
                  new Point(2, 2),
                  new Point(1, 2)
                ], new Point(1, 1)),
                true),
            expect(
                PolygonCollision.isPointInPolygon([
                  new Point(1, 1),
                  new Point(2, 1),
                  new Point(2, 2),
                  new Point(1, 2)
                ], new Point(3, 3)),
                false),
          });
}

library poly_collisions;

import 'dart:math' show Point, max, min, sqrt;

//Implementation is done using S.A.T. (SEPARATED AXIS THEOREM)
//Implemented Offset versions of the functions to make working with canvas
class PolygonCollision {
  //Get axis projection using two points
  static Point _getAxisProjection(Point a, Point b) {
    Point axisProj = Point(a.y - b.y, b.x - a.x);
    double d = sqrt(axisProj.x * axisProj.x + axisProj.y * axisProj.y);
    return Point(axisProj.x / d, axisProj.y / d);
  }

  //Returns min and max points according to axis projection
  //returns : [min, max]
  static List<double> _getMinAndMaxPoints(
      List<Point> polygon, Point axisProjection) {
    double minPolygonOne = double.infinity,
        maxPolygonOne = double.negativeInfinity;
    polygon.forEach((point) {
      double value = (point.x * axisProjection.x + point.y * axisProjection.y);
      minPolygonOne = min(minPolygonOne, value);
      maxPolygonOne = max(maxPolygonOne, value);
    });
    return [minPolygonOne, maxPolygonOne];
  }

  //Check polygon intersection function using SAT
  static bool doesOverlap(List<Point> polygon, List<Point> otherPolygon) {
    if (polygon == null) throw ArgumentError.notNull("polygon");
    if (otherPolygon == null) throw ArgumentError.notNull("otherPolygon");
    var polygons = [polygon, otherPolygon];
    int poly1 = 0;
    int poly2 = 1;
    for (int shape = 0; shape < 2; shape++) {
      for (int a = 0; a < polygons[poly1].length; a++) {
        //Gets next point in list
        int b = (a + 1) % polygons[poly1].length;

        //Gets axis projection
        Point axisProjection =
            _getAxisProjection(polygons[poly1][a], polygons[poly1][b]);

        //Gets min and max points for the two rectangles
        List<double> firstPolygonMinAndMax =
            _getMinAndMaxPoints(polygons[poly1], axisProjection);
        List<double> secondPolygonMinAndMax =
            _getMinAndMaxPoints(polygons[poly2], axisProjection);

        if (!(secondPolygonMinAndMax[1] >= firstPolygonMinAndMax[0] &&
            firstPolygonMinAndMax[1] >= secondPolygonMinAndMax[0]))
          return false;
      }
      poly1 = 1;
      poly2 = 0;
    }

    return true;
  }

  //Check if point is in polygon function
  static bool isPointInPolygon(List<Point> polygon, Point point) {
    if (polygon == null) throw ArgumentError.notNull("polygon");
    if (point == null) throw ArgumentError.notNull("point");
    bool result = false;
    for (int j = 0; j < polygon.length; j++) {
      if (polygon[j] == point) return true;
      int i = (j + 1) % polygon.length;
      if (polygon[i].y < point.y && polygon[j].y >= point.y ||
          polygon[j].y < point.y && polygon[i].y >= point.y) {
        if (polygon[i].x +
                (point.y - polygon[i].y) /
                    (polygon[j].y - polygon[i].y) *
                    (polygon[j].x - polygon[i].x) <
            point.x) {
          result = !result;
        }
      }
    }
    return result;
  }
}

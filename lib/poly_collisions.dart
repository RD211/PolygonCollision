library poly_collisions;

import 'dart:math' show Point, atan2, max, min, pi, sqrt;

//Polygon types for selection
enum PolygonType { Convex, Concave, Auto }
//Implementation is done using S.A.T. (SEPARATED AXIS THEOREM)
//for convex polygons and for concave uses less efficient algorithm
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

  //Returns wheter or not the polygon is convex
  static bool isConvexPolygon(List<Point> polygon) {
    try {
      if (polygon.length < 3) return false;
      Point oldP = polygon[polygon.length - 2];
      Point newP = polygon.last;
      double newDirection = atan2(newP.y - oldP.y, newP.x - oldP.x);
      double oldDirection = 0;
      double angleSum = 0.0;
      double orientation = 0;
      double angle = 0;
      for (int i = 0; i < polygon.length; i++) {
        Point newPoint = polygon[i];
        oldDirection = newDirection;
        oldP = Point(newP.x, newP.y);
        newP = newPoint;
        newDirection = atan2(newP.y - oldP.y, newP.x - oldP.x);
        if (oldP == newP) return false;
        angle = newDirection - oldDirection;
        if (angle <= -pi)
          angle += 2 * pi;
        else if (angle > pi) angle -= 2 * pi;
        if (i == 0) {
          if ((angle).abs()<0.00001) return false;
          orientation = angle > 0.0 ? 1.0 : -1.0;
        } else {
          if (orientation * angle <= 0.0) return false;
        }
        angleSum += angle;

      }

        return ((angleSum / (2 * pi)).round()).abs() == 1;
    } catch (e) {
      return false;
    }
    return false;
  }

  //Check polygon intersection function using SAT for convex and simple for concave
  static bool doesOverlap(List<Point> polygon, List<Point> otherPolygon,
      {PolygonType type = PolygonType.Auto}) {
    if (polygon == null) throw ArgumentError.notNull("polygon");
    if (otherPolygon == null) throw ArgumentError.notNull("otherPolygon");
    switch (type) {
      case PolygonType.Concave:
        return _doesOverlapConcave(polygon, otherPolygon);
        break;
      case PolygonType.Convex:
        return _doesOverlapConvex(polygon, otherPolygon);
        break;
      case PolygonType.Auto:
        return (isConvexPolygon(polygon) && isConvexPolygon(otherPolygon))
            ? _doesOverlapConvex(polygon, otherPolygon)
            : _doesOverlapConcave(polygon, otherPolygon);
        break;
    }
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

  static bool _doesOverlapConvex(List<Point> a, List<Point> b) {
    var polygons = [a, b];
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

  static bool _doesOverlapConcave(List<Point> a, List<Point> b) {
    //Check every point if its in the other poly
    a.forEach((element) {
      if (isPointInPolygon(b, element)) return true;
    });
    b.forEach((element) {
      if (isPointInPolygon(a, element)) return true;
    });
    //Check every line segment
    for (int i = 0; i < a.length; i++) {
      int j = (i + 1) % a.length;
      for (int ii = 0; ii < b.length; ii++) {
        int jj = (ii + 1) % b.length;
        var o1 = _orientation(a[i], b[ii], b[jj]);
        var o2 = _orientation(a[j], b[ii], b[jj]);
        var o3 = _orientation(a[i], a[j], b[ii]);
        var o4 = _orientation(a[i], a[j], b[jj]);
        // General case
        if (o1 != o2 && o3 != o4) return true;
      }
    }
    return false;
  }

  static bool _orientation(Point a, Point b, Point c) {
    return (c.y - a.y) * (b.x - a.x) > (b.y - a.y) * (c.x - a.x);
  }
}

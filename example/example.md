```
//Library import
import 'package:poly_collisions/poly_collisions.dart';

var polygon = [new Point(0,0), new Point(1,0), new Point(1,1), new Point(0,1)];
var other = [new Point(1,1), new Point(2,1), new Point(2,2), new Point(1,2)];

//Simple check if type of polygons is unknown
var result = PolygonCollision.doesOverlap(polygon, other);

//For a speed-up Type of polygons can be specified in the function as follows
//If the type of the polygon is wrong the function may not output correctly

var result = PolygonCollision.doesOverlap(polygon, other, type: PolygonType.Convex);

//or
//This won't be guaranteed to give a corect output
var result = PolygonCollision.doesOverlap(polygon, other, type: PolygonType.Concave);

//Extra functions
//1. Checks if point is in polygon
var result = PolygonCollision.isPointInPolygon(polygon, Point(0,0));
//2. Checks if given polygon is convex or not
var result = PolygonCollision.isConvexPolygon(polygon);
```
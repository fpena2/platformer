package physics;

import physics.Shape2D;
import glm.Vec3;

using glm.Vec2;

class Edge {
	public var distance:Float;
	public var normal:Vec2;
	public var index:Int;

	public function new(distance:Float, normal:Vec2, index:Int) {
		this.distance = distance;
		this.normal = normal;
		this.index = index;
	}
}

class Headbutt2D {
	private var vertices:Array<Vec2>;
	private var direction:Vec2;
	private var shapeA:Shape2D;
	private var shapeB:Shape2D;

	public var maxIterations:Int = 20;

	public function new() {}

	private function calculateSupport(direction:Vec2):Vec2 {
		var oppositeDirection:Vec2 = direction.multiplyScalar(-1, new Vec2());
		var newVertex:Vec2 = shapeA.support(direction).copy(new Vec2());
		newVertex.subtractVec(shapeB.support(oppositeDirection), newVertex);
		return newVertex;
	}

	private function addSupport(direction:Vec2):Bool {
		var newVertex:Vec2 = calculateSupport(direction);
		vertices.push(newVertex);
		return Vec2.dot(direction, newVertex) >= 0;
	}

	function tripleProduct(a:Vec2, b:Vec2, c:Vec2):Vec2 {
		var A:Vec3 = new Vec3(a.x, a.y, 0);
		var B:Vec3 = new Vec3(b.x, b.y, 0);
		var C:Vec3 = new Vec3(c.x, c.y, 0);

		var first:Vec3 = Vec3.cross(A, B, new Vec3());
		var second:Vec3 = Vec3.cross(first, C, new Vec3());

		return new Vec2(second.x, second.y);
	}

	private function evolveSimplex():EvolveResult {
		switch (vertices.length) {
			case 0:
				{
					direction = new Vec2(1, 0); // shapeB.centre - shapeA.centre;
				}
			case 1:
				{
					// flip the direction
					direction *= -1;
				}
			case 2:
				{
					// line ab is the line formed by the first two vertices
					var ab:Vec2 = vertices[1] - vertices[0];
					// line a0 is the line from the first vertex to the origin
					var a0:Vec2 = vertices[0] * -1;

					// use the triple-cross-product to calculate a direction perpendicular
					// to line ab in the direction of the origin
					direction = tripleProduct(ab, a0, ab);
				}
			case 3:
				{
					// calculate if the simplex contains the origin
					/*var a:Vec2 = vertices[2];
						var b:Vec2 = vertices[1];
						var c:Vec2 = vertices[0]; */

					var c0:Vec2 = vertices[2] * -1;
					var bc:Vec2 = vertices[1] - vertices[2];
					var ca:Vec2 = vertices[0] - vertices[2];

					var bcNorm:Vec2 = tripleProduct(ca, bc, bc);
					var caNorm:Vec2 = tripleProduct(bc, ca, ca);

					if (bcNorm.dot(c0) > 0) {
						// the origin is outside line bc
						// get rid of a and add a new support in the direction of bcNorm
						vertices.remove(vertices[0]);
						direction = bcNorm;
					} else if (caNorm.dot(c0) > 0) {
						// the origin is outside line ca
						// get rid of b and add a new support in the direction of caNorm
						vertices.remove(vertices[1]);
						direction = caNorm;
					} else {
						// the origin is inside both ab and ac,
						// so it must be inside the triangle!
						return EvolveResult.FoundIntersection;
					}
				}
			case _:
				throw 'Can\'t have simplex with ${vertices.length} verts!';
		}

		return addSupport(direction) ? EvolveResult.StillEvolving : EvolveResult.NoIntersection;
	}

	public function test(shapeA:Shape2D, shapeB:Shape2D):Bool {
		// reset everything
		this.vertices = new Array<Vec2>();
		this.shapeA = shapeA;
		this.shapeB = shapeB;

		// do the actual test
		var result:EvolveResult = EvolveResult.StillEvolving;
		var iterations:Int = 0;
		while (iterations < maxIterations && result == EvolveResult.StillEvolving) {
			result = evolveSimplex();
			iterations++;
		}
		return result == EvolveResult.FoundIntersection;
	}

	private function findClosestEdge(winding:PolygonWinding):Edge {
		var closestDistance:Float = Math.POSITIVE_INFINITY;
		var closestNormal:Vec2 = new Vec2();
		var closestIndex:Int = 0;
		var line:Vec2 = new Vec2();
		for (i in 0...vertices.length) {
			var j:Int = i + 1;
			if (j >= vertices.length)
				j = 0;

			vertices[j].copy(line);
			line.subtractVec(vertices[i], line);

			var norm:Vec2 = switch (winding) {
				case PolygonWinding.Clockwise:
					new Vec2(line.y, -line.x);
				case PolygonWinding.CounterClockwise:
					new Vec2(-line.y, line.x);
			}
			norm.normalize(norm);

			// calculate how far away the edge is from the origin
			var dist:Float = norm.dot(vertices[i]);
			if (dist < closestDistance) {
				closestDistance = dist;
				closestNormal = norm;
				closestIndex = j;
			}
		}

		return new Edge(closestDistance, closestNormal, closestIndex);
	}

	public function intersect(shapeA:Shape2D, shapeB:Shape2D):Null<Vec2> {
		// first, calculate the base simplex
		if (!test(shapeA, shapeB)) {
			// if we're not intersecting, return null
			return null;
		}

		// calculate the winding of the existing simplex
		var e0:Float = (vertices[1].x - vertices[0].x) * (vertices[1].y + vertices[0].y);
		var e1:Float = (vertices[2].x - vertices[1].x) * (vertices[2].y + vertices[1].y);
		var e2:Float = (vertices[0].x - vertices[2].x) * (vertices[0].y + vertices[2].y);
		var winding:PolygonWinding = if (e0 + e1 + e2 >= 0) PolygonWinding.Clockwise; else PolygonWinding.CounterClockwise;

		var intersection:Vec2 = new Vec2();
		for (i in 0...32) {
			var edge:Edge = findClosestEdge(winding);
			var support:Vec2 = calculateSupport(edge.normal);
			var distance:Float = support.dot(edge.normal);

			intersection = edge.normal.copy(intersection);
			intersection.multiplyScalar(distance, intersection);

			if (Math.abs(distance - edge.distance) <= 0.000001) {
				return intersection;
			} else {
				vertices.insert(edge.index, support);
			}
		}

		return intersection;
	}
}

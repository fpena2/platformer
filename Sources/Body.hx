package;

using glm.Vec2;

class Body {
	public var offset(get, set):Vec2;
	public var vertices:Array<Vec2>;
	public var _offset:Vec2;

	public function new(?vertices:Array<Vec2>, ?position:Vec2) {
		this.vertices = vertices;
		this.offset = position;
	}

	private function get_offset():Vec2 {
		return _offset;
	}

	private function set_offset(c:Vec2):Vec2 {
		return _offset = c;
	}

	public function update_offset(c:Vec2):Void {
		offset.x += c.x;
		offset.y += c.y;
	}
}

package gameTools;

import kha.graphics2.Graphics;
import gameTools.Animation;
import glm.Vec2;
import kha.Image;
import kha.Color;
import physics.Polygon2D;

class Entity extends Polygon2D {
	public var pSize:Vec2 = new Vec2(64, 64); // Player size in pixels
	public var image:Image;
	public var animation:Animation;

	var w:Float;
	var h:Float;

	public var width:Float = 0;
	public var height:Float = 0;

	var speed:Int = 4;
	var friction:Int = 3;
	var velocity:Vec2 = new Vec2(0, 0);
	var ArrayIndices:Array<Vec2>;

	public var active(default, set):Bool = true;

	public function new(image:Image, x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0) {
		ArrayIndices = [new Vec2(x, y), new Vec2(x + w, y), new Vec2(x + w, y + h), new Vec2(x, y + h)];
		super(ArrayIndices);
		set_offset([x, y]);

		w = width;
		h = height;
		this.image = image;

		if (this.width == 0 && image != null)
			this.width = pSize.x * 4;
		if (this.height == 0 && image != null)
			this.height = pSize.y * 4;
		animation = Animation.create(0);
	}

	public function setAnimation(animation:Animation):Void {
		this.animation.take(animation);
	}

	public function update():Void {
		update_offset([velocity.x * speed, velocity.y * speed]);
		velocity.x *= (1 - Math.min(1 / 60 * friction, 1));
		velocity.y *= (1 - Math.min(1 / 60 * friction, 1));
		animation.next();
	}

	public function render(graphics:Graphics) {
		if (image != null) {
			graphics.color = Color.White;
			graphics.drawScaledSubImage(image, Std.int(animation.get() * w) % image.width, Math.floor(animation.get() * w / image.width) * h, w, h,
				Math.round(offset.x), Math.round(offset.y), this.width, this.height);
		}
	}

	public function setImage(image:Image):Void {
		this.image = image;
	}

	public function set_active(value:Bool):Bool {
		return active = value;
	}
}

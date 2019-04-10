package;

import kha.graphics2.Graphics;
import Animation;
import glm.Vec2;
import kha.Image;
import kha.Color;
import Body;

class Entity extends Body {
	public var pSize:Vec2 = new Vec2(64, 64); // Player size in pixels
	public var image:Image;
	public var animation:Animation;

	// Copy of img dimensions for graphics transformations
	var charImgWidth:Float;
	var charImgHeight:Float;
	// Char features
	var charWidth:Float = 0;
	var charHeight:Float = 0;
	var speed:Int = 4;
	var friction:Int = 8;
	var velocity:Vec2 = new Vec2(0, 0);
	var ArrayIndices:Array<Vec2>;

	public var active(default, set):Bool = true;

	public function new(image:Image, xPos:Float = 0, yPos:Float = 0, tileW:Int = 0, tileH:Int = 0, size:Int = 1) {
		// image is a large sprite sheet
		this.image = image;
		charImgWidth = tileW;
		charImgHeight = tileH;

		// Passes data to body structure
		ArrayIndices = [
			new Vec2(xPos, yPos),
			new Vec2(xPos + charImgWidth, yPos),
			new Vec2(xPos + charImgWidth, yPos + charImgHeight),
			new Vec2(xPos, yPos + charImgHeight)
		];

		super(ArrayIndices, [xPos, yPos]);

		if (this.charWidth == 0 && image != null)
			this.charWidth = charImgWidth * size;
		if (this.charHeight == 0 && image != null)
			this.charHeight = charImgHeight * size;

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
			graphics.drawScaledSubImage(image, Std.int(animation.get() * charImgWidth) % image.width,
				Math.floor(animation.get() * charImgWidth / image.width) * charImgHeight, charImgWidth, charImgHeight, Math.round(offset.x),
				Math.round(offset.y), this.charWidth, this.charHeight);
		}
	}

	public function setImage(image:Image):Void {
		this.image = image;
	}

	public function set_active(value:Bool):Bool {
		return active = value;
	}
}

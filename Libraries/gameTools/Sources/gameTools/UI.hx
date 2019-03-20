package gameTools;

import kha.Font;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Assets;

class UserInterface {
	public var x:Int;
	public var y:Int;
	public var fontSize:Int = 16;
	public var font:Font = Assets.fonts.KenneyPixel;
	public var color:Color = Color.Black;

	private var water:Int = 0;
	private var meat:Int = 0;
	private var wood:Int = 0;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}

	public function scoreUp(itemCollected:Int):Void {
		switch itemCollected {
			case 0:
				water += 1;
			case 1:
				meat += 1;
			case 2:
				wood += 1;
			default:
				trace("Invalid item collected");
		}
	}

	public function render(g:Graphics):Void {
		g.font = font;
		g.fontSize = fontSize;
		g.drawString("Water: " + water, x, y);
		g.drawString("Meat:    " + meat, x, y + 15);
		g.drawString("Wood:    " + wood, x, y + 30);
	}
}

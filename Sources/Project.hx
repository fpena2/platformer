package;

import kha.Framebuffer;
import kha.Color;
import kha.input.KeyCode;
import kha.input.Keyboard;
import gameTools.UI;
import Player;

class Project {
	public var uiManager:UserInterface;
	public var player:Player;

	public function new() {
		uiManager = new UserInterface(10, 10);
		player = new Player(100, 100);
		Keyboard.get().notify(onKeyDown, onKeyUp);
	}

	public function update():Void {
		player.update();
	}

	public function render(framebuffer:Framebuffer):Void {
		var graphics = framebuffer.g2;

		graphics.begin(Color.fromValue(0xd8d8d8));
		player.render(graphics);
		uiManager.render(graphics);
		graphics.end();
	}

	public function onKeyDown(keyCode:KeyCode) {
		player.onKeyDown(keyCode);
	}

	public function onKeyUp(keyCode:KeyCode) {
		player.onKeyUp(keyCode);
	}
}

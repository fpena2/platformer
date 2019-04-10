package;

import kha.graphics2.Graphics;
import kha.Assets;
import kha.input.KeyCode;
import Entity;
import Animation;

class Player extends Entity {
	public var walkRight:Animation;
	public var walkLeft:Animation;
	public var idleRight:Animation;
	public var idleLeft:Animation;
	public var attackRight:Animation;
	public var attackLeft:Animation;
	// Todo: Implement jump
	// public var jumpRight:Animation;
	// public var jumpLeft:Animation;
	public var left:Bool;
	public var right:Bool;
	public var attack:Bool;
	public var rightLook = true;

	public function new(x:Int, y:Int) {
		// TODO: use super + new func to change image
		super(Assets.images.Hero, x, y, 64, 64, 4);

		attackLeft = Animation.createRange(0, 9, 3);
		attackRight = Animation.createRange(10, 19, 3);

		walkLeft = Animation.createRange(20, 27, 5);
		walkRight = Animation.createRange(30, 37, 5);

		idleLeft = Animation.createRange(40, 45, 7);
		idleRight = Animation.createRange(50, 55, 7);

		setAnimation(idleRight);
	}

	override public function update() {
		super.update();

		if (left) {
			setAnimation(walkLeft);
			velocity.x = -1;
			rightLook = false;
		} else if (right) {
			setAnimation(walkRight);
			velocity.x = 1;
			rightLook = true;
		} else if (attack && rightLook) {
			setAnimation(attackRight);
		} else if (attack && !rightLook) {
			setAnimation(attackLeft);
		} else {
			setAnimation(rightLook ? idleRight : idleLeft);
		}
	}

	override public function render(graphics:Graphics):Void {
		super.render(graphics);
	}

	public function onKeyDown(keyCode:KeyCode) {
		switch (keyCode) {
			case KeyCode.Left:
				left = true;
			case KeyCode.Right:
				right = true;
			case KeyCode.Space:
				attack = true;
			default:
				return;
		}
	}

	public function onKeyUp(keyCode:KeyCode) {
		switch (keyCode) {
			case KeyCode.Left:
				left = false;
			case KeyCode.Right:
				right = false;
			case KeyCode.Space:
				attack = false;
			default:
				return;
		}
	}
}

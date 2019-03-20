package gameTools;

class Calculate {
	public static function randomRange(min:Float, max:Float):Int {
		return Math.floor((Math.random() * (1 + max - min)) + min);
	}

	public static function toDegrees(radians:Float):Float {
		return radians * (180 / Math.PI);
	}

	public static function toRadians(degrees:Float):Float {
		return degrees * (Math.PI / 180);
	}
}

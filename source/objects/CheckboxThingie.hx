package objects;

class CheckboxThingie extends FlxSprite
{
	public var daValue(default, set):Bool;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public function new(x:Float = 0, y:Float = 0, ?checked = false) {
		super(x, y);

		frames = Paths.getSparrowAtlas('optionsbuttongay');
		animation.addByPrefix("unchecked", "OFF ", 24, false);
		animation.addByPrefix("unchecking", "RTURN", 24, false);
		animation.addByPrefix("checking", "TURN", 24, false);
		animation.addByPrefix("checked", "ON", 24, false);

		antialiasing = false;
		//setGraphicSize(Std.int(3 * width));
		updateHitbox();

		animationFinished(checked ? 'checking' : 'unchecking');
		animation.finishCallback = animationFinished;
		daValue = checked;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	private function set_daValue(check:Bool):Bool {
		if(check) {
			if(animation.curAnim.name != 'checked' && animation.curAnim.name != 'checking') {
				animation.play('checking', true);
			}
		} else if(animation.curAnim.name != 'unchecked' && animation.curAnim.name != 'unchecking') {
			animation.play("unchecking", true);
		}
		return check;
	}

	private function animationFinished(name:String)
	{
		switch(name)
		{
			case 'checking':
				animation.play('checked', true);
			case 'unchecking':
				animation.play('unchecked', true);
		}
	}
}
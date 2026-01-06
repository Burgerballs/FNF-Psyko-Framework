package objects.huds;
class GenericHUD extends BaseHUD {

    public var healthBar:Bar;
    public var iconP1:HealthIcon;
    public var iconP2:HealthIcon;

    public override function new() {
        super(0,0);
        healthBar = new Bar(0, FlxG.height * (!ClientPrefs.data.downScroll ? 0.89 : 0.11), 'healthBar', function() return health, 0, 2);
		healthBar.screenCenter(X);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		healthBar.visible = !ClientPrefs.data.hideHud;
		healthBar.alpha = ClientPrefs.data.healthBarAlpha;

        iconP1 = new HealthIcon(game.boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.data.hideHud;
		iconP1.alpha = ClientPrefs.data.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(game.boyfriend.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.data.hideHud;
		iconP2.alpha = ClientPrefs.data.healthBarAlpha;
		add(iconP2);
		add(healthBar);
        reloadHealthBarColors();
    }
    public override function reloadHealthBarColors() {
        healthBar.setColors(FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]),
			FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));

        // assume the game calls this if it needs to change chars anyways, kill 2 birds with 1 func
        iconP1.changeIcon(game.boyfriend.healthIcon);
        iconP2.changeIcon(game.dad.healthIcon);
    }

    public override function update(e:Float) {
        super.update(e);
        updateIcons(e);
    }

    public function updateIcons(e:Float) {
        var iconOffset:Int = 26;
        var mult:Float = FlxMath.lerp(1, iconP1.scale.x, Math.exp(-e * 9 * game.playbackRate));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, Math.exp(-e * 9 * game.playbackRate));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

        iconP1.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP2.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

        iconP1.animation.curAnim.curFrame = (healthBar.percent < 20) ? 1 : 0; //If health is under 20%, change player icon to frame 1 (losing icon), otherwise, frame 0 (normal)
		iconP2.animation.curAnim.curFrame = (healthBar.percent > 80) ? 1 : 0; //If health is over 80%, change opponent icon to frame 1 (losing icon), otherwise, frame 0 (normal)
    }
}
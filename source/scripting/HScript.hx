package scripting;

import haxe.Log;
import flixel.addons.effects.FlxTrail;
import crowplexus.iris.Iris;

class HScript extends Iris {
    override public function new(filePath) {
		Log.trace('Loading script located in ' + filePath);
        var text:String = File.getContent(filePath);
        super(text);

        // Setting bullshit, default vars for everywan!
		set("Std", Std);
		set("Type", Type);
		set("Reflect", Reflect);
		set("Math", Math);
		set("StringTools", StringTools);
		set("Main", Main);

		set("StringMap", haxe.ds.StringMap);
		set("ObjectMap", haxe.ds.ObjectMap);
		set("EnumValueMap", haxe.ds.EnumValueMap);
		set("IntMap", haxe.ds.IntMap);

		set("Date", Date);
		set("DateTools", DateTools);
		set("FlxTrail", FlxTrail);
		set("getClass", Type.resolveClass);
		set("getEnum", Type.resolveEnum);

        set("FlxG", FlxG);
		set("FlxSprite", FlxSprite);
		set("FlxCamera", FlxCamera);
		set("FlxSound", FlxSound);
		set("FlxMath", flixel.math.FlxMath);
		set("FlxTimer", flixel.util.FlxTimer);
		set("FlxTween", flixel.tweens.FlxTween);
		set("FlxEase", flixel.tweens.FlxEase);
		set("FlxGroup", flixel.group.FlxGroup);
		set("FlxSave", flixel.util.FlxSave); // should probably give it 1 save instead of giving it FlxSave
		set("FlxBar", flixel.ui.FlxBar);

		set("FlxBarFillDirection", flixel.ui.FlxBar.FlxBarFillDirection);
		set("FlxText", flixel.text.FlxText);
		set("FlxTextBorderStyle", flixel.text.FlxText.FlxTextBorderStyle);
		set("FlxCameraFollowStyle", flixel.FlxCamera.FlxCameraFollowStyle);

		set("FlxRuntimeShader", flixel.addons.display.FlxRuntimeShader);

		set("FlxParticle", flixel.effects.particles.FlxParticle);
		set("FlxTypedEmitter", flixel.effects.particles.FlxEmitter.FlxTypedEmitter);
		set("FlxSkewedSprite", flixel.addons.effects.FlxSkewedSprite);

		set("FlxPoint", {
			get: FlxPoint.get,
			weak: FlxPoint.weak
		});
    }
}
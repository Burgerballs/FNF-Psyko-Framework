package scripting;

import flixel.addons.effects.FlxTrail;
import crowplexus.iris.Iris;

class HScript extends Iris {
    override public function new(filePath) {
        var text:String = Paths.getTextFromFile(filePath);
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
    }
}
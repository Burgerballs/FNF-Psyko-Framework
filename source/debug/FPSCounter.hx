package debug;

import external.Memory;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends Sprite
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryGC(get, never):Float;

	public var memoryApp(get, never):Float;

	public var text:TextField;
	public var bg:Bitmap;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		bg = new Bitmap(new BitmapData(1, 1, true, 0x61000000));
		addChild(bg);

		text = new TextField();
		text.selectable = false;
		text.mouseEnabled = false;
		text.defaultTextFormat = new TextFormat("_sans", 12, color);
		text.autoSize = LEFT;
		text.multiline = true;
		text.text = "FPS: ";
		addChild(text);

		currentFPS = 0;


		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();
		// prevents the overlay from updating every frame, why would you need to anyways @crowplexus
		if (deltaTimeout < 50) {
			deltaTimeout += deltaTime;
			return;
		}

		currentFPS = times.length;		
		updateText();
		bg.width = text.width + 2;
		bg.height = text.height;
		deltaTimeout = 0.0;
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		text.text = 'FPS: ${currentFPS} • Memory: [APP: ${flixel.util.FlxStringUtil.formatBytes(memoryApp)} | GC: ${flixel.util.FlxStringUtil.formatBytes(memoryGC)}]';

		text.textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			text.textColor = 0xFFFF0000;
	}

	inline function get_memoryGC():Float
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
	inline function get_memoryApp():Float
		return Memory.getCurrentUsage();
}

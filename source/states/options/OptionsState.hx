package states.options;

class OptionsState extends MusicBeatState
{
	var bg:FlxSprite;
    var daSubstate:OptionsSubstate;
	override function create()
	{
		persistentUpdate = true;
		persistentDraw = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFA75AFF;
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();
        daSubstate = new OptionsSubstate();
		daSubstate.goBack = (changedOptions:Array<String>)->{
			MusicBeatState.switchState(new MainMenuState());
		};

        FlxG.sound.playMusic(Paths.music('options'));
        super.create();

        openSubState(daSubstate);
    }
}
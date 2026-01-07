package objects.huds;

import flixel.util.FlxStringUtil;

class SignatureHUD extends GenericHUD {
    public var scoreTxt:FlxText;
    public var accuracyTxt:FlxText;
    public var extraTxt:FlxText;
    public var timeTxt:FlxText;
    public var timeBar:Bar;
    public var songPercent:Float = 0;

    public override function new() {
        super();
        scoreTxt = new FlxText(healthBar.x - 4, healthBar.y + 24, healthBar.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.data.hideHud;
		add(scoreTxt);

        accuracyTxt = new FlxText(-8, 8, FlxG.width, "100%", 20);
		accuracyTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		accuracyTxt.scrollFactor.set();
		accuracyTxt.borderSize = 1.25;
		accuracyTxt.visible = !ClientPrefs.data.hideHud;
		add(accuracyTxt);

        extraTxt = new FlxText(-8, 8 + 34, FlxG.width, "Misses: 0\nRank: SS++++\nFlag: SFC", 20);
		extraTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		extraTxt.scrollFactor.set();
		extraTxt.borderSize = 1.25;
		extraTxt.visible = !ClientPrefs.data.hideHud;
		add(extraTxt);

		var showTime:Bool = (ClientPrefs.data.timeBarType != 'Disabled');
		timeTxt = new FlxText(42 + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = game.updateTime = showTime;
		if(ClientPrefs.data.downScroll) timeTxt.y = FlxG.height - 44;
		if(ClientPrefs.data.timeBarType == 'Song Name') timeTxt.text = PlayState.SONG.song;

		timeBar = new Bar(0, timeTxt.y + (timeTxt.height / 4), 'timeBar', function() return songPercent, 0, 1);
		timeBar.scrollFactor.set();
		timeBar.screenCenter(X);
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		add(timeBar);
		add(timeTxt);
    }

    override function update(e:Float) {
        super.update(e); 
        
        if (!game.paused && game.updateTime)
		{
			var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset);
			songPercent = (curTime / game.songLength);

			var songCalc:Float = (game.songLength - curTime);
			if(ClientPrefs.data.timeBarType == 'Time Elapsed') songCalc = curTime;

			var secondsTotal:Int = Math.floor(songCalc / 1000);
			if(secondsTotal < 0) secondsTotal = 0;

			if(ClientPrefs.data.timeBarType != 'Song Name')
				timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
		}
    }

    override function startSong() {
        super.startSong();
        FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
    }

    public override function updateScore() {
		if (game.stats.hitPoints != 0)
		{
			var percent:Float = CoolUtil.floorDecimal(ratingPercent * 100, 3);

			accuracyTxt.text = '${percent}%';
            extraTxt.text = 'Misses: ${game.songMisses}\nRank: [${ratingFC} | ${ratingName}]\nNPS: [${game.nps} / ${game.stats.data.maxNPS}]';
		} else {
            accuracyTxt.text = '';
            extraTxt.text = '';
        }

		scoreTxt.text = 'Score: ' + game.songScore;
    }
}
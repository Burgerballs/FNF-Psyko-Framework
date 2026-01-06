package objects.huds;

class BaseHUD extends FlxSpriteGroup {
    public var game(get, never):PlayState;
    public function get_game() { return PlayState.instance; }

    public var ratingName(get, never):String;
    public function get_ratingName() { return PlayState.instance.ratingName; }

    public var ratingPercent(get, never):Float;
    public function get_ratingPercent() { return PlayState.instance.ratingPercent; }

    public var ratingFC(get, never):String;
    public function get_ratingFC() { return PlayState.instance.ratingFC; }

    public var curBeat(get, never):Int;
    public function get_curBeat() { return Conductor.curBeat; }

    public var curStep(get, never):Int;
    public function get_curStep() { return Conductor.curStep; }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    public function beatHit() {}
    public function stepHit() {}
    public function endSong() {}
    public function startSong() {}
    public function startCountdown() {}
    public function updateScore() {}
    public function reloadHealthBarColors() {}
    public function goodNoteHit(note:Note) {}
}
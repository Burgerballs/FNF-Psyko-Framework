package states.options;

enum OptionType {
    CHOICE;
    NUM;
    BOOL;
}

class OptionsSubstate extends MusicBeatSubstate {
    public var goBack:(Array<String>)->Void;

    public var masterList:Array<Dynamic> = [
        {
            name: "Gameplay",
            options: [
                {
                    name: 'Downscroll',
                    type: BOOL,
                    def: false
                }
            ]
        },
        {
            name: "Display",
            options: [
                {
                    name: 'Downscroll',
                    type: BOOL,
                    def: false
                }
            ]
        },
        {
            name: "Graphics",
            options: [
                {
                    name: 'Downscroll',
                    type: BOOL,
                    def: false
                }
            ]
        },
        {
            name: "Accessibility",
            options: [
                {
                    name: 'Downscroll',
                    type: BOOL,
                    def: false
                }
            ]
        },
        {
            name: "Credits",
            options: [
                {
                    name: 'Downscroll',
                    type: BOOL,
                    def: false
                }
            ]
        },
        {
            name: "Data",
            options: [
                {
                    name: 'Downscroll',
                    type: BOOL,
                    def: false
                }
            ]
        },
        {
            name: "Controls",
            options: [
                {
                    name: 'Downscroll',
                    type: BOOL,
                    def: false
                }
            ]
        }
    ];
    public var optionsCamera:FlxCamera;
    public var curSelect:Array<Int> = [0,0];
    public var selectaroo:FlxSprite;
    public var selectarooOpt:FlxSprite;
    public var fadeThing:FlxSprite; // the thing that darkens the category panel
    public var fadeThingOpt:FlxSprite; // the thing that darkens the options panel
    public var categoryTxts:Array<FlxText> = [];

    public var onOptionsPanel:Bool = false;

    override function create()
	{
		//var startTime = Sys.cpuTime();
		// ClientPrefs.load();
		persistentDraw = true;
		persistentUpdate = true;

		optionsCamera = new FlxCamera(FlxG.width * 0.05, FlxG.height * 0.05, Std.int(FlxG.width * 0.9), Std.int(FlxG.height * 0.9));
		optionsCamera.bgColor = 0x9A000000;
        FlxG.cameras.add(optionsCamera, false);
        cameras = [optionsCamera];

        var bgThing = new FlxSprite(0,0).makeGraphic(Std.int(optionsCamera.width * 0.25), Std.int(optionsCamera.height), 0x9A000000);
        add(bgThing);

        selectaroo = new FlxSprite(0, Std.int(optionsCamera.height * 0.5) - 14).makeGraphic(Std.int(optionsCamera.width * 0.25), 28, 0xFFFFFFFF);
        add(selectaroo);

        selectarooOpt = new FlxSprite(Std.int(optionsCamera.width * 0.25), Std.int(optionsCamera.height * 0.5) - 24).makeGraphic(Std.int(optionsCamera.width * 0.75), 48, 0xFFFFFFFF);
        add(selectarooOpt);

        var it = 0;
        for (i in masterList) {
            var categoryTxt = new FlxText(4, 4 + (it * 32), 0, i.name, 20);
            categoryTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
            categoryTxt.visible = !ClientPrefs.data.hideHud;
            add(categoryTxt);
            categoryTxts.push(categoryTxt);
            it++;
        }

        fadeThing = new FlxSprite(0,0).makeGraphic(Std.int(optionsCamera.width * 0.25), Std.int(optionsCamera.height), 0x67000000);
        add(fadeThing);

        fadeThingOpt = new FlxSprite(optionsCamera.width * 0.25,0).makeGraphic(Std.int(optionsCamera.width * 0.75), Std.int(optionsCamera.height), 0x67000000);
        add(fadeThingOpt);

        fadeThing.visible = false;
        updateTxts();
        
    }

    function selectX(mod:Int) {
        curSelect[0] = FlxMath.wrap(curSelect[0]+mod, 0, masterList.length-1);
        updateTxts();
    }
    override function update(e:Float) {
        super.update(e);
        if (controls.UI_UP_P) {
            if (!onOptionsPanel)
                selectX(-1);
        } else if (controls.UI_DOWN_P) {
            if (!onOptionsPanel)
                selectX(1);
        }
        if (controls.ACCEPT) {
            trace('a');
            if (!onOptionsPanel) {
                onOptionsPanel = true;
            }
        } else if (controls.BACK) {
            if (onOptionsPanel) {
                onOptionsPanel = false;
            } else {
                goBack([]);
            }
        }
        var it = 0;
        for (i in categoryTxts) {
            i.y = FlxMath.lerp(i.y, selectaroo.y - 2 + ((it-curSelect[0]) * 32), e*18);
            it++;
        }
        fadeThing.visible = onOptionsPanel;
        fadeThingOpt.visible = !onOptionsPanel;
    }

    function updateTxts() {
        var it = 0;
        for (i in categoryTxts) {
            if (it == curSelect[0])
                i.color = 0xFF000000;
            else
                i.color = 0xFFFFFFFF;
            it++;
        }
    }
}
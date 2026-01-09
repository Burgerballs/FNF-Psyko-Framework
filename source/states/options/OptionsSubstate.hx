package states.options;

import objects.CheckboxThingie;

using StringTools;

enum OptionType {
    CHOICE;
    NUM;
    BOOL;
}


class Selectee extends FlxSpriteGroup {
    public var valueTxt:FlxText;
    public var valueName = 'downScroll';
    public var checkbox:CheckboxThingie;
    public var destAlpha:Float = 0;
    public var type:OptionType = BOOL;
    public var optionData:Dynamic;
    public var categoryTxt:FlxText;
    public var descTxt:FlxText;
    public var colorText = 0xFF000000;
    override public function new(optionData) {
        super();
        this.optionData = optionData;
        this.valueName = optionData.val ?? 'downScroll';
        this.type = optionData.type ?? BOOL;
        categoryTxt = new FlxText(4, 4, 0, optionData.name, 20);
        categoryTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
        add(categoryTxt);

        descTxt = new FlxText(4, 28, 0, optionData.desc, 20);
        descTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
        add(descTxt);

        valueTxt = new FlxText(0, 4, Std.int((FlxG.width * 0.9) * 0.75) - 8, '< Value >', 20);
        valueTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
        add(valueTxt);

        if (type == BOOL) {
            checkbox = new CheckboxThingie(0,4,Reflect.getProperty(ClientPrefs.data, valueName));
            add(checkbox);
            checkbox.updateHitbox();
            checkbox.x = Std.int((FlxG.width * 0.9) * 0.75) - checkbox.width - 16;
            valueTxt.visible = false;
        }

        updateText();
    }

    public function dirAction(mod:Int) {
        if (type == NUM) {
            Reflect.setProperty(ClientPrefs.data, valueName, Reflect.getProperty(ClientPrefs.data, valueName) + mod);
        }
    }

    public function enterAction() {
        if (type == BOOL)
            Reflect.setProperty(ClientPrefs.data, valueName, !Reflect.getProperty(ClientPrefs.data, valueName));
        updateText();
        trace(Reflect.getProperty(ClientPrefs.data, valueName));
    }

    public function updateText() {
        if (type == BOOL || type == CHOICE) {
            valueTxt.text = '< ${Reflect.getProperty(ClientPrefs.data, valueName)} >';
            checkbox.daValue = Reflect.getProperty(ClientPrefs.data, valueName);
        } else if (type == NUM) {
            var str = Std.string(Reflect.getProperty(ClientPrefs.data, valueName));
            str = (optionData.format ?? '[#]').replace('[#]', str).replace('[#h]', Std.string(Reflect.getProperty(ClientPrefs.data, valueName) * 100));
            valueTxt.text = '< $str >';
        }
    }

    override function update(e:Float) {
        super.update(e);
        for (i in [categoryTxt, descTxt, valueTxt]) {
            i.color = colorText;
        }
        alpha = FlxMath.lerp(alpha, destAlpha, e*18);
    }
}

class OptionsSubstate extends MusicBeatSubstate {
    public var goBack:(Array<String>)->Void;

    public var masterList:Array<Dynamic> = [
        {
            name: "Gameplay",
            options: [
                {
                    name: 'Downscroll',
                    desc: "If enabled, notes will scroll, down.",
                    type: BOOL,
                    val: "downScroll",
                    def: false
                },
                {
                    name: 'Centered Notefield',
                    desc: "If enabled, your notefield will be centered horizontally.",
                    type: BOOL,
                    val: "middleScroll",
                    def: false
                },
                {
                    name: 'Ghost Tapping',
                    desc: "If enabled, the mechanic where you take damage on strum input is disabled.",
                    type: BOOL,
                    def: true,
                    val: 'ghostTapping'
                },
                {
                    name: 'Auto Pause',
                    type: BOOL,
                    desc: 'If enabled, the game will pause automatically upon the game\'s window losing focus.',
                    def: true,
                    val: 'autoPause'
                },
                {
                    name: 'Disable Reset Button',
                    type: BOOL,
                    desc: 'If enabled, the RESET keybind will not cause a death in normal gameplay.',
                    def: false,
                    val: 'noReset'
                },
                {
                    name: 'Hitsound Volume',
                    type: NUM,
                    desc: 'The volume of the sound that plays when you hit a note',
                    def: false,
                    val: 'hitsoundVolume',
                    format: '[#h]%'
                }
            ]
        },
        {
            name: "Display",
            options: [
                {
                    name: 'Low Quality',
                    type: BOOL,
                    def: false
                },
                {
                    name: 'Anti-Aliasing',
                    type: BOOL,
                    def: false
                },
                {
                    name: 'Shaders',
                    type: BOOL,
                    def: false
                },
                {
                    name: 'GPU Caching',
                    type: BOOL,
                    def: false
                },
                {
                    name: 'FPS Limit',
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
    public var selectees:Array<Array<Selectee>> = [];

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
            var optArr:Array<Dynamic> = i.options;
            var opts = [];
            for (o in optArr) {
                var opt = new Selectee(o);
                add(opt);
                opts.push(opt);
            }
            selectees.push(opts);
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
        curSelect[1] = 0;
        updateTxts();
    }
    function selectY(mod:Int) {
        curSelect[1] = FlxMath.wrap(curSelect[1]+mod, 0, Std.int(masterList[curSelect[0]].options.length - 1));
        updateTxts();
    }
    override function update(e:Float) {
        super.update(e);
        if (controls.UI_UP_P) {
            if (!onOptionsPanel)
                selectX(-1);
            else
                selectY(-1);
        } else if (controls.UI_DOWN_P) {
            if (!onOptionsPanel)
                selectX(1);
            else
                selectY(1);
        }
        if (controls.ACCEPT) {
            trace('a');
            if (!onOptionsPanel) {
                onOptionsPanel = true;
            } else {
                selectees[curSelect[0]][curSelect[1]].enterAction();
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
        it = 0;
        for (i in selectees) {
            it = 0;
            for (sel in i) {
                sel.x = selectarooOpt.x + 8;
                sel.y = FlxMath.lerp(sel.y, selectarooOpt.y - 2 + ((it-curSelect[1]) * 48), e*18);
                it++;
            }
            
        }
        fadeThing.visible = onOptionsPanel;
        fadeThingOpt.visible = !onOptionsPanel;
    }

    function updateTxts() {
        var it = 0;
        for (i in categoryTxts) {
            if (it == curSelect[0]) {
                i.color = 0xFF000000;
            }
            else {
                i.color = 0xFFFFFFFF;
            }
            it++;
        }
        var it = 0;
        for (i in selectees) {
            var destAlpha = it == curSelect[0] ? 1 : 0;
            var ite = 0;
            for (sel in i) {
                if (ite == curSelect[1]) {
                    sel.colorText = 0xFF000000;
                }
                else {
                    sel.colorText = 0xFFFFFFFF;
                }
                sel.destAlpha = destAlpha;
                ite++;
            }
            it++;
        }
    }
}
package backend;

typedef NoteDiff = {
    ms:Float,
    absMs:Float,
    judgement:String
};
typedef JudgeData = {
    name:String,
    count:Int,
    percent:Float
}
typedef StatsData = {
    diffs:Array<NoteDiff>,
    judges:Array<JudgeData>,
    accuracy:Float,
    flag:String,
    rank:String,
    misses:Int,
    score:Int,
    maxNPS:Float
};

class Stats {
    public var data:StatsData;
    public var hitPoints:Float = 0;
    public var accPoints:Float = 0;
    public var ratingsData:Array<Rating> = null;
    public static var instance:Stats;
    
	public static final missWeight:Float = -5.5;
	public static final mineWeight:Float = -7;
	public static final holdDropWeight:Float = -4.5;
	
	static inline final a1 = 0.254829592;
	static inline final a2 = -0.284496736;
	static inline final a3 = 1.421413741;
	static inline final a4 = -1.453152027;
	static inline final a5 = 1.061405429;
	static inline final p = 0.3275911;
    
    public static var ratingStuff:Array<Dynamic> = [
        ['SS+++', 1], // 4-star
        ["SS++", 0.99], // 3-star
        ["SS+", 0.98], // 2-star
        ["SS", 0.96], // 1-star
        ["S+", 0.94],
        ["S", 0.92],
        ["S-", 0.89],
        ["A+", 0.86],
        ["A", 0.83],
        ["A-", 0.8],
        ["B+", 0.76],
        ["B", 0.72],
        ["B-", 0.68],
        ["C+", 0.64],
        ["C", 0.6],
        ["C-", 0.5],
        ["D+", 0.5],
        ["D", 0.45],
        ["D-", 0.01],
        ["F", -1],
	];

    public function new() {
        data = {
            diffs: [],
            judges: [],
            accuracy: 0,
            flag: '?',
            score: 0,
            rank: '?',
            misses: 0,
            maxNPS: 0,
        };
        ratingsData = Rating.loadDefault();
        Stats.instance = this;
    }

    public function updateRatings() {
		var sicks:Int = ratingsData[0].hits;
		var goods:Int = ratingsData[1].hits;
		var bads:Int = ratingsData[2].hits;
		var shits:Int = ratingsData[3].hits;
		data.flag = "";
		if(data.misses == 0)
		{
			if (bads > 0 || shits > 0) data.flag = 'FC';
            else if (goods > 10) data.flag = 'GFC';
            else if (goods > 0) data.flag = 'SDG';
			else if (sicks > 0) data.flag = 'SFC';
		}
		else
			if (data.misses < 10) data.flag = 'SDCB';
        data.rank = '?';
        if(hitPoints != 0)
        {
            data.accuracy = Math.min(1, Math.max(0, accPoints / hitPoints));
            trace(data.accuracy);
            data.rank = ratingStuff[ratingStuff.length-1][0];
            for (i in 0...ratingStuff.length-1)
                if(data.accuracy <= ratingStuff[i][1])
                {
                    data.rank = ratingStuff[i][0];
                    break;
                }
        }
    }

    public static function werwerwerwerf(x:Float):Float
	{
		var neg = x < 0;
		x = Math.abs(x);
		var t = 1 / (1+p*x);
		var y = 1 - (((((a5*t+a4)*t)+a3)*t+a2)*t+a1)*t*Math.exp(-x*x);
		return neg ? -y : y;
	}

    public static function getAcc(noteDiff:Float):Float { // https://github.com/etternagame/etterna/blob/0a7bd768cffd6f39a3d84d76964097e43011ce33/src/RageUtil/Utils/RageUtil.h
		var ts:Float=1;
		var jPow:Float = 0.75;
		var maxPoints:Float = 2.0;
		var ridic:Float = 5 * ts;
		var shit_weight:Float = 200;
		var absDiff = Math.abs(noteDiff);
		var zero:Float = 65 * Math.pow(ts, jPow);
		var dev:Float = 22.7 * Math.pow(ts, jPow);

		if(absDiff<=ridic){
			return maxPoints;
		}else if(absDiff<=zero){
			return maxPoints*werwerwerwerf((zero-absDiff)/dev);
		}else if(absDiff<=shit_weight){
			return (absDiff-zero)*missWeight/(shit_weight-zero);
		}
		return missWeight;
	}
	public function judgeNote(diff:Float=0, bp:Bool = false):Rating // die
	{
		var data:Array<Rating> = ratingsData;
        var ret:Rating = null;
		for(i in 0...data.length-1) {
			if (diff <= data[i].hitWindow) {
                ret = data[i];
                break;
            }
        }
        if (ret == null)
            ret = data[data.length - 1];
        if (!bp) {
            accPoints += getAcc(diff);
            hitPoints+=2;
            this.data.score += ret.score;
        }
		return ret;
	}

    public function miss() {
        data.score -= 10;
        data.misses++;
        hitPoints+=5;
        updateRatings();
    }
}
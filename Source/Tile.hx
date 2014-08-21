package;

import motion.Actuate;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import Std;

class Tile extends Sprite {

    public static var tilesize = 100;
    public static var margin = 4;

    public var tileValue:Int;
	public var X:Int;
	public var Y:Int;

    var box:Sprite;
    var text:TextField;
    var textformat:TextFormat;

    public function new() {
        super();

        initialize();
    }

    private function initialize() {

        var rand = current_color_index = Std.random(values.length);

        tileValue = values[rand];

        textformat = new TextFormat();
        textformat.size = 40;
        textformat.align = TextFormatAlign.CENTER;

        text = new TextField();
        text.selectable = false;
        text.defaultTextFormat = textformat;
        text.text = "" + tileValue;

        text.y = 22;

        box = new Sprite();

        drawBox();

        addChild(box);
        addChild(text);
    }

    public function drawBox() {
        box.graphics.beginFill(getColor(), 1);
        box.graphics.drawRect(margin, margin, tilesize - margin * 2, tilesize - margin * 2);
    }

    public function destroy() {
        parent.removeChild(this);
    }

	public function setPos(x:Int, y:Int) {
		this.X = x;
		this.Y = y;

		// graphical x and y
		this.x = x * tilesize;
		this.y = y * tilesize;
	}

    private function getColor() {
        return colors[current_color_index < colors.length ? current_color_index : colors.length - 1];
    }

	public function Increment(rhs = -1) {
        current_color_index++;

        drawBox();

        tileValue += rhs;
        text.text = "" + tileValue;
	}

    // starting values (randomized within these values)
	private var values = [2,4];

    private var current_color_index = 0;
    private var colors = [
        0xFFD175,
        0xFF9900,
        0x99CC00,
        0x66FFFF,
        0x66CCFF,
        0x9999FF,
        0xCC6699,
        0xFF6699,
        0x00CC66,
        0x339966,
        0xFFFFFF
    ];
}
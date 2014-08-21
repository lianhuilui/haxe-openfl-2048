package;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.events.MouseEvent;

class Button extends Sprite {

    private var buttonText:String;
    private var textField:TextField;

    private function initialize() {
        var format = new TextFormat();
        format.color = 0xFFFFFF;
        format.size = 20;
        format.align = TextFormatAlign.CENTER;

        textField = new TextField();

        textField.x = 0;
        textField.y = 7;
        textField.selectable = false;
        textField.defaultTextFormat = format;
        textField.width= 200;
        textField.height = 40;

        addChild(textField);
    }

    public function setText(text) {
        buttonText = text;
        textField.text = buttonText;
    }

    public function getText() {
        return buttonText;
    }

    public function new() {
        super();

        initialize();

        graphics.beginFill(0x0000FF, 1);
        graphics.drawRect(0, 0, 200, 40);

        addChild(textField);

        this.addEventListener(MouseEvent.CLICK, runOnClick);
    }

    private var callbacks:Array<Dynamic>;

    public function onClick(callback:Dynamic) {
        if (callbacks == null)
            callbacks = new Array<Dynamic>();

        callbacks.push(callback);
    }

    public function runOnClick(event:MouseEvent) {
        for (i in 0 ... callbacks.length) {
            callbacks[0]();
        }
    }
}
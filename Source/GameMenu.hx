package;

import flash.display.Stage;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class GameMenu extends Sprite {

    var NewGameButton:Sprite;
    var ExitButton:Sprite;

    var textFormat:TextFormat;
    var newGameText:TextField;
    var exitText:TextField;

    public function new() {
        super();

        textFormat = new TextFormat();

        textFormat.size = 30;
        textFormat.color = 0xFFFFFF;
        textFormat.align = TextFormatAlign.CENTER;

        NewGameButton = new Sprite();

        NewGameButton.x = 0;
        NewGameButton.y = 0;
        NewGameButton.width = 200;
        NewGameButton.graphics.beginFill(0x0000FF, 1);
        NewGameButton.graphics.drawRect(0, 0, 200, 40);

        newGameText = new TextField();
        newGameText.selectable = false;
        newGameText.width = 200;
        newGameText.defaultTextFormat = textFormat;
        newGameText.text = "NEW GAME";
        NewGameButton.addChild(newGameText);

        ExitButton = new Sprite();

        ExitButton.x = 0;
        ExitButton.y = 50;
        ExitButton.width = 200;
        ExitButton.graphics.beginFill(0xFF0000, 1);
        ExitButton.graphics.drawRect(0, 0, 100, 20);

        exitText = new TextField();
        exitText.selectable = false;
        exitText.width = 200;
        exitText.defaultTextFormat = textFormat;
        exitText.text = "EXIT";
        ExitButton.addChild(exitText);

        NewGameButton.addEventListener(MouseEvent.MOUSE_DOWN, clickEventHandler);

        addChild(NewGameButton);
        /** NO ESCAPE **/
//        addChild(ExitButton);

        trace ("NEW FINISHED ON MENU");
    }

    private var onStartCallback:Dynamic;

    private function clickEventHandler(event:MouseEvent) {
        if (onStartCallback != null)
            onStartCallback();
    }

    public function onStartClicked(callback:Dynamic) {
        onStartCallback = callback;
    }
}
package;

import flash.display.Sprite;

class ButtonGroup extends Sprite {
    public function new() {
        super();
        var button = new Button();
        var button2 = new Button();
        var button3 = new Button();

        button.x = 200;
        button.y = 200;

        button3.x = 100;
        button3.y = 100;

        button.setText("ONE");
        button2.setText("TWO");
        button3.setText("THREE");

        button.onClick(function() { button.setText(button.getText() + ".");});
        button2.onClick(function() { button2.setText(button3.getText() + "!");});
        button3.onClick(function() { button3.setText(button2.getText() + "?");});

        addChild(button);
        addChild(button2);
        addChild(button3);
    }
}
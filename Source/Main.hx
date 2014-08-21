package;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.Assets;

class Main extends Sprite {

    private var game:Game;
//    private var gamemenu:GameMenu;

    private var gamemenu:Sprite;
    private var gameoverText:TextField;
    private var overlay:Sprite;

    private var scoreboard:Sprite;
    private var scoreText:TextField;

    private var scoreOverlay:TextField;

    private static var scoreboardheight = 50;

    private static var NUM_TILES = 4;

    private var textFormat:TextFormat;
    private var scoreTextFormat:TextFormat;

    public function new() {
        super();
        initialize();

//        var btnGroup = new ButtonGroup();

//        btnGroup.x = 100;
//        btnGroup.y = 100;

//        addChild(btnGroup);
    }

    private function initialize() {

        showscoreboard();
        showmenu();
//        startgame();

		stage.addEventListener (KeyboardEvent.KEY_DOWN, game_onKeyDown);
    }

    private function showscoreoverlay() {
        scoreOverlay = new TextField();

        var format = new TextFormat();
        format.color = 0xFF0000;
        format.size = 35;
        format.align = TextFormatAlign.CENTER;

        scoreOverlay.y = 250;
        scoreOverlay.width = NUM_TILES * 100;
        scoreOverlay.defaultTextFormat = format;
        scoreOverlay.text = "YOU SCORED " + game.getScore();

        addChild(scoreOverlay);
    }

    private function showscoreboard() {

        scoreboard = new Sprite();
        scoreText = new TextField();
        scoreTextFormat = new TextFormat();

        scoreTextFormat.color = 0x0000FF;
        scoreTextFormat.size = 20;

        scoreText.defaultTextFormat = scoreTextFormat;
//        scoreText.width = NUM_TILES * 100;

        scoreboard.addChild(scoreText);
//        scoreboard.width = NUM_TILES * 100;
//        scoreboard.height = scoreboardheight;

        addChild(scoreboard);
    }

    private function showoverlay() {
        overlay = new Sprite();

        overlay.graphics.beginFill(0x000000, 0.75);
        overlay.graphics.drawRect(0, 0, NUM_TILES * 100, NUM_TILES * 100 + scoreboardheight);

        addChild(overlay);
    }

    private function showgameover() {
        gameoverText = new TextField();

        if (textFormat == null) {
            textFormat = new TextFormat();
            textFormat.color = 0xFF0000;
            textFormat.size = 30;
            textFormat.align = TextFormatAlign.CENTER;
        }

        gameoverText.defaultTextFormat = textFormat;
        gameoverText.text = "GAME OVER";
        gameoverText.selectable = false;
        gameoverText.y = 50 + scoreboardheight;
        gameoverText.width = 100 * NUM_TILES;
        gameoverText.x = 50 * NUM_TILES - gameoverText.width / 2;

        this.addChild(gameoverText);
    }

    private function newgame() {

        removeChild(gamemenu);

        if (game == null) {
            startgame();
        } else {
            restartgame();
        }
    }

    private function restartgame() {
        if (game != null) removeChild(game);
        if (gameoverText != null) removeChild(gameoverText);
        if (gamemenu != null) removeChild(gamemenu);
        if (scoreOverlay != null) removeChild(scoreOverlay);
        if (overlay != null) removeChild(overlay);

        startgame();
    }

    private function startgame() {
        game = new Game(NUM_TILES, NUM_TILES);
        game.y = scoreboardheight;
        game.onDead(onDead);
        addChild(game);

        updateScore();
    }

    private function onDead() {
        showoverlay();
        showgameover();
        showscoreoverlay();
        showmenu();
    }

    private function showmenu() {
//        gamemenu = new GameMenu();

        // tiles are 100.
        // gamemenu is 200 wide
        // so x should be (tile_width / 2) * numtiles - (menu_width / 2)
//        gamemenu.x = 50 * NUM_TILES - 100;
//        gamemenu.y = 100 + scoreboardheight;

//        gamemenu.onStartClicked(startgame);

        gamemenu = new Sprite();

        var button = new Button();
        button.setText("NEW GAME");

        button.onClick(newgame);

        button.y = 100 + scoreboardheight;
        button.x = 50 * NUM_TILES - 100;

/*        var button2 = new Button();
        button2.setText("EXIT");

        button2.x = 100;
        button2.y = 50;*/

        gamemenu.addChild(button);

        addChild(gamemenu);
//        addChild(button2);
        //addChild(gamemenu);

//        trace("ADDED MENU");
    }

	private function game_onKeyDown(event:KeyboardEvent) {

        if (game == null)
            return;

		switch(event.keyCode) {
			case Keyboard.UP:
				game.move('up');

			case Keyboard.DOWN:
				game.move('down');

			case Keyboard.LEFT:
				game.move('left');

			case Keyboard.RIGHT:
				game.move('right');
		}

        updateScore();
        // game.tracedebug();
	}

    private function updateScore() {
        scoreText.text = "Score: " + game.getScore();
    }
}

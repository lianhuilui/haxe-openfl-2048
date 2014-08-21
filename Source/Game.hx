package;

import flash.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import motion.Actuate;
import Std;

import openfl.Assets;

class Game extends Sprite {

    private var NUM_COLUMNS:Int;
    private var NUM_ROWS:Int;

    private static var MAX_NUM_NEW_TILES = 1;

    private var textField:TextField;
	private var textFormat:TextFormat;

    private var tiles:Array<Array<Tile>>;

    private var score = 0;
    private var maxtile = 0;

    public function new(cols = 3, rows = 3) {
        super();

        NUM_COLUMNS = cols;
        NUM_ROWS = rows;

        tiles = new Array<Array<Tile>>();

        for (i in 0 ... NUM_ROWS) {
			tiles.push(new Array<Tile>());
            for (j in 0 ... NUM_COLUMNS) {
				tiles[i].push(null);
			}
		}

        var bg = new Sprite();

        bg.graphics.beginFill(0xFF99AA, 0.4);
        bg.graphics.drawRect(0, 0, 100 * NUM_COLUMNS, 100 * NUM_ROWS);

        addChild(bg);

        newtile();
    }

    private function gravity(dir:String, trial:Bool = false) {
        var moved = false;

        switch(dir) {
            case "up":
                for (i in 0 ... NUM_COLUMNS)
                    moved = gravity_pull(i, 0, 0, -1, trial) || moved;

            case "down":
                for (i in 0 ... NUM_COLUMNS)
                    moved = gravity_pull(i, NUM_ROWS - 1, 0, 1, trial) || moved;

            case "left":
                for (i in 0 ... NUM_ROWS)
                    moved = gravity_pull(0, i, -1, 0, trial) || moved;

            case "right":
                for (i in 0 ... NUM_ROWS)
                    moved = gravity_pull(NUM_COLUMNS - 1, i, 1, 0, trial) || moved;

        }

        return moved;
    }

    public function move(dir:String):Bool {

        var moved = gravity(dir);

        if (isDead()) {
            return false;
        }

        if (moved) {
            var random_num_tiles = Std.random(MAX_NUM_NEW_TILES) + 1;
//            trace('making $random_num_tiles tiles');
            for (i in 0 ... random_num_tiles)
                newtile();
        }

        if (isDead()) {
            return false;
        }

        return moved;
    }

    private function next_tile(x, y, dir_x, dir_y):Tile {
        if (x < 0 || x >= NUM_COLUMNS || y < 0 || y >= NUM_ROWS)
            return null;

        if (tiles[x][y] != null) {
            return tiles[x][y];
        } else {
            return next_tile(x - dir_x, y - dir_y, dir_x, dir_y);
        }
    }

	private function gravity_pull(x, y, dir_x, dir_y, trial:Bool = false):Bool {

        var affected_tiles = new Array<Tile>();

		var next_x = x - dir_x;
		var next_y = y - dir_y;

		if (next_x < 0 || next_x >= NUM_COLUMNS || next_y < 0 || next_y >= NUM_ROWS)
			return false;

        var current_tile = next_tile(x, y, dir_x, dir_y);

        while (current_tile != null) {
            affected_tiles.push(current_tile);
            current_tile = next_tile(current_tile.X - dir_x, current_tile.Y - dir_y, dir_x, dir_y);
        }

        // we want queue, not stack
        affected_tiles.reverse();

        var tile:Tile = null;
        var prev:Tile = null;
        var moved = false;

        while (affected_tiles.length > 0) {
            tile = affected_tiles.pop();

            // check if we can merge them
            if (prev != null && prev.tileValue == tile.tileValue) {

                if (!trial) {
                    addScore(prev.tileValue, tile.tileValue);

                    // merging
                    prev.Increment(tile.tileValue);

                    if (prev.tileValue > maxtile)
                        maxtile = prev.tileValue;

                    // unsetting old tile
                    tiles[tile.X][tile.Y] = null;

                    Actuate
                    .tween(tile, 0.3, {x: prev.x, y: prev.y, alpha: 0})
                    .onComplete(function(tile) {
                        return function() {
                            tile.destroy();
                        }
                    }(tile));

                    tile = null;
                }
                moved = true;

            } else {
                if (tile.X != x || tile.Y != y) {
                    if (!trial) {
                        // unsetting old tile
                        tiles[tile.X][tile.Y] = null;

                        Actuate
                            .tween(tile, 0.3, {x: x * 100, y: y * 100});

                        // assigning tile on x, y
                        tiles[x][y] = tile;

                        // set them manually because we animated already
                        tile.X = x;
                        tile.Y = y;
                        // tile.setPos(x, y);
                    }
                    moved = true;
                }

                // move the pointer for "tile" (current tile) in the direction specified
                x -= dir_x;
                y -= dir_y;
            }

            prev = (tile != null ? tile : null);
        }

        return moved;
	}

    private var callbackCalled = false;

    private function isDead() {
        if (getEmptyTiles() == 0 && !canMove("up") && !canMove("down") && !canMove("left") && !canMove("right")){
//            trace("YOU'RE DEAD");
            if (onDeadCallback != null && !callbackCalled) {
                onDeadCallback();
                callbackCalled = true;
            }

            return true;
        }

        return false;
    }

    private function canMove(dir:String) { // condition: at least one tile has an empty or same value tile above it
        return gravity(dir, true);
    }

    private function isFree(x, y) {
        if (x >= 0 && x < NUM_COLUMNS && y >= 0 && y < NUM_ROWS)
            return tiles[x][y] == null;

        return false;
    }

    private function tileSame(x, y, rhsTile) {
        if (x >= 0 && x < NUM_COLUMNS && y >= 0 && y < NUM_ROWS)
            return tiles[x][y].tileValue == rhsTile.tileValue;

        return false;
    }

    private function getEmptyTiles() {
        var emptyTiles = 0;
        for (i in 0...NUM_ROWS)
            for (j in 0...NUM_COLUMNS)
                if (tiles[i][j] == null)
                    emptyTiles++;

        return emptyTiles;
    }

    public function tracedebug() {
        for (y in 0 ... NUM_ROWS) {
            var line = "";
            for (x in 0 ... NUM_COLUMNS) {
                var tile = tiles[x][y];
                if (tile != null) {
                    line += tile.tileValue;
                } else {
                    line += "-";
                }
            }
            trace(line);
        }
    }

    private function newtile() {
        var tile = new Tile();

		var rand_x = Std.random(NUM_COLUMNS);
		var rand_y = Std.random(NUM_ROWS);

		var upper_limit = 10000;
		while (!isFree(rand_x, rand_y) && upper_limit-- > 0) {
			rand_x = Std.random(NUM_COLUMNS);
			rand_y = Std.random(NUM_ROWS);
		}

		if (isFree(rand_x, rand_y)) {
			tile.setPos(rand_x, rand_y);
            tiles[rand_x][rand_y] = tile;

            tile.scaleX = 0;
            tile.scaleY = 0;

            tile.x += 50;
            tile.y += 50;

            addChild(tile);

            Actuate.tween(tile, 0.3, {scaleX: 1, scaleY: 1});
            Actuate.tween(tile, 0.3, {x: tile.x - 50, y: tile.y - 50});

            return true;
		} else {
//            trace("WE'VE HIT THE UPPER LIMIT.. THIS ISN'T OPTIMAL");
            // prevent forever loops
            return false;
		}
    }

    private function addScore(first, second) {
        score += (first + second);
    }

    public function getScore() {
        return score;
    }

    public function getMaxtile() {
        return maxtile;
    }

    private function randomRow() {
        return Std.random(NUM_ROWS);
    }

    private function randomColumn() {
        return Std.random(NUM_COLUMNS);
    }

    private var onDeadCallback:Dynamic;
    public function onDead(callback:Dynamic) {
        onDeadCallback = callback;
    }
}
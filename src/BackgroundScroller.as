package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	
	import net.hires.debug.Stats;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class BackgroundScroller extends Sprite
	{
		[Embed(source="assets/bgTile1.png")]
		private var BgTile1:Class;
		
		private var _bgContainer:Sprite;
		private var _camera:StarlingCamera2D;
		
		private static const MAP_TILE_WIDTH:int = 32;
		private static const MAP_TILE_HEIGHT:int = 32;
		private static const WORLD_COLS:int = 20;
		private static const WORLD_ROWS:int = 100;
		
		private var _tileRect:Rectangle = new Rectangle(0, 0, MAP_TILE_WIDTH, MAP_TILE_HEIGHT);
		private var _tilePoint:Point = new Point();
		
		private var _recycleTilesX:Vector.<Image>;
		private var _recycleTilesY:Vector.<Image>;
		
		private var _world:Array;
		private var index:uint = 0;
		
		private const SPEED_SCROLL:Number = 1;
		
		public function BackgroundScroller(camera:StarlingCamera2D)
		{
			_camera = camera;
			_bgContainer = new Sprite();
			_bgContainer.x = MAP_TILE_WIDTH;
			//_bgContainer.y = -MAP_TILE_HEIGHT;
			addChild(_bgContainer);

			_recycleTilesX = new Vector.<Image>();
			_recycleTilesY = new Vector.<Image>();
			
			_world = [];
			
			var texture:Texture = Texture.fromBitmap(new BgTile1());
			var c:uint;
			var r:uint;
			var image:Image;
			
			for (r=0;r < _camera.rows+1; r++)
			{
				_world.push(new Array());
				for (c=0; c < _camera.cols; c++)
				{
					_world[r].push(null);
				}
			}
			
			for (r=0; r < _camera.rows+1; r++)
			{
				for (c=0; c < _camera.cols; c++)
				{
					image = new Image(texture);
					image.x = c*image.width;
					image.y = r*image.height;
					_bgContainer.addChild(image);
					
					_world[r][c] = image;
					
					
				}
			}
		}
		
		public function updateAndRender():void
		{
			update();
			backgroundRender();
		}
		
		private function update():void
		{
			_camera.nextY -= SPEED_SCROLL;
		}
		
		private function backgroundRender():void
		{
			_camera.x = _camera.nextX;
			_camera.y = _camera.nextY;
			_bgContainer.x = -_camera.x;
			_bgContainer.y = -_camera.y;
			
			var tileCol:uint = uint(_camera.x / MAP_TILE_WIDTH);
			var tileRow:uint = uint(_camera.y / MAP_TILE_HEIGHT);
			var r:uint;
			var c:uint;
			var image:Image;
			var switchRow:Boolean = false;
			for (r=0;r<_camera.cols;r++)
			{
				if (r+tileRow == WORLD_ROWS) break;
				
				for (c=0;c<_camera.rows;c++)
				{
					if (c+tileCol == WORLD_COLS) break;
					
					if (_camera.y % MAP_TILE_HEIGHT ==0)
					{
						switchRow = true;
						image = _world[_world.length-1][c];
						image.y = - _bgContainer.y - MAP_TILE_HEIGHT;
					}
				}
			}
			if (switchRow){
				//trace("swap out row" + index++);
				_world.unshift(_world.pop());
			}
			
		}
		
	}
}
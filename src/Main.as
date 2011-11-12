package
{
	import flash.display.BitmapData;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;
	
	public class Main extends Sprite
	{
		private var _camera:StarlingCamera2D;
		private var _backgroundScroller:BackgroundScroller;
		private var _ship:Ship;
		
		private static const MAP_TILE_WIDTH:int = 32;
		private static const MAP_TILE_HEIGHT:int = 32;
		private var _bulletBitmap:BitmapData;
		private var _bulletTexture:Texture;
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initCamera();
			initBackground();
			initShip();
			initEvents();
		}
		
		private function initCamera():void
		{
			_camera = new StarlingCamera2D();
			_camera.width = 640;
			_camera.height = 608;
			_camera.cols = 20;
			_camera.rows = 20;
			_camera.startX = 0;
			_camera.startY = MAP_TILE_HEIGHT;
			_camera.nextX = 0;
			_camera.nextY = _camera.startY;
			_camera.x = _camera.startX;
			_camera.y = _camera.startY;
		}
		
		private function initShip():void
		{
			_ship = new Ship(_camera);
			addChild(_ship);
		}
		
		private function initBackground():void
		{
			_backgroundScroller = new BackgroundScroller(_camera);
			addChild(_backgroundScroller);
		}
		
		private function initEvents():void
		{
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			frameRender();
		}
		
		private function frameRender():void
		{
			_backgroundScroller.updateAndRender();
			_ship.update();
		}
	}
}
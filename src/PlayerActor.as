package
{
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.extensions.Particle;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;

	public class PlayerActor extends Actor
	{
		private var _keyPressedList:Array = [];
		private var _shouldStop:Boolean = true;
		private var _currendDirection:int = 4;
		
		public static const MOVE_UP:int = 0;
		public static const MOVE_DOWN:int = 1;
		public static const MOVE_LEFT:int = 2;
		public static const MOVE_RIGHT:int = 3;
		public static const MOVE_STOP:int = 4;
		
		[Embed(source="assets/ship.png")]
		private var ShipSprite:Class;
		
		public function PlayerActor()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var texture:Texture = Texture.fromBitmap(new ShipSprite());
			var image:Image = new Image(texture);
			addChild(image);
			//image.x = stage.stageWidth/2;
			//image.y = stage.stageHeight * 0.75;
			image.scaleX = 2;
			image.scaleY = 2;
			
			speed = 5;
			activateKeyboardControl();
		}
		
		public function activateKeyboardControl():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			_keyPressedList[e.keyCode] = false;
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			//trace(e.keyCode);
			_keyPressedList[e.keyCode] = true;
		}
		
		public override function update():void
		{
			super.update();
			checkKeyInput();
		}
		
		private function checkKeyInput():void
		{
			_shouldStop = true;
			if (_keyPressedList[Keyboard.LEFT])
			{
				vx = -speed;
				_shouldStop = false;
			} else if (_keyPressedList[Keyboard.RIGHT]) {
				vx = speed;
				_shouldStop = false;
			} else {
				vx = 0;
			}
			if (_keyPressedList[Keyboard.UP])
			{
				vy = -speed;
				_shouldStop = false;
			} else if (_keyPressedList[Keyboard.DOWN])
			{
				vy = speed;
				_shouldStop = false;
			} else {
				vy = 0;
			}
			if (_keyPressedList[Keyboard.SPACE])
				dispatchEvent(new Event("Fire"));
			if (_shouldStop)
			{
				vx = 0;
				vy = 0;
			} else {
				//move();
			}
		}
		
		/*
		private function move():void
		{
			switch(_currendDirection)
			{
				case MOVE_UP :
					
				break;
				case MOVE_DOWN :
					
				break;
				case MOVE_LEFT :
				
				break;
				case MOVE_RIGHT :
					
				break;
			}
		}*/
	}
}
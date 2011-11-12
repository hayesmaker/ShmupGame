package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	
	public class Actor extends Sprite
	{
		private var _vx:Number = 0;
		private var _vy:Number = 0;
		private var _speed:Number = 1;
		private var _posX:Number;
		private var _posY:Number;
		
		public function Actor()
		{
			super();
			_speed = 10;
		}
		
		public function get posY():Number
		{
			return this.y;
		}

		public function get posX():Number
		{
			return this.x;
		}

		public function moveLeft():void
		{
			this.vx = -_speed;	
		}
		
		public function moveRight():void
		{
			this.vx = _speed;	
		}
		
		public function moveUp():void
		{
			this.vy = -_speed;
		}
		
		public function moveDown():void
		{
			this.vy = +_speed;	
		}
		
		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get vy():Number
		{
			return _vy;
		}

		public function set vy(value:Number):void
		{
			_vy = value;
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_vx = value;
		}
		
		public function update():void
		{
			renderActor();
		}
		
		protected function renderActor():void
		{
			this.x += vx;
			this.y += vy;
		}
	}
}
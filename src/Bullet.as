package
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Bullet extends Image
	{
		private static const MAX_SPEED:Number = -10;
		private var _vx:Number = 0;
		private var _vy:Number = -1;
		private var _image:Image;
		
		public function Bullet(texture:Texture)
		{
			super(texture);
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
			this.y += _vy;  
			this.x += _vx;
		}

	}
}
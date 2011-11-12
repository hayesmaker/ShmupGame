package
{
	public class StarlingCamera2D
	{
		public var width:int;
		public var height:int;
		public var cols:int;
		public var rows:int;
		public var x:Number;
		public var y:Number;
		public var startX:Number;
		public var startY:Number;
		public var nextX:Number;
		public var nextY:Number;
		
		public function StarlingCamera2D()
		{
		}
		
		public function getCamWidth():Number
		{
			return this.width;
		}
	}
}
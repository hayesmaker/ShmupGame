package com.hayesmaker.shmup.runner.game.actors
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class FlxActor extends FlxSprite
	{
		private var _speed:Number = 200;
		
		public function FlxActor(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
		}
		
		public function makeActorGraphic(Width:uint, Height:uint):FlxActor
		{
			return (super.makeGraphic(Width,Height)) as FlxActor;
		}
		
		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public override function update():void
		{
			super.update();
			this.velocity.x = 0;
			this.velocity.y = 0;
			if (FlxG.keys.UP)
			{
				this.velocity.y = -_speed;
			} else if (FlxG.keys.DOWN)
			{
				this.velocity.y = _speed;
			}
			if (FlxG.keys.RIGHT)
			{
				this.velocity.x = _speed;
			} else if (FlxG.keys.LEFT)
			{
				this.velocity.x = -_speed;
			}
		}
	}
}
package
{
	import away3d.cameras.SpringCam;
	
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(frameRate=60, width=800, height=600)]
	public class ShmupGame extends Sprite
	{
		public function ShmupGame()
		{
			var st:Starling = new Starling(Main, stage);
			st.start();
			
			var stats:Stats = new Stats();
			addChild(stats);
			
			var blackRect:Sprite = new Sprite();
			blackRect.graphics.beginFill(0x000000,1);
			blackRect.graphics.drawRect(0,0,160,600);
			blackRect.graphics.endFill();
			addChild(blackRect);
			blackRect.x = 640;
		}
	}
}
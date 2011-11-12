package
{
	import flash.display.BitmapData;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;
	
	public class Ship extends Sprite
	{
		private var _playerActor:PlayerActor;
		private var _camera:StarlingCamera2D;
		
		[Embed(source="assets/shipExhaust.pex", mimeType="application/octet-stream")]
		private var ExhaustParticleXML:Class;
		
		[Embed(source="assets/shipExhaustParticle.png")]
		private var ParticleTexture:Class;
		
		private var _exhaustParticles:ParticleDesignerPS;
		private var _bulletBitmap:BitmapData;
		private var _bulletTexture:Texture;
		private var _bullets:Vector.<Bullet>;
		
		private const BULLET_SPEED:Number = 10;
		private var _bulletSpeed:Number = 3;
		
		public function Ship(camera:StarlingCamera2D)
		{
			_camera = camera;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initBulletData();
			initShip();
			initShipExhaust();
			initEvents();
		}
		
		private function initBulletData():void
		{
			_bulletBitmap = new BitmapData(4,6,false,0xffffff);
			_bulletTexture = Texture.fromBitmapData(_bulletBitmap,false,false);
			_bullets = new Vector.<Bullet>();
		}
		
		private function initShip():void
		{
			_playerActor = new PlayerActor();
			addChild(_playerActor);
			_playerActor.x = stage.stageWidth*0.5;
			_playerActor.y = stage.stageHeight *0.75;
		}
		
		private function initShipExhaust():void
		{
			_exhaustParticles = new ParticleDesignerPS(XML(new ExhaustParticleXML()), Texture.fromBitmap(new ParticleTexture()));
			_exhaustParticles.start();
			Starling.juggler.add(_exhaustParticles);
			addChild(_exhaustParticles);
			updateExhaustPos();
		}
		
		private function initEvents():void
		{
			_playerActor.addEventListener("Fire", onPlayerFire);
		}
		
		private function onPlayerFire(e:Event):void
		{
			var bullet:Bullet = new Bullet(_bulletTexture);
			addChild(bullet);
			bullet.x = _playerActor.x + _playerActor.width/2 -bullet.width/2;
			bullet.y = _playerActor.y - bullet.height;
			_bullets.push(bullet);  
		}
		
		private function updateExhaustPos():void
		{
			_exhaustParticles.emitterX = _playerActor.posX + _playerActor.width*0.5;
			_exhaustParticles.emitterY = _playerActor.posY + _playerActor.height;
		}
		
		public function update():void
		{
			var bullet:Bullet;
			for each (bullet in _bullets)
			{
				if (bullet.y < 0)
				{
					bullet.dispose();
					_bullets.splice(_bullets.indexOf(bullet),1);
					bullet = null; 
				} else {    
					bullet.vy -= 1;
					bullet.update();
				}
			}
			trace(_bullets.length);
			if (_playerActor.x > _camera.getCamWidth())
			{
				_playerActor.x = -_playerActor.width;
			}
			
			if (_playerActor.x < -_playerActor.width)
			{
				_playerActor.x = _camera.getCamWidth();
			}
			_playerActor.update();
			updateExhaustPos();
		}
	}
}
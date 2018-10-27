package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;

	public class platform2D extends MovieClip
	{
		private var allPlatform:Array = new Array  ;
		private var flowersArray:Array = new Array  ;
		private var ver:Array = new Array  ;
		private var obs:Array = new Array  ;
		private var allPlatformMC:MovieClip;
		private var everyth:Array = new Array  ;
		private var allVerMC:MovieClip;
		private var defaultJumpSpeed:Number = 10;
		private var defaultFallSpeed:Number = 0;
		private var jumpSpeed:Number = defaultJumpSpeed;
		private var fallSpeed:Number = defaultFallSpeed;
		private var gravity:Number = 0.35;
		private var r:Boolean = false;
		private var l:Boolean = false;
		private var jump:Boolean = false;
		private var fall:Boolean = true;
		private var currentPlatform:MovieClip;
		private var player:MovieClip;
		private var speed:Number;
		private var theStage:Object;
		private var cameraLeft:MovieClip;
		private var cameraRight:MovieClip;
		private var everything:MovieClip;
		private var flowersMC:MovieClip;
		public var flowers:int = 0;
		private var tween:Tween;
		private var defaultallPlatformMC:Number;
		private var defaultallVerMC:Number;
		private var defaulteverything:Number;
		private var defaultflowersMC:Number;
		private var defaultobstacles:Number;
		private var defaultPlayerPos:Point;
		private var ableToMove:Boolean = true;
		private var timer:Timer = new Timer(3000,1);
		private var obstacles:MovieClip;
		public var lifes:int = 3;

		public function platform2D(thePlayer:MovieClip,platformsMovieClip:MovieClip,vertical:MovieClip,every:MovieClip,flower:MovieClip,obst:MovieClip,leftCam:MovieClip,rightCam:MovieClip,theSpeed:Number)
		{
			player = thePlayer;
			allPlatformMC = platformsMovieClip;
			allVerMC = vertical;
			speed = theSpeed;
			cameraLeft = leftCam;
			cameraRight = rightCam;
			everything = every;
			flowersMC = flower;
			obstacles = obst;
			defaultallPlatformMC = allPlatformMC.x;
			defaultallVerMC = allVerMC.x;
			defaulteverything = everything.x;
			defaultflowersMC = flowersMC.x;
			defaultobstacles = obstacles.x;
			defaultPlayerPos = new Point(player.x,player.y);

			player.addEventListener(Event.ENTER_FRAME,checkHit);
			player.addEventListener(Event.ENTER_FRAME,moving);
			this.addEventListener(Event.ADDED_TO_STAGE,added);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,restart);

			for (var i:int = 0; i < platformsMovieClip.numChildren; i++)
			{
				allPlatform.push(platformsMovieClip.getChildAt(i));
			}
			for (var i1:int = 0; i1 < flowersMC.numChildren; i1++)
			{
				flowersArray.push(flowersMC.getChildAt(i1));
			}
			for (var i2:int = 0; i2 < obstacles.numChildren; i2++)
			{
				obs.push(obstacles.getChildAt(i2));
			}
			for (var i3:int = 0; i3 < vertical.numChildren; i3++)
			{
				ver.push(vertical.getChildAt(i3));
			}
			for (var i4:int = 0; i4 < every.numChildren; i4++)
			{
				everyth.push(every.getChildAt(i4));
			}
		}

		private function added(e:Event)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kd);
			stage.addEventListener(KeyboardEvent.KEY_UP,ku);
			theStage = stage;
			this.removeEventListener(Event.ADDED_TO_STAGE,added);
		}

		private function kd(e:KeyboardEvent)
		{
			if (ableToMove)
			{
				switch (e.keyCode)
				{
					case Keyboard.LEFT :
						l = true;
						r = false;
						player.gotoAndStop("runLeft");
						break;

					case Keyboard.SPACE :
						jump = true;
						break;

					case Keyboard.RIGHT :
						r = true;
						l = false;
						player.gotoAndStop("runRight");
						break;
				}
			}
		}

		private function ku(e:KeyboardEvent)
		{
			if (ableToMove)
			{
				switch (e.keyCode)
				{
					case Keyboard.LEFT :
						l = false;
						if (! r)
						{
							player.gotoAndStop("stopLeft");
						}
						break;

					case Keyboard.RIGHT :
						r = false;
						if (! l)
						{
							player.gotoAndStop("stopRight");
						}
						break;
				}
			}
		}
		private function moving(e:Event)
		{
			if (r)
			{
				player.x +=  speed;
			}
			if (l)
			{
				player.x -=  speed;
			}
			if (jump)
			{
				if (! fall)
				{
					jumpSpeed -=  gravity;
					player.y -=  jumpSpeed;
				}
			}
			if (fall)
			{
				fallSpeed +=  gravity;
				player.y +=  fallSpeed;
			}
			if ((fallSpeed > speed + 2))
			{
				fallSpeed = speed + 2;
			}

			if ((jumpSpeed <  -  (speed + 2)))
			{
				jumpSpeed =  -  (speed + 2);
			}
		}
		private function checkHit(e:Event)
		{

			if (player.x < player.width / 2)
			{
				player.x = player.width / 2;
			}

			for (var i:int = 0; i < allPlatform.length; i++)
			{
				if (player.real.hitTestObject(allPlatform[i]))
				{
					if (((jumpSpeed < 0) || fallSpeed > 0))
					{
						fall = false;
						jump = false;
						currentPlatform = allPlatform[i];
						jumpSpeed = defaultJumpSpeed;
						fallSpeed = defaultFallSpeed;
						player.y = allPlatform[i].y + allPlatformMC.y - allPlatform[i].height / 2 - player.height / 2;
					}
				}
			}
			for (var i1:int = 0; i1 < flowersArray.length; i1++)
			{
				if (flowersArray[i1] != null)
				{
					if (player.realHead.hitTestObject(flowersArray[i1]) || player.realBody.hitTestObject(flowersArray[i1]))
					{
						remove(flowersArray[i1]);
						flowers +=  1;
					}
				}
			}
			for (var i2:int = 0; i2 < obs.length; i2++)
			{
				if (player.realHead.hitTestObject(obs[i2]) || player.realBody.hitTestObject(obs[i2]))
				{
					loose();
				}
			}
			for (var i3:int = 0; i3 < ver.length; i3++)
			{
				if (player.hitTestObject(ver[i3]))
				{
					if (player.x <= ver[i3].x + allVerMC.x)
					{
						player.x = ver[i3].x + allVerMC.x - player.width / 2 - ver[i3].width / 2;
					}
					if (player.x > ver[i3].x + allVerMC.x)
					{
						player.x = ver[i3].x + allVerMC.x + player.width / 2 + ver[i3].width / 2;
					}
				}
			}
			if (((currentPlatform != null) && ! player.real.hitTestObject(currentPlatform)))
			{
				if (! jump)
				{
					fall = true;
				}
			}
			if (player.hitTestObject(cameraRight))
			{
				player.x = cameraRight.x - player.width / 2 - cameraRight.width / 2 - 1;
				allPlatformMC.x -=  speed;
				allVerMC.x -=  speed;
				everything.x -=  speed;
				flowersMC.x -=  speed;
				obstacles.x -=  speed;
			}
			if (player.hitTestObject(cameraLeft))
			{
				if (allPlatformMC.x < defaultallPlatformMC)
				{
					player.x = cameraLeft.x + player.width / 2 + cameraLeft.width / 2 + 1;
					allPlatformMC.x +=  speed;
					allVerMC.x +=  speed;
					everything.x +=  speed;
					flowersMC.x +=  speed;
					obstacles.x +=  speed;
				}
			}
		}
		function loose()
		{
			if ((lifes > 0))
			{
				player.gotoAndStop("stopRight");
				l = false;
				r = false;
				jump = false;
				fall = false;
				ableToMove = false;
				player.alpha = 0.7;
				tween = new Tween(allPlatformMC,"x",Regular.easeIn,allPlatformMC.x,defaultallPlatformMC,1,true);
				tween = new Tween(allVerMC,"x",Regular.easeIn,allVerMC.x,defaultallVerMC,1,true);
				tween = new Tween(everything,"x",Regular.easeIn,everything.x,defaulteverything,1,true);
				tween = new Tween(flowersMC,"x",Regular.easeIn,flowersMC.x,defaultflowersMC,1,true);
				tween = new Tween(player,"x",Regular.easeIn,player.x,defaultPlayerPos.x,1,true);
				tween = new Tween(player,"y",Regular.easeIn,player.y,defaultPlayerPos.y,1,true);
				tween = new Tween(obstacles,"x",Regular.easeIn,obstacles.x,defaultobstacles,1,true);
				player.removeEventListener(Event.ENTER_FRAME,checkHit);
				player.removeEventListener(Event.ENTER_FRAME,moving);
				lifes -=  1;
				timer.start();
			}
			else
			{
				player.removeEventListener(Event.ENTER_FRAME,checkHit);
				player.removeEventListener(Event.ENTER_FRAME,moving);
				theStage.removeEventListener(KeyboardEvent.KEY_DOWN,kd);
				theStage.removeEventListener(KeyboardEvent.KEY_UP,ku);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,restart);
			}
		}
		function restart(e:TimerEvent)
		{
			ableToMove = true;
			player.alpha = 1;
			player.addEventListener(Event.ENTER_FRAME,checkHit);
			player.addEventListener(Event.ENTER_FRAME,moving);
		}
		public function remove(e:MovieClip)
		{
			if (e != null && e.parent.contains(e))
			{
				e.parent.removeChild(e);
				e = null;
			}
		}
	}

}
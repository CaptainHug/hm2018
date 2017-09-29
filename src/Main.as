package
{
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import feathers.system.DeviceCapabilities;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	import starling.events.Event;
	import threedee.Root3D;
	import util.DeviceUtil;
	
	/**
	 * ...
	 * @author jrh
	 */
	[SWF(width="512", height="384", backgroundColor="#000000", frameRate="60")]
	public class Main extends Sprite 
	{
		// 2D engine
		private var _starling:Starling;
		private var _renderingPaused:Boolean;
		
		// 3D engine
		private var _stage3DManager:Stage3DManager;
		private var _stage3DProxy:Stage3DProxy;
		private var _view:View3D;
		
		
		public function Main() 
		{
			// Entry point
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			DeviceUtil.Instance.init();
			if(DeviceUtil.Instance.platform == DeviceUtil.PLATFORM_IOS) {
				// on iOS make the volume respect the mute toggle (this is optional, we could not do this to behave as YouTube does)
				SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			}
			
			_renderingPaused = true;
			
			// initialise the stage 3d proxy
			_stage3DManager = Stage3DManager.getInstance(stage);
			_stage3DProxy = _stage3DManager.getFreeStage3DProxy();
			_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			
			// Disabled antiAlias due to: #0021772: Anti-Aliasing using configureBackBuffer() on iOS
			//_stage3DProxy.antiAlias = 4;
			_stage3DProxy.color = 0x0;
		}
		
		
		private function onContextCreated(e:Stage3DEvent):void
		{
			_stage3DProxy.width = stage.fullScreenWidth;
			_stage3DProxy.height = stage.fullScreenHeight;
			
			initAway3D();
			initStarling();
			
			_stage3DProxy.addEventListener(flash.events.Event.ENTER_FRAME, update);
		}
		
		
		private function initAway3D():void
		{					
			// create view
			_view = new View3D(null, null, null, false, Context3DProfile.BASELINE_CONSTRAINED);
			_view.stage3DProxy = _stage3DProxy;
			_view.shareContext = true;
			addChild(_view);
			
			// set away3d view to full screen
			_view.x = 0;
			_view.y = 0;
			_view.width = stage.fullScreenWidth;
			_view.height = stage.fullScreenHeight;
			
			Root3D.Instance.init(_view);
			
			/*
			// stats - 3D
			var stats:AwayStats = new AwayStats(_view);
			addChild(stats);
			*/
		}
		
		
		private function initStarling():void
		{
			var stageWidth:int = stage.fullScreenWidth;
            var stageHeight:int = stage.fullScreenHeight;
			
			DeviceCapabilities.tabletScreenMinimumInches = 5.5;
			
			var scaleFactor:int = 1;
			var landscape_height:int = Math.min(stageWidth, stageHeight);
			var asf:Number;
			
			// phone scaling
			asf = (landscape_height / 384);
			
			if (landscape_height <= 384) scaleFactor = 1;
			else if (landscape_height <= 768) scaleFactor = 2;
			//else if (landscape_height <= 1024) scaleFactor = 3;	// HUG: removed the 3x asset set completely
			else scaleFactor = 4;    // highest supported set (good for up to at least 1280px)
			
            stageWidth = Math.round(stageWidth / asf);
            stageHeight = Math.round(stageHeight / asf);
			
			// TODO: create a sprite to hide the screen when context is lost
			
			// create starling object
			var viewport:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			Starling.multitouchEnabled = false;
			_starling = new Starling(Kernel, stage, viewport, _stage3DProxy.stage3D, "auto", Context3DProfile.BASELINE_CONSTRAINED);
			_starling.shareContext = true;
			_starling.stage.stageWidth = stageWidth;
			_starling.stage.stageHeight = stageHeight;
			_starling.simulateMultitouch = false;
			_starling.stage.color = 0x000000;
			_starling.enableErrorChecking = CONFIG::debug;
			
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, function onRootCreated(event:Object, app:Kernel):void
			{
				// start the app when the app Root is created
				_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
				
				app.init(scaleFactor, asf);
				
				// TODO: start listening for when the context gets restored
				_starling.start();
				_renderingPaused = false;
			});
			
			trace("Starling.contentScaleFactor = " + Starling.contentScaleFactor);
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, activate);
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, deactivate);
			// TODO: NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invoke);
		}
		
		
		private function update(e:flash.events.Event = null):void
		{
			// don't update if app is deactivated
			if (_renderingPaused) return;
			
			_starling.nextFrame();
			Root3D.Instance.update();
		}
		
		
		private function activate(e:flash.events.Event):void 
		{
			trace("Main: activate");
			
			Starling.current.start();
			_renderingPaused = false;
		}
		
		
		private function deactivate(e:flash.events.Event):void 
		{
			trace("Main: deactivate");
			
			Starling.current.stop();
			_renderingPaused = true;
			
			SoundEngine.Instance.pauseAllSounds();
		}
		
	}
	
}

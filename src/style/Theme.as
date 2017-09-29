package style
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.themes.StyleNameFunctionTheme;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextFormat;
	
	/**
	 * ...
	 * @author jrh
	 */
	public class Theme extends StyleNameFunctionTheme
	{
		private static const DEFAULT_FONT:TextFormat = new TextFormat(Resource.FONT_GOTHAM, 16, 0x000000);
		private static const DEFAULT_FONT_BOLD:TextFormat = new TextFormat(Resource.FONT_GOTHAM_BOLD, 16, 0x000000);
		
		private var _isIntialised:Boolean;
		
		public function Theme()
		{
			super();
			
			_isIntialised = false;
		}
		
		public function initialize():void
		{
			if (_isIntialised) return;
			
			initializeStyleProviders();
			
			// done
			_isIntialised = true;
			dispatchEventWith(Event.COMPLETE);
		}
		
		private function initializeStyleProviders():void
		{
			// default styles
			getStyleProviderForClass(Button).defaultStyleFunction = setButtonStyles;
			getStyleProviderForClass(Label).defaultStyleFunction = setLabelStyles;
		}
		
		// ********************************************************************************
		// default styles functions
		private function setLabelStyles(label:Label):void
		{
			label.backgroundSkin = new Quad(10, 10, 0xffffff);
			label.textRendererFactory = function():ITextRenderer
			{
				return new BitmapFontTextRenderer();
			}
			label.fontStyles = Theme.DEFAULT_FONT;
		}
		
		private function setButtonStyles(button:Button):void
		{
			button.defaultSkin = new Quad(10, 10, 0xffffff);
			button.downSkin = new Quad(10, 10, 0xff00ff);
			button.labelFactory = function():ITextRenderer
			{
				return new BitmapFontTextRenderer();
			}
			button.fontStyles = Theme.DEFAULT_FONT;
		}
		
	}

}

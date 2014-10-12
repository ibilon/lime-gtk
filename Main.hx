import hxgtk.*;

class Main
{
	@:access(hxgtk.GdkGLDrawable)
	@:access(lime.app.Application)
	public static function expose (da:GtkWidget) : Bool
	{
		var glcontext = da.getGlContext();
		var gldrawable = da.getGlDrawable();

		if (!GdkGl.drawableGlBegin(gldrawable, glcontext))
		{
			throw "drawableGlBegin failed";
		}

		// draw		
		if (app == null)
		{
			Ndll.clearScreen();
			
			loadApp(da.width, da.height);			
			
			G.timeoutAdd(1000 / 60, update.bind(da));
		}
		
		gldrawable.swap();
		
		GdkGl.drawableGlEnd(gldrawable);

		return true;
	}

	@:access(lime.app.Application)
	public static function update (da:GtkWidget) : Bool
	{
		var glcontext = da.getGlContext();
		var gldrawable = da.getGlDrawable();

		if (!GdkGl.drawableGlBegin(gldrawable, glcontext))
		{
			throw "drawableGlBegin failed";
		}
		
		// update		
		if (app != null && appInstance != null)
		{
			try
			{
				appInstance.__triggerFrame();
			}
			catch (e:Dynamic)
			{
				trace('Update triggerFrame error: $e');
			}
		}
		else
		{
			Ndll.clearScreen();
		}
		
		gldrawable.swap();
		
		GdkGl.drawableGlEnd(gldrawable);
		
		GdkWindow.invalidateRect(da.window, da.allocation, false);
		GdkWindow.processUpdates(da.window, false); // fails sometime on neko

		return true;
	}
	
	public static function loadApp (width:Int, height:Int) : Void
	{
		trace("Loading app");
		
		//~ var name = "SimpleImage";
		//~ var name = "BunnyMark";
		//~ var name = "SimpleAudio";
		//~ var name = "DisplayingABitmap";
		var name = "PlayingSound";
		//~ var name = "PiratePig";
		//~ var name = "AddingAnimation";
		//~ var name = "ActuateExample";
		
		try
		{
			var path = 'samples/$name/Export/linux64/neko/bin/';
			Sys.setCwd(path);
			
			var nl = new neko.vm.Loader(untyped $loader);
			app = neko.vm.Module.readPath(name+".n", [path], nl);
			
			app.execute();
			
			app.getGlobal(0)(width, height);
			
			appInstance = app.getGlobal(0);
			
			audioClean = app.getGlobal(1);
			
			trace("App loaded");
		}
		catch (e:Dynamic)
		{
			trace('Error durring app load: $e');
			untyped app = -1;
		}
	}
	
	static var audioClean : Void->Void;
	
	public static function main ()
	{	
		var name = "Test Lime Embed";
		Gtk.init(name);
		GtkGl.init(name);

		var window = new GtkWindow(GtkWindow.TOPLEVEL);
		window.setDefaultSize(800, 600);
		
		var da = new GtkDrawingArea();
		window.connect("destroy", Gtk.mainQuit);
		
		var hbox = new GtkHbox(false, 10);
		window.add(hbox);
		hbox.show();
		
		hbox.packStart(da, true, true, 2);
		
		da.setEvents(Gdk.EXPOSURE_MASK);
		
		var vbox = new GtkVbox(false, 10);
		hbox.packEnd(vbox, false, false, 2);
		
		var samples = ["SimpleImage", "BunnyMark", "SimpleAudio", "DisplayingABitmap", "PlayingSound", "PiratePig", "AddingAnimation", "ActuateExample"];
		
		// Create a button to which to attach menu as a popup
		for (s in samples)
		{
			var button = new GtkButton(s);
			button.connect("clicked", button_clicked.bind(s));
			vbox.packEnd(button, false, false, 2);
			button.show();
		}
		
		vbox.show();
		window.show();

		// prepare GL
		
		var glconfig = new GdkGLConfig(GdkGl.MODE_RGB | GdkGl.MODE_DEPTH | GdkGl.MODE_DOUBLE);

		if (!glconfig.ok)
		{
			throw "new GdkGLConfig failed";
		}
		
		if (!da.setGlCapability(glconfig, null, true, GdkGl.RGBA_TYPE))
		{
			throw "setGlCapability failed";
		}
		
		da.connectExpose(expose.bind(da));
		
		window.showAll();
		
		try
		{
			Gtk.main();
		}
		catch (e:Dynamic)
		{
			trace('error: $e');
			trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		
			if (audioClean != null)
			{
				audioClean();
			}
			else if (app != null)
			{
				trace("Didn't get audio clean method");
			}
		}
		
		if (audioClean != null)
		{
			audioClean();
		}
		else if (app != null)
		{
			trace("Didn't get audio clean method");
		}
	}
	
	static function button_clicked (name:String) { trace('button clicked $name'); }
	
	static var app : neko.vm.Module;
	static var appInstance : lime.app.Application;
}

import hxgtk.*;

class Main
{
	static var appLoaded : Bool = false;
	
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
		if (!appLoaded)
		{
			Ndll.clearScreen();
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
		if (appLoaded)
		{
			try
			{
				appInstance.__triggerFrame();
			}
			catch (e:Dynamic)
			{
				trace('Update triggerFrame error: $e');
				trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
				appLoaded = false;
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
	
	public static function loadApp (da:GtkWidget, name:String) : Void
	{
		label.text = 'Loading sample "$name"';
		
		try
		{
			cleanAudio();
			
			var path = 'samples/$name/Export/linux64/neko/bin/';
			Sys.setCwd(cwd);
			Sys.setCwd(path);
			
			var nl = new neko.vm.Loader(untyped $loader);
			app = neko.vm.Module.readPath(name+".n", [path], nl);
			
			app.execute();
			
			app.getGlobal(0)(da.width, da.height);
			
			appInstance = app.getGlobal(0);
			
			audioClean = app.getGlobal(1);
			
			appLoaded = true;
			
			label.text = 'Sample "$name" loaded';
		}
		catch (e:Dynamic)
		{
			trace('Error durring app load: $e');
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
		window.connect("destroy", quit);
		
		var mainvbox = new GtkVbox(false, 2);
		window.add(mainvbox);
		mainvbox.show();
		
		var hbox = new GtkHbox(false, 10);
		mainvbox.packStart(hbox, true, true, 2);
		hbox.show();
		
		var vbox_left = new GtkVbox(false, 10);
		hbox.packStart(vbox_left, true, true, 2);
		vbox_left.show();
		
		var hbox_commands = new GtkHbox(false, 10);
		for (b in ["pause", "play", "next frame"])
		{
			var button = new GtkButton(b);
			//~ button.connect("clicked", );
			hbox_commands.packStart(button, false, false, 2);
			button.show();
		}
		vbox_left.packStart(hbox_commands, false, false, 2);
		hbox_commands.show();
		
		var da = new GtkDrawingArea();
		da.setEvents(Gdk.EXPOSURE_MASK);
		vbox_left.packStart(da, true, true, 2);
		da.show();	
		
		var vbox_right = new GtkVbox(false, 10);
		for (s in ["SimpleImage", "BunnyMark", "SimpleAudio", "DisplayingABitmap", "PlayingSound", "PiratePig", "AddingAnimation", "ActuateExample"])
		{
			var button = new GtkButton(s);
			button.connect("clicked", loadApp.bind(da, s));
			vbox_right.packStart(button, false, false, 2);
			button.show();
		}		
		hbox.packStart(vbox_right, false, false, 2);
		vbox_right.show();
		
		label = new GtkLabel("Lime Gtk+");
		mainvbox.packStart(label, false, true, 2);
		label.show();

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
		
		window.show();
		window.showAll();
		
		var startTime = 0.0;
		var sleepTime = 0.0;
		
		while (true)
		{
			try
			{				
				while (Gtk.eventsPending())
				{
					Gtk.mainIteration();
				}
				
				startTime = Ndll.getTime();
				
				update(da);
				
				sleepTime = startTime + 0.016 - Ndll.getTime();
				
				if (sleepTime > 0.001)
				{
					Sys.sleep(sleepTime);
				}
			}
			catch (e:Dynamic)
			{
				trace('error: $e');
				trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
			}
		}
		
		quit();
	}
	
	static function quit ()
	{
		cleanAudio();
		
		Sys.exit(0);
	}
	
	static function cleanAudio ()
	{
		if (audioClean != null)
		{
			audioClean();
		}
		else if (appLoaded)
		{
			trace("Didn't get audio clean method");
		}
	}
	
	static var app : neko.vm.Module;
	static var appInstance : lime.app.Application;
	static var cwd = Sys.getCwd();
	static var label : GtkLabel;
}

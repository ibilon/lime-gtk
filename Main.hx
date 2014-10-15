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
			Hxgtk.clearScreen();
		}

		gldrawable.swap();

		GdkGl.drawableGlEnd(gldrawable);

		return true;
	}

	@:access(lime.app.Application)
	@:access(lime.ui.MouseEventManager)
	@:access(lime.ui.Window)
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
				// Window resize event
				var nw = da.width;
				var nh = da.height;

				if (width != nw || height != nh)
				{
					width = nw;
					height = nh;

					lime.ui.Window.eventInfo.type = WINDOW_RESIZE;
					lime.ui.Window.eventInfo.width = nw;
					lime.ui.Window.eventInfo.height = nh;
					lime.ui.Window.eventInfo.x = 0;
					lime.ui.Window.eventInfo.y = 0;
					appInstance.get_window().dispatch();
				}

				// Mouse events
				var nm = da.window.getMouseInfo();

				if ((mouse.x != nm.x || mouse.y != nm.y) && nm.x >= 0 && nm.y >= 0 && nm.x <= width && nm.y <= height)
				{
					mouse.x = nm.x;
					mouse.y = nm.y;

					lime.ui.MouseEventManager.eventInfo.button = 0;
					lime.ui.MouseEventManager.eventInfo.type = MOUSE_MOVE;
					lime.ui.MouseEventManager.eventInfo.x = nm.x;
					lime.ui.MouseEventManager.eventInfo.y = nm.y;
					lime.ui.MouseEventManager.handleEvent();
				}

				// Keyboard events

				// Rendering
				appInstance.__triggerFrame();
			}
			catch (e:Dynamic)
			{
				trace('Update app error: $e');
				trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
				appLoaded = false;
			}
		}
		else
		{
			Hxgtk.clearScreen();
		}

		gldrawable.swap();

		GdkGl.drawableGlEnd(gldrawable);

		GdkWindow.invalidateRect(da.window, da.allocation, false);
		GdkWindow.processUpdates(da.window, false); // fails sometime on neko

		return true;
	}

	public static function backgroundTask (fn:Void->Bool, cb:Void->Void) : Void
	{
		neko.vm.Thread.create(function () {
			if (fn())
			{
				cb();
			}
		});
	}

	public static function buildApp (name:String) : Bool
	{
		label.text = 'Building sample "$name"';

		try
		{
			cleanAudio();

			var path = 'samples/$name/';
			Sys.setCwd(cwd);
			Sys.setCwd(path);

			Sys.command("lime", ["build", "neko", "-Dnext", "-debug", "-embed"]);
		}
		catch (e:Dynamic)
		{
			trace('Error durring app build: $e');
			trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));

			return false;
		}

		return true;
	}

	public static function loadApp (da:GtkWidget, name:String) : Void
	{
		label.text = 'Loading sample "$name"';

		try
		{
			var path = 'samples/$name/Export/linux64/neko/bin/';
			Sys.setCwd(cwd);
			Sys.setCwd(path);

			var nl = new neko.vm.Loader(untyped $loader);
			app = neko.vm.Module.readPath(name+".n", [path], nl);

			app.execute();

			app.getGlobal(0)(width = da.width, height = da.height);

			appInstance = app.getGlobal(0);
			audioClean = app.getGlobal(1);

			appLoaded = true;

			label.text = 'Sample "$name" loaded';
		}
		catch (e:Dynamic)
		{
			trace('Error durring app load: $e');
			trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));

			app = null;
			appInstance = null;
			audioClean = null;
			appLoaded = false;
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
		for (s in ["SimpleImage", "BunnyMark", "SimpleAudio", "DisplayingABitmap", "PlayingSound", "PiratePig", "AddingAnimation", "ActuateExample", "HaxeFlixel", "HaxePunk"])
		{
			var button = new GtkButton(s);
			button.connect("clicked", backgroundTask.bind(buildApp.bind(s), loadApp.bind(da, s)));
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

				startTime = Hxgtk.getTime();

				update(da);

				sleepTime = startTime + 0.016 - Hxgtk.getTime();

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

	static var width : Int;
	static var height : Int;
	static var mouse = { x: 0, y: 0, state: 0 };
}

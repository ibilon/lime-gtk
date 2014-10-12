package hxgtk;

class GtkDrawingArea extends GtkWidget
{
	public function new ()
	{
		__handle = hxgtk_drawingarea_new();
	}
	
	private static var hxgtk_drawingarea_new : Void->Dynamic = Ndll.load("hx_GtkDrawingArea_new", 0);
}

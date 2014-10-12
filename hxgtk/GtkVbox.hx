package hxgtk;

class GtkVbox extends GtkBox
{
	public function new (a:Bool, b:Int)
	{
		__handle = hxgtk_vbox_new(a, b);
	}
	
	private static var hxgtk_vbox_new : Bool->Int->Dynamic = Ndll.load("hx_GtkVbox_new", 2);
}

package hxgtk;

class GtkHbox extends GtkBox
{
	public function new (a:Bool, b:Int)
	{
		__handle = hxgtk_hbox_new(a, b);
	}
	
	private static var hxgtk_hbox_new : Bool->Int->Dynamic = Ndll.load("hx_GtkHbox_new", 2);
}

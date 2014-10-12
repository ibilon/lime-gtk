package hxgtk;

class GtkBox extends GtkContainer
{
	public inline function packStart (widget:GtkWidget, a:Bool, b:Bool, c:Int) : Void
	{
		hxgtk_box_packstart(__handle, widget.__handle, a, b, c);
	}
	
	public inline function packEnd (widget:GtkWidget, a:Bool, b:Bool, c:Int) : Void
	{
		hxgtk_box_packend(__handle, widget.__handle, a, b, c);
	}
	
	private static var hxgtk_box_packstart : Dynamic->Dynamic->Bool->Bool->Int->Void = Ndll.load("hx_GtkBox_packStart", 5);
	private static var hxgtk_box_packend : Dynamic->Dynamic->Bool->Bool->Int->Void = Ndll.load("hx_GtkBox_packEnd", 5);
}

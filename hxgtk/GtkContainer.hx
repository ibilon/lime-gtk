package hxgtk;

class GtkContainer extends GtkWidget
{
	public inline function add (widget:GtkWidget) : Void
	{
		hxgtk_container_add(__handle, widget.__handle);
	}
	
	private static var hxgtk_container_add : Dynamic->Dynamic->Void = Ndll.load("hx_GtkContainer_add", 2);
}

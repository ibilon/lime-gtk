package hxgtk;

class GtkAllocation
{
	@:allow(hxgtk.GtkWidget)
	private function new (handle:Dynamic)
	{
		__handle = handle;
	}
	
	@:allow(hxgtk.GdkWindow)
	private var __handle : Dynamic;
}

package hxgtk;

class GtkGl
{
	public static inline function init (name:String) : Void
	{
		hxgtk_gl_init(name);
	}
	
	private static var hxgtk_gl_init : String->Void = Ndll.load("hx_GtkGl_init", 1);
}

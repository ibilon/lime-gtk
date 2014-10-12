package hxgtk;

class GdkGl
{
	public inline static var MODE_RGB : Int = 0;
	public inline static var MODE_DEPTH : Int = 1<<4;
	public inline static var MODE_DOUBLE : Int = 1<<1;
	public inline static var RGBA_TYPE : Int = 0x8014;
	
	public static inline function drawableGlBegin (d:GdkGLDrawable, c:GdkGLContext) : Bool
	{
		return hxgtk_gl_drawableglstart(d.__handle, c.__handle);
	}
	
	public static inline function drawableGlEnd (d:GdkGLDrawable) : Void
	{
		hxgtk_gl_drawableglend(d.__handle);
	}
	
	private static var hxgtk_gl_drawableglstart : Dynamic->Dynamic->Bool = Ndll.load("hx_GdkGl_drawableGlBegin", 2);
	private static var hxgtk_gl_drawableglend : Dynamic->Void = Ndll.load("hx_GdkGl_drawableGlEnd", 1);
}

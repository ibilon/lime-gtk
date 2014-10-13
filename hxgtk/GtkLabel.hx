package hxgtk;

class GtkLabel extends GtkWidget
{
	public function new (text:String = "")
	{
		__handle = hxgtk_label_new(text);
	}
	
	public var text(get, set) : String;
	private inline function get_text () : String
	{
		return hxgtk_label_get_text(__handle);
	}
	private inline function set_text (newText:String) : String
	{
		hxgtk_label_set_text(__handle,newText);
		return newText;
	}
	
	private static var hxgtk_label_new : String->Dynamic = Ndll.load("hx_GtkLabel_new", 1);
	private static var hxgtk_label_get_text : Dynamic->String = Ndll.load("hx_GtkLabel_getText", 1);
	private static var hxgtk_label_set_text : Dynamic->String->Void = Ndll.load("hx_GtkLabel_setText", 2);
}

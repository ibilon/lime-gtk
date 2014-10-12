package hxgtk;

class GtkButton extends GtkWidget
{
	public function new (label:String)
	{
		__handle = hxgtk_button_new(label);
	}
	
	private static var hxgtk_button_new : String->Dynamic = Ndll.load("hx_GtkButton_new", 1);
}

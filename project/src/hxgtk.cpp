#define IMPLEMENT_API
#define NEKO_COMPATIBLE
#include <hx/CFFI.h>

#include <gtk/gtk.h>
#include <gtk/gtkgl.h>

#include <GL/gl.h>

#include <time.h>


value hx_clearScreen ()
{	
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	
	return alloc_null();
}
DEFINE_PRIM (hx_clearScreen, 0);


value hx_getTime ()
{	
	clock_t c = clock();
	float f = (float)c / CLOCKS_PER_SEC;
	
	return alloc_float(f);
}
DEFINE_PRIM (hx_getTime, 0);


value hx_GdkGLDrawable_swap (value handle)
{	
	GdkGLDrawable* gldrawable = (GdkGLDrawable*)(intptr_t)val_float(handle);	
	
	if (gdk_gl_drawable_is_double_buffered (gldrawable))
		gdk_gl_drawable_swap_buffers (gldrawable);
	else
		glFlush ();
	
	return alloc_null();
}
DEFINE_PRIM (hx_GdkGLDrawable_swap, 1);


value hx_Gtk_init (value args)
{	
	int argc = 1; 
	char *v = (char*)val_string(args);
	char **argv = &v;
	
	gtk_init(&argc, &argv);
	
	return alloc_null();
}
DEFINE_PRIM (hx_Gtk_init, 1);


value hx_GtkGl_init (value args)
{	
	int argc = 1; 
	char *v = (char*)val_string(args);
	char **argv = &v;
	
	gtk_gl_init(&argc, &argv);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkGl_init, 1);


value hx_Gtk_eventsPending ()
{
	return alloc_bool(gtk_events_pending() == TRUE);
}
DEFINE_PRIM (hx_Gtk_eventsPending, 0);


value hx_Gtk_mainIteration ()
{
	return alloc_bool(gtk_main_iteration() == TRUE);
}
DEFINE_PRIM (hx_Gtk_mainIteration, 0);


value hx_Gtk_main ()
{
	gdk_threads_enter();
	gtk_main();
	gdk_threads_leave();
	
	return alloc_null();
}
DEFINE_PRIM (hx_Gtk_main, 0);


value hx_Gtk_mainQuit ()
{
	gtk_main_quit();
	
	return alloc_null();
}
DEFINE_PRIM (hx_Gtk_mainQuit, 0);


value hx_GdkGl_drawableGlBegin (value d, value c)
{
	GdkGLContext* glcontext = (GdkGLContext*)(intptr_t)val_float(c);	
	GdkGLDrawable* gldrawable = (GdkGLDrawable*)(intptr_t)val_float(d);	
	
	bool result = gdk_gl_drawable_gl_begin(gldrawable, glcontext);
	
	return alloc_bool(result);
}
DEFINE_PRIM (hx_GdkGl_drawableGlBegin, 2);


value hx_GdkGl_drawableGlEnd (value d)
{	
	GdkGLDrawable* gldrawable = (GdkGLDrawable*)(intptr_t)val_float(d);	
	
	gdk_gl_drawable_gl_end(gldrawable);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GdkGl_drawableGlEnd, 1);


void Gtk_cb (GtkWidget *widget, gpointer data)
{
	val_call0((value)data);
}
void Gtk_cb_expose (GtkWidget *widget, GdkEventExpose *event, gpointer data)
{	
	val_call0((value)data);
}
void Gtk_cb_configure (GtkWidget *widget, GdkEventConfigure *event, gpointer data)
{	
	val_call0((value)data);
}


value hx_GtkWidget_connect (value handle, value event, value fn)
{	
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);	
	g_signal_connect (widget, val_string(event), GTK_SIGNAL_FUNC (Gtk_cb), fn);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWidget_connect, 3);
value hx_GtkWidget_connect_expose (value handle, value event, value fn)
{	
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);	
	g_signal_connect (widget, val_string(event), GTK_SIGNAL_FUNC (Gtk_cb_expose), fn);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWidget_connect_expose, 3);
value hx_GtkWidget_connect_configure (value handle, value event, value fn)
{	
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);	
	g_signal_connect (widget, val_string(event), GTK_SIGNAL_FUNC (Gtk_cb_configure), fn);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWidget_connect_configure, 3);


value hx_GtkWidget_connectSwapped (value handle, value event, value fn)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);	
	g_signal_connect_swapped (widget, val_string(event), G_CALLBACK (Gtk_cb), fn);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWidget_connectSwapped, 3);


gboolean G_cb (gpointer data)
{
	return val_bool(val_call0((value)data));
}


value hx_G_timeoutAdd (value time, value fn)
{
	g_timeout_add(val_float(time), G_cb, fn);
	
	return alloc_null();
}
DEFINE_PRIM (hx_G_timeoutAdd, 2);


value hx_GdkWindow_invalidateRect (value windowh, value allocationh, value b)
{
	GdkWindow* window = (GdkWindow*)(intptr_t)val_float(windowh);
	GtkAllocation* allocation = (GtkAllocation*)(intptr_t)val_float(allocationh);
	
	gdk_window_invalidate_rect(window, allocation, val_bool(b));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GdkWindow_invalidateRect, 3);


value hx_GdkWindow_processUpdates (value windowh, value b)
{
	GdkWindow* window = (GdkWindow*)(intptr_t)val_float(windowh);
	
	gdk_window_process_updates(window, val_bool(b));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GdkWindow_processUpdates, 2);


value hx_GtkWidget_getAllocation (value handle)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	
	return alloc_float((intptr_t)&widget->allocation);
}
DEFINE_PRIM (hx_GtkWidget_getAllocation, 1);


value hx_GtkWidget_getWindow (value handle)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	
	return alloc_float((intptr_t)widget->window);
}
DEFINE_PRIM (hx_GtkWidget_getWindow, 1);


value hx_GtkWidget_getWidth (value handle)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	
	return alloc_int(widget->allocation.width);
}
DEFINE_PRIM (hx_GtkWidget_getWidth, 1);


value hx_GtkWidget_getHeight (value handle)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	
	return alloc_int(widget->allocation.height);
}
DEFINE_PRIM (hx_GtkWidget_getHeight, 1);


value hx_GtkWidget_getGlContext (value handle)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	GdkGLContext *glcontext = gtk_widget_get_gl_context(widget);
	
	return alloc_float((intptr_t)glcontext);
}
DEFINE_PRIM (hx_GtkWidget_getGlContext, 1);


value hx_GtkWidget_getGlDrawable (value handle)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	GdkGLDrawable *gldrawable = gtk_widget_get_gl_drawable(widget);
	
	return alloc_float((intptr_t)gldrawable);
}
DEFINE_PRIM (hx_GtkWidget_getGlDrawable, 1);


value hx_GtkWidget_setEvents (value handle, value event)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	gtk_widget_set_events(widget, val_int(event));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWidget_setEvents, 2);


value hx_GtkWidget_show (value handle)
{
	gtk_widget_show((GtkWidget*)(intptr_t)val_float(handle));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWidget_show, 1);


value hx_GtkWidget_showAll (value handle)
{
	gtk_widget_show_all((GtkWidget*)(intptr_t)val_float(handle));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWidget_showAll, 1);


value hx_GdkGLConfig_new (value mode)
{
	GdkGLConfig* config = gdk_gl_config_new_by_mode((GdkGLConfigMode)val_int(mode));
	
	return alloc_float((intptr_t)config);
}
DEFINE_PRIM (hx_GdkGLConfig_new, 1);


value hx_GtkDrawingArea_new ()
{
	GtkWidget* da = gtk_drawing_area_new();
	
	return alloc_float((intptr_t)da);
}
DEFINE_PRIM (hx_GtkDrawingArea_new, 0);


value hx_GtkWidget_setGlCapability (value handle, value configh, value a, value b, value type)
{
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(handle);
	GdkGLConfig* config = (GdkGLConfig*)(intptr_t)val_float(configh);
	GdkGLContext* context = (GdkGLContext*)(intptr_t)val_float(a);
	
	bool result = gtk_widget_set_gl_capability(widget, config, context, val_bool(b), val_int(type));
	
	return alloc_bool(result);
}
DEFINE_PRIM (hx_GtkWidget_setGlCapability, 5);


value hx_GtkLabel_new (value text)
{
	GtkWidget* label = gtk_label_new(val_string(text));
	
	return alloc_float((intptr_t)label);
}
DEFINE_PRIM (hx_GtkLabel_new, 1);


value hx_GtkLabel_getText (value handle)
{
	GtkLabel* label = (GtkLabel*)(intptr_t)val_float(handle);
	char** text;
	
	gtk_label_get(label, text);
	
	return alloc_string(*text);
}
DEFINE_PRIM (hx_GtkLabel_getText, 1);


value hx_GtkLabel_setText (value handle, value text)
{
	GtkLabel* label = (GtkLabel*)(intptr_t)val_float(handle);
	
	gtk_label_set_text(label, val_string(text));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkLabel_setText, 2);


value hx_GtkButton_new (value label)
{
	GtkWidget* button = gtk_button_new_with_label(val_string(label));
	
	return alloc_float((intptr_t)button);
}
DEFINE_PRIM (hx_GtkButton_new, 1);


value hx_GtkHbox_new (value a, value b)
{
	GtkWidget* hbox = gtk_hbox_new(val_bool(a), val_int(b));
	
	return alloc_float((intptr_t)hbox);
}
DEFINE_PRIM (hx_GtkHbox_new, 2);


value hx_GtkVbox_new (value a, value b)
{
	GtkWidget* vbox = gtk_vbox_new(val_bool(a), val_int(b));
	
	return alloc_float((intptr_t)vbox);
}
DEFINE_PRIM (hx_GtkVbox_new, 2);


value hx_GtkBox_packStart (value handle, value widgeth, value a, value b, value c)
{
	GtkWidget* box = (GtkWidget*)(intptr_t)val_float(handle);
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(widgeth);
	
	gtk_box_pack_start (GTK_BOX (box), widget, val_bool(a), val_bool(b), val_int(c));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkBox_packStart, 5);


value hx_GtkBox_packEnd (value handle, value widgeth, value a, value b, value c)
{
	GtkWidget* box = (GtkWidget*)(intptr_t)val_float(handle);
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(widgeth);
	
	gtk_box_pack_end (GTK_BOX (box), widget, val_bool(a), val_bool(b), val_int(c));
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkBox_packEnd, 5);


value hx_GtkWindow_new (value type)
{
	GtkWidget* window = gtk_window_new((GtkWindowType)val_int(type));
	
	return alloc_float((intptr_t)window);
}
DEFINE_PRIM (hx_GtkWindow_new, 1);


value hx_GtkWindow_setDefaultSize (value handle, value width, value height)
{
	GtkWidget* window = (GtkWidget*)(intptr_t)val_float(handle);
	gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkWindow_setDefaultSize, 3);


value hx_GtkContainer_add (value handle, value widgeth)
{
	GtkWidget* container = (GtkWidget*)(intptr_t)val_float(handle);
	GtkWidget* widget = (GtkWidget*)(intptr_t)val_float(widgeth);
	
	gtk_container_add (GTK_CONTAINER (container), widget);
	
	return alloc_null();
}
DEFINE_PRIM (hx_GtkContainer_add, 2);

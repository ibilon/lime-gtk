# Lime Gtk+

*Work in progress.*

A proof of concept on running a lime application inside of a gtk+ window.

## Compiling the ndll

Run:
```bash
cd project
haxelib run hxcpp Build.xml -DHXCPP_M64 -Dfulldebug
```

You need development libraries for:
* Gtk+ 2
* GtkGlExt
* Their dependencies

## Compiling the samples

You need a custom lime and openfl:
```bash
git clone https://github.com/ibilon/openfl.git -b lime
haxelib dev lime lime

git clone https://github.com/ibilon/openfl.git -b embed
haxelib dev openfl openfl
```

Then in each sample directory run:
```bash
lime build neko -Dnext -embed -debug
```

To revert to normal lime and openfl run:
```bash
haxelib dev lime
haxelib dev openfl
```

## Launching the application

```bash
haxe build.hxml
```

## Licence

The MIT License (MIT)

Copyright (c) 2014 Valentin Lemière

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

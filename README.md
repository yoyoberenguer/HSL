# HSL project

##  Why installing HSL :
```
This library offers fast conversion tools such as (HSL to RGB ) and (RGB to HSL) ported into cython for 
better performances 
```
 

## Project description :
```
Conversions between color systems (cython library)
This module defines bidirectional conversions of color values between colors
expressed in the RGB (Red Green Blue) color space used in computer monitors and three
HLS (Hue Lightness Saturation).
```

## Installation 
```
pip install HSL
```

## How to?
``` python
from HSL import rgb_to_hsl, hsl_to_rgb

if __name__ == '__main__':
    ONE_255 = 1.0 / 255.0
    r, g, b = 25, 60, 128
    print("\nOriginal RGB values (R:%s, G:%s, B:%s)\n" % (r, g, b))
    
    h, s, l = rgb_to_hsl(r * ONE_255, g * ONE_255, b * ONE_255)
    
    print("HSL values (H:%s, S:%s, L:%s)" % (h * 360.0, s * 100.0, l * 100.0))
    
    r, g, b = hsl_to_rgb(h, s, l)
    
    print("Retrieved RGB values (R:%s, G:%s, B:%s)\n" % (r * 255.0, g * 255.0, b * 255.0))
```

## Building cython code
```
If you need to compile the Cython code after changing the files hsl.pyx or hsl.pxd or
the external C code please proceed as follow:

1) open a terminal window
2) Go in the main project directory where (hsl.pyx & hsl.pxd files are located)
3) run : c:\python setup.hsl.py build_ext --inplace

If you have to compile the code with a specific python version, make sure
to reference the right python version in (c:\python setup.hsl.py build_ext --inplace)

If the compilation fail, refers to the requirement section and make sure cython
and a C-compiler are correctly install on your system.
- A compiler such visual studio, MSVC, CGYWIN setup correctly on your system.
  - a C compiler for windows (Visual Studio, MinGW etc) install on your system
  and linked to your windows environment.
  Note that some adjustment might be needed once a compiler is install on your system,
  refer to external documentation or tutorial in order to setup this process.
  e.g https://devblogs.microsoft.com/python/unable-to-find-vcvarsall-bat/
```

## Credit
Yoann Berenguer 

## Dependencies :
```
python >= 3.0
cython >= 0.28
```

## License :
```
GNU GENERAL PUBLIC LICENSE
                   Version 3, 29 June 2007

Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.

GNU General Public License v3.0
Permissions of this strong copyleft license are conditioned on making available
complete source code of licensed works and modifications, which include larger
works using a licensed work, under the same license. Copyright and license notices
must be preserved. Contributors provide an express grant of patent rights.

Copyright Yoann Berenguer
```

## Timing :
```python
Test with 1000000 iterations

This library
rgb_to_hsl per call 2.061723e-07 overall time 0.206172 seconds
hsl_to_rgb per call 1.181744e-07 overall time 0.118174 seconds

Colorsys library
colorsys.rgb_to_hls per call 1.054554e-06 overall  time 1.054554 seconds
colorsys.hls_to_rgb per call 8.701219e-07 overall  time 0.870121 seconds
```

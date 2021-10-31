# cython: binding=False, boundscheck=False, wraparound=False, nonecheck=False, cdivision=True, optimize.use_switch=True
# encoding: utf-8
"""
# HSL project

##  Why installing HSL :
```
This library offers a fast conversion tools such as (HSL to RGB ) and (RGB to HSL)
ported into cython for better performances
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
3) run : c:\python setup_hsl.py build_ext --inplace

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
MIT License

Copyright (c) 2019 Yoann Berenguer

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
"""


__version__ = "1.0.2"

__all__ = ["rgb_to_hsl","hsl_to_rgb"]

# CYTHON IS REQUIRED
try:
    cimport cython
except ImportError:
    raise("\n<cython> library is missing on your system."
          "\nTry: \n   C:\\pip install cython in a window command prompt.")

from hsl cimport struct_rgb_to_hsl, struct_hsl_to_rgb, HSL_, RGB_

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cpdef tuple rgb_to_hsl(double r, double g, double b):
    """
    CONVERT RGB TO HSL MODEL 
    
    This method is calling an external C function struct_rgb_to_hsl (source code in the file hsl_c.c)  
    
    :param r: python float; red normalized value in range [0...1.0]  
    :param g: python float; green normalized value in range [0...1.0]  
    :param b: python float; blue normalized value in range [0...1.0]  
    :return: Return a python object (tuple) of HSL values (Normalized python float, range [0...1.0]) 
    """
    assert 0 <= r <= 1.0, "\nRed value must be normalized!"
    assert 0 <= g <= 1.0, "\nGreen value must be normalized!"
    assert 0 <= b <= 1.0, "\nBlue value must be normalized!"

    cdef HSL_ hsl_ = struct_rgb_to_hsl(r, g, b)
    return <double>hsl_.h, <double>hsl_.s, <double>hsl_.l


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cpdef tuple hsl_to_rgb(double h, double s, double l):
    """
    CONVERT HSL MODEL TO RGB 
    
    This method is calling an external C function struct_hsl_to_rgb (source code in the file hsl_c.c)  
    
    :param h: python float; hue normalized value in range [0...1.0]  
    :param s: python float; saturation normalized value in range [0...1.0]  
    :param l: python float; lightness normalized value in range [0...1.0]  
    :return: Return a python object (tuple) of RGB values (Normalized python float, range [0...1.0])
    """
    assert 0 <= h <= 1.0, "\nhue value must be normalized!"
    assert 0 <= s <= 1.0, "\nsaturation value must be normalized!"
    assert 0 <= l <= 1.0, "\nlightness value must be normalized!"

    cdef RGB_ rgb_ = struct_hsl_to_rgb(h, s, l)
    return <double>rgb_.r, <double>rgb_.g, <double>rgb_.b







# HSL algorithm
HSL to RGB and RGB to HSL

## RGB to HSL and HSL to RGB colors system converstion tools.
```
This project provides the cython methods and C versions of the 
HSL conversion algorithms.

The code is based on the current python COLORSYS library, adapted and improved 
for an good increase in speed compare to the original model.

```
## Requirements: 
```
- python >=3.0  
- Cython 
- colorsys

Unlike most Python software, Cython requires a C compiler to be present on the system. 
The details of getting a C compiler varies according to the system used:

Linux The GNU C Compiler (gcc) is usually present, or easily available through the package system. 
On Ubuntu or Debian, for instance, the command sudo apt-get install build-essential will fetch 
everything you need.
Mac OS X To retrieve gcc, one option is to install Apple’s XCode, which can be retrieved from 
the Mac OS X’s install DVDs or from https://developer.apple.com/.
Windows A popular option is to use the open source MinGW (a Windows distribution of gcc). 
See the appendix for instructions for setting up MinGW manually. 
Enthought Canopy and Python(x,y) bundle MinGW, but some of the configuration steps in the 
appendix might still be necessary. 
Another option is to use Microsoft’s Visual C. One must then use the same version which the 
installed Python was compiled with.
The simplest way of installing Cython is by using pip:

pip install Cython
The newest Cython release can always be downloaded from https://cython.org/. 
Unpack the tarball or zip file, enter the directory, and then run:

python setup.py install
For one-time builds, e.g. for CI/testing, on platforms that are not covered by one of the 
wheel packages provided on PyPI,
it is substantially faster than a full source build to install an uncompiled (slower) 
version of Cython with

pip install Cython --install-option="--no-cython-compile"

```
## Compilation:
```
You need to re-compile the file hsl.pyx after any change(s). 
Use the following:
C:\>python setup_hsl.py build_ext --inplace

This will translates Cython source code into efficient C code

If you change the file hsv_c you will also need to recompile the project 
```
## How to:
```
import the code in your program:

import HSL

# This will import the cython version 
from HSL import rgb2hsl, hsl2rgb

# This will import the C version 
from HSL import rgb_to_hsl_c, hsl_to_rgb_c, struct_rgb_to_hsl_c, struct_hsl_to_rgb_c

if __name__ == '__main__':

  r, g, b = 25, 60, 128
  
  # BELOW TESTING RGB TO HSL AND HSL TO RGB (METHOD WITH POINTER)
  # hls values are normalized if you wish to convert it to a colorys format 
  # multiply h * 360, s * 100 and l * 100
  h, s, l = rgb2hsl(r / 255.0, g / 255.0, b / 255.0)
  # return rgb values normalized!
  r, g, b = hsl2rgb(h, s, l) 
  print("RGB (25, 60, 128) ", r * 255, g * 255, b * 255)
  
  # BELOW TESTING RGB TO HSL AND HSL TO RGB (METHOD C STRUCT)
  # THIS METHOD IS SLIGHTLY FASTER AND WE DO NOT HAVE TO WORRY ABOUT
  FREEING THE POINTER MEMORY
  r, g, b = 25, 60, 128
  h, s, l = struct_rgb_to_hsl_c(r/255.0, g/255.0, b/255.0)
  r, g, b = struct_hsl_to_rgb_c(h, s, l)
  print("RGB (25, 60, 128) ", r * 255, g * 255, b * 255)
  

```
## Timings:
```
for 1000000 iterations
TIMINGS :

Cython    rgb2hsl             0.270(s)      for 1000000 iterations
Cython    hsl2rgb             0.200(s)      for 1000000 iterations

C         rgb_to_hsl_c        0.261(s)      for 1000000 iterations   (use pointer)
C         hsl_to_rgb_c        0.176(s)      for 1000000 iterations   (use pointer)

C         struct_rgb_to_hsl_c 0.192(s)      for 1000000 iterations   (use C struct type)
C         struct_hsl_to_rgb_c 0.200(s)      for 1000000 iterations   (use C struct type)
          
Colorsys  rgb_to_hls          0.884(s)      for 1000000 iterations   
Colorsys  hls_to_rgb          0.811(s)      for 1000000 iterations 



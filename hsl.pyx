###cython: boundscheck=False, wraparound=False, nonecheck=False, optimize.use_switch=True

# CYTHON IS REQUIRED
try:
    cimport cython
    from cython.parallel cimport prange
except ImportError:
    print("\n<cython> library is missing on your system."
          "\nTry: \n   C:\\pip install cython on a window command prompt.")
    raise SystemExit

from libc.stdlib cimport srand, rand, RAND_MAX, qsort, malloc, free
from libc.math cimport fabs, fmod

DEF ONE_255   = 1.0/255.0
DEF ONE_360   = 1.0/360.0
DEF TWO_THIRD = 2.0/3.0
DEF ONE_SIXTH = 1.0/6.0
DEF ONE_THIRD = 1.0/3.0

# EXTERNAL C CODE (file 'hsl_c.c')
cdef extern from 'hsl_c.c' nogil:

    struct hsl:
        double h
        double s
        double l

    struct rgb:
        double r
        double g
        double b

    # METHOD WITH POINTER
    double * rgb_to_hsl(double r, double g, double b)nogil;
    double * hsl_to_rgb(double h, double s, double l)nogil;
    # METHOD WITH STRUCT
    hsl struct_rgb_to_hsl(double r, double g, double b)nogil;
    rgb struct_hsl_to_rgb(double h, double s, double l)nogil;
    # DETERMINE RGB MAX VALUES
    double fmax_rgb_value(double red, double green, double blue)nogil;
    double fmin_rgb_value(double red, double green, double blue)nogil;

ctypedef hsl HSL
ctypedef rgb RGB

# -------------------------------------- INTERFACE ------------------------------------------

# METHOD CYTHON (USING POINTER)
# CONVERT HSL TO RGG
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef hsl2rgb(double h, double s, double l):
    cdef:
        double *rgb
        double r, g, b
    rgb = hsl2rgb_c(h, s, l)
    r, g, b = rgb[0], rgb[1], rgb[2]
    free(rgb)
    return r, g, b

# METHOD CYTHON (USING POINTER)
# CONVERT RGB TO HSL
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef rgb2hsl(double r, double g, double b):
    cdef:
        double *hsl
        double h, s, l
    hsl = rgb2hsl_c(r, g, b)
    h, s, l = hsl[0], hsl[1], hsl[2]
    free(hsl)
    return h, s, l

# HOOK FOR THE C VERSION (USING POINTER)
# HSL TO RGB
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef hsl_to_rgb_c(double h, double s, double l):
    cdef:
        double *rgb
        double r, g, b
    rgb = hsl_to_rgb(h, s, l)
    r, g, b = rgb[0], rgb[1], rgb[2]
    free(rgb)
    return r, g, b

# HOOK FOR THE C VERSION (USING POINTER)
# RGB TO HSL
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef rgb_to_hsl_c(double r, double g, double b):
    cdef:
        double *hsl
        double h, s, l
    hsl = rgb_to_hsl(r, g, b)
    h, s, l = hsl[0], hsl[1], hsl[2]
    free(hsl)
    return h, s, l


# HOOK TO THE C VERSION (USING STRUCT)
# RGB TO HSL
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple struct_rgb_to_hsl_c(double r, double g, double b):
    cdef HSL hsl_
    hsl_ = struct_rgb_to_hsl(r, g, b)
    return hsl_.h, hsl_.s, hsl_.l

# HOOK TO THE C VERSION (USING STRUCT)
# HSL TO RGB
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple struct_hsl_to_rgb_c(double h, double s, double l):
    cdef RGB rgb_
    rgb_ = struct_hsl_to_rgb(h, s, l)
    return rgb_.r, rgb_.g, rgb_.b

# ----------------------------------------- SOURCE CODE ------------------------------------------------

# HSL: Hue, Saturation, Luminance
# H: position in the spectrum
# L: color lightness
# S: color saturation
# All inputs and outputs are triples of floats in the range [0.0...1.0]
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cdef inline double * rgb2hsl_c(double r, double g, double b)nogil:
    """
    Convert RGB color model into HSL model
    * Don't forget to free the memory allocated for rgb values if you are 
    calling the method without using the cpdef function (see interface section).
    (Use the same pointer address returned by malloc() to free the block)
    
    :param r: pygame float, red value in range   [0.0 ... 1.0]
    :param g: pygame float, green value in range [0.0 ... 1.0] 
    :param b: pygame float, blue value in range  [0.0 ... 1.0]
    :return: return HSL values (float)  in range [0.0 ... 1.0] 
    To convert in % do the following 
    h = h * 360 
    s = s * 100
    l = l * 100
    """
    cdef:
        double maxc, minc, l, s, rc, gc, bc, h
        double high, low, high_
        double *hsl = <double *> malloc(3 * sizeof(double))

    # SLOW DOWN
    maxc = fmax_rgb_value(r, g, b)
    minc = fmin_rgb_value(r, g, b)

    high = maxc-minc
    high_ = 1.0 /high
    low = maxc+minc
    l = (minc+maxc)* 0.5

    if minc == maxc:
        hsl[0] = 0.0
        hsl[1] = 0.0
        hsl[2] = l
        return hsl

    if l <= 0.5:
        s = high / low
    else:
        s = high / (2.0-maxc-minc)

    rc = (maxc-r) * high_
    gc = (maxc-g) * high_
    bc = (maxc-b) * high_

    if r == maxc:
        h = bc - gc
    elif g == maxc:
        h = 2.0 + rc - bc
    else:
        h = 4.0 + gc - rc

    h = h * ONE_SIXTH
    if h < 0:
        hsl[0] = 1.0 - (h * -1)
    else:
        hsl[0] = fmod(h, 1.0)

    hsl[1] = s
    hsl[2] = l
    return hsl

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(False)
cdef double * hsl2rgb_c(double h, double s, double l)nogil:
    """
    Convert HSL color model into RGB model
    * Don't forget to free the memory allocated for rgb values if you are 
    calling the method without using the cpdef function (see interface section).
    (Use the same pointer address returned by malloc() to free the block)

    :param h: pygame float, hue value in range  [0.0 ... 1.0] 
    :param s: pygame float, saturation in range [0.0 ... 1.0] 
    :param l: pygame float, lightness in range  [0.0 ... 1.0] 
    :return: return RGB values (float) in range [0.0 ... 1.0] 
    
    To convert to the pixel color do the following for each element
    r = r * 255
    g = g * 255
    b = b * 255
    
    """
    cdef:
        double m1=0, m2=0
        double *rgb = <double *> malloc(3 * sizeof(double))

    if s == 0.0:
        rgb[0] = l
        rgb[1] = l
        rgb[2] = l
        return rgb

    if l <= 0.5:
        m2 = l * (1.0 + s)
    else:
        m2 = l + s -(l * s)

    m1 = 2.0 * l - m2

    rgb[0] = _v(m1, m2, h + ONE_THIRD)
    rgb[1] = _v(m1, m2, h)
    rgb[2] = _v(m1, m2, h - ONE_THIRD)
    return rgb



@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
#@cython.cdivision(True) DO NOT USE C DIVISION with % modulo
cdef double _v(double m1, double m2, double h)nogil:

    h = h % 1.0
    if h < ONE_SIXTH:
        return m1 + (m2 - m1) * h * 6.0
    if h < 0.5:
        return m2
    if h < TWO_THIRD:
        return m1 + (m2 - m1) * (TWO_THIRD - h) * 6.0
    return m1


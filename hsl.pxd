###cython: boundscheck=False, wraparound=False, nonecheck=False, optimize.use_switch=True

__version__ = "1.0.1"

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

    struct rgba:
        double r
        double g
        double b
        double a

    # METHOD WITH POINTER
    double * rgb_to_hsl(double r, double g, double b)nogil;
    double * hsl_to_rgb(double h, double s, double l)nogil;
    # METHOD WITH STRUCT
    hsl struct_rgb_to_hsl(double r, double g, double b)nogil;
    rgb struct_hsl_to_rgb(double h, double s, double l)nogil;
    # DETERMINE RGB MAX VALUES
    double fmax_rgb_value(double red, double green, double blue)nogil;
    double fmin_rgb_value(double red, double green, double blue)nogil;


cdef double * rgb2hsl_c(double r, double g, double b)nogil;
cdef double * hsl2rgb_c(double h, double s, double l)nogil;
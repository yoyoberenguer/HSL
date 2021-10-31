# cython: binding=False, boundscheck=False, wraparound=False, nonecheck=False, cdivision=True, optimize.use_switch=True
# encoding: utf-8

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

    # METHOD WITH STRUCT
    hsl struct_rgb_to_hsl(double r, double g, double b)nogil;
    rgb struct_hsl_to_rgb(double h, double s, double l)nogil;

ctypedef hsl HSL_
ctypedef rgb RGB_

cpdef tuple rgb_to_hsl(double r, double g, double b);
cpdef tuple hsl_to_rgb(double h, double s, double l);

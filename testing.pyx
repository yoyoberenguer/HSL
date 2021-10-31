# cython: binding=False, boundscheck=False, wraparound=False, nonecheck=False, cdivision=True, optimize.use_switch=True
# encoding: utf-8

from cython.parallel cimport prange


from libc.math cimport fabs
from libc.stdio cimport printf

from hsl cimport struct_rgb_to_hsl, struct_hsl_to_rgb, HSL_, RGB_

DEF TOLERANCE = 1e-7

cdef double ONE_255 = 1.0 / 255.0


cdef inline void show_error(unsigned int i, unsigned int j, unsigned int k, RGB_ rgb_):
    """
    
    :param i: integer value; red value 
    :param j: integer value; green value 
    :param k: integer; blue value 
    :param rgb_: tuple values (C struct) containing the calculated RGB values
    :return: void
    """
    printf("\nOriginal RGB R:%d G:%d B:%d :", i, j, k)
    printf("\nRetrieve RGB R:%f G:%f B:%f :", rgb_.r * 255.0, rgb_.g * 255.0, rgb_.b * 255.0)
    printf("\ndiff RGB dR:%g dG:%g dB:%g :\n",
           rgb_.r * - <double>i, rgb_.g * 255.0 - <double>j, rgb_.b * 255.0 - <double>k)


cpdef void rgb_to_hsl_testing(bint wall_ = False, double tolerance_ = TOLERANCE)nogil:
    """
    TEST RGB TO HSL AND HSL TO RGB 
    
    Loop over every RGB values from 0 .. 255 and determine the HSL values corresponding to the 
    RGB value.Convert the HSL value back to RGB (monitoring the maximum deviation between real value 
    and calculated value) and raise an error if the deviation is over the tolerance 1e-7
    
    :param wall_     : boolean; default False; stop at test at first tolerance issue when True otherwise continue  
    :param tolerance_: float; python float representing the maximum tolerance, default is 1e-7. The tolerance 
    represent the maximum deviation for the original value (original value - calculated value) that should not 
    exceed the tolerance
    :return: void
    """

    cdef int i, j, k
    cdef double h, s, l , h1, l1, s1

    cdef HSL_ hsl_
    cdef RGB_ rgb_

    # Loop over every RGB values possible
    for i in prange(256):
        for j in range(256):
            for k in range(256):

                hsl_ = struct_rgb_to_hsl(i * ONE_255, j * ONE_255, k * ONE_255)
                rgb_ = struct_hsl_to_rgb(hsl_.h, hsl_.s, hsl_.l)

                if rgb_.r * 255.0 - <double>i > tolerance_:
                    with gil:
                        show_error(i, j, k, rgb_)
                        if wall_: raise ValueError("\nMismatch error")

                if rgb_.g * 255.0 - <double>j > tolerance_:
                    with gil:
                        show_error(i, j, k, rgb_)
                        if wall_: raise ValueError("\nMismatch error")
 
                if rgb_.b * 255.0 - <double>k > tolerance_:
                    with gil:
                        show_error(i, j, k, rgb_)
                        if wall_: raise ValueError("\nMismatch error")


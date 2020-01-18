import HSL

# This will import the cython version 
from HSL import rgb2hsl, hsl2rgb

# This will import the C version 
from HSL import rgb_to_hsl_c, hsl_to_rgb_c

# This import colorsys algo for verifications.
import colorsys
from colorsys import rgb_to_hls, hls_to_rgb

import timeit

if __name__ == '__main__':
    print('TESTING HSL CYTHON VERSION')
    # ---------- CYTHON VERSION ---------------------------------------------------------
    r, g, b = 25, 60, 128
    print("\nOriginal RGB values red %s, green %s, blue %s " % (r, g, b))
    # Don't forget to normalise the values (/255.0)
    hsl = rgb2hsl(r / 255.0, g / 255.0, b / 255.0)
    print("Cython hsl values       : ", hsl)
    print("Cython hsl formated     : ", hsl[0] * 360, hsl[1] * 100, hsl[2] * 100)

    hls1 = colorsys.rgb_to_hls(r / 255.0, g / 255.0, b / 255.0)
    print("\nColorsys hls          : ", hls1)
    print("Colorsys hsv formated : ", hls1[0] * 360, hls1[1] * 100, hls1[2] * 100)
    h, s, l = list(hsl)
    rgb = hsl2rgb(h, s, l)
    red = round(rgb[0] * 255.0)
    green = round(rgb[1] * 255.0)
    blue = round(rgb[2] * 255.0)
    print("Cython rgb values : red %s, green %s, blue %s " % (red, green, blue))

    print('\nTESTING HSL C VERSION')
    # ---------- C VERSION -------------------------------------------------------------
    r, g, b = 25, 60, 128
    print("\nOriginal RGB values red %s, green %s, blue %s " % (r, g, b))
    # Don't forget to normalise the values (/255.0)
    hsl = rgb_to_hsl_c(r / 255.0, g / 255.0, b / 255.0)
    print("C hsl values     : ", hsl)
    print("C hsl formated   : ", hsl[0] * 360, hsl[1] * 100, hsl[2] * 100)

    hls1 = colorsys.rgb_to_hls(r / 255.0, g / 255.0, b / 255.0)
    print("\nColorsys hls          : ", hls1)
    print("Colorsys hsv formated : ", hls1[0] * 360, hls1[1] * 100, hls1[2] * 100)
    h, s, l = list(hsl)
    rgb = hsl_to_rgb_c(h, s, l)
    red = round(rgb[0] * 255.0)
    green = round(rgb[1] * 255.0)
    blue = round(rgb[2] * 255.0)
    print("\nC rgb values : red %s, green %s, blue %s \n" % (red, green, blue))

    N = 1000000

    print("\nTIMINGS :")
    print("Cython rgb2hsl %s for %s iterations: " % (timeit.timeit("rgb2hsl(r/255.0, g/255.0, b/255.0)",
                                                                   "from __main__ import rgb2hsl, r, g, b", number=N),
                                                     N))
    print("C rgb_to_hsl_c %s for %s iterations: " % (timeit.timeit("rgb_to_hsl_c(r/255.0, g/255.0, b/255.0)",
                                                                   "from __main__ import rgb_to_hsl_c, r, g, b",
                                                                   number=N), N))
    print("Colorsys rgb_to_hls %s for %s iterations: " % (timeit.timeit("rgb_to_hls(r/255.0, g/255.0, b/255.0)",
                                                                        "from __main__ import rgb_to_hls, r, g, b",
                                                                        number=N), N))


    # TEST CYTHON rgb2hsl method vs colorsys.rgb_to_hls
    for i in range(256):
       for j in range(256):
           for k in range(256):
               hsl = rgb2hsl(i/255.0, j/255.0, k/255.0)
               hls = colorsys.rgb_to_hls(i/255.0, j/255.0, k/255.0)
               h, s, l = round(hsl[0], 2), round(hsl[1], 2), round(hsl[2], 2)
               h1, l1, s1 = round(hls[0], 2), round(hls[1], 2), round(hls[2], 2)
               if abs(h - h1)> 0.1 or abs(s - s1) > 0.1 or abs(l-l1) > 0.1:
                   print("\n R:%s G:%s B :%s " % (i, j, k))
                   print("rgb_to_hsl_c   : h:%s s:%s l:%s " % (h, s, l))
                   print("rgb_to_hls     : h:%s s:%s l:%s " % (h1, s1, l1))
                   raise ValueError("discrepancy.")

    # TEST CYTHON rgb_to_hsl_c method vs colorsys.rgb_to_hls
    for i in range(256):
        for j in range(256):
           for k in range(256):
               hsl = rgb_to_hsl_c(i/255.0, j/255.0, k/255.0)
               hls = colorsys.rgb_to_hls(i/255.0, j/255.0, k/255.0)
               h, s, l = round(hsl[0], 2), round(hsl[1], 2), round(hsl[2], 2)
               h1, l1, s1 = round(hls[0], 2), round(hls[1], 2), round(hls[2], 2)
               if abs(h - h1) > 0.1 or abs(s - s1) > 0.1 or abs(l-l1) > 0.1:
                   print("\n R:%s G:%s B :%s " % (i, j, k))
                   print("rgb_to_hsl_c   : h:%s s:%s l:%s " % (h, s, l))
                   print("rgb_to_hls     : h:%s s:%s l:%s " % (h1, s1, l1))
                   raise ValueError("discrepancy.")

    # TEST C hsl_to_rgb_c method vs colorsys.hls_to_rgb
    for i in range(256):
        for j in range(256):
            for k in range(256):
                hls = colorsys.rgb_to_hls(i / 255.0, j / 255.0, k / 255.0)
                h1, l1, s1 = hls[0], hls[1], hls[2]
                rgb = hsl_to_rgb_c(h1, s1, l1)
                # rgb = hsl2rgb(h1, s1, l1)
                r, g, b = rgb[0] * 255.0, rgb[1] * 255.0, rgb[2] * 255.0
                rgb1 = colorsys.hls_to_rgb(h1, l1, s1)
                r1, g1, b1 = rgb1[0] * 255.0, rgb1[1] * 255.0, rgb1[2] * 255.0
                if abs(r - r1) > 0.1 or abs(g - g1) > 0.1 or abs(b - b1) > 0.1:
                    print("\n", i, j, k)
                    print(r, g, b)
                    print(r1, g1, b1)
                    raise ValueError("discrepancy.")

    # TEST C hsl2rgb method vs colorsys.hls_to_rgb
    for i in range(256):
        for j in range(256):
            for k in range(256):
                hls = colorsys.rgb_to_hls(i / 255.0, j / 255.0, k / 255.0)
                h1, l1, s1 = hls[0], hls[1], hls[2]
                rgb = hsl2rgb(h1, s1, l1)
                r, g, b = rgb[0] * 255.0, rgb[1] * 255.0, rgb[2] * 255.0
                rgb1 = colorsys.hls_to_rgb(h1, l1, s1)
                r1, g1, b1 = rgb1[0] * 255.0, rgb1[1] * 255.0, rgb1[2] * 255.0

                if abs(r - r1) > 0.1 or abs(g - g1) > 0.1 or abs(b - b1) > 0.1:
                    print("\n R:%s G:%s B:%s " % (i, j, k))
                    print("hsl2rgb R:%s G:%s B:%s " % (r, g, b))
                    print("colorsys : R:%s G:%s B:%s " % (r1, g1, b1))
                    raise ValueError("discrepancy.")
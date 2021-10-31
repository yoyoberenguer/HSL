import unittest
from testing import rgb_to_hsl_testing
from hsl import rgb_to_hsl, hsl_to_rgb
import timeit


class Test_RGB2HSL_Values(unittest.TestCase):
    @staticmethod
    def runTest() -> None:
        """
        TEST rgb_to_hsl & hsl_to_rgb

        Loop over every RGB values possible and check the data consistency
        This test checks both methods rgb_to_hsl & hsl_to_rgb

        :return: void
        """

        rgb_to_hsl_testing()


class Test_RGB2HSL_Variables(unittest.TestCase):

    def runTest(self) -> None:
        """
        TEST rgb_to_hsl algorithm
        :return: void
        """
        # RGB (16, 32, 64) = HLS (0.6111111111111112, 0.6, 0.1568627450980392)
        # Above values provided by colorsys.rgb_to_hls algorithm

        # Check the type of the value returned
        hsl = rgb_to_hsl(16.0 / 255.0, 32.0 / 255.0, 64.0 / 255.0)
        self.assertIsInstance(hsl, tuple)

        # Check the values HSL compare to colorsys values (7 decimals)
        h, s, l = rgb_to_hsl(16.0/255.0, 32.0/255.0, 64.0/255.0)
        valid_decimal = 7
        self.assertEqual(round(h * 360.0, valid_decimal), round(0.6111111111111112 * 360, valid_decimal))
        self.assertEqual(round(s * 100.0, valid_decimal), round(0.6 * 100, valid_decimal))
        self.assertEqual(round(l * 100.0, valid_decimal), round(0.1568627450980392 * 100, valid_decimal))

        self.assertRaises(AssertionError, rgb_to_hsl, 16.0, 32.0 / 255.0, 64.0 / 255.0)
        self.assertRaises(AssertionError, rgb_to_hsl, 16.0 / 255.0, 32.0, 64.0 / 255.0)
        self.assertRaises(AssertionError, rgb_to_hsl, 16.0 / 255.0, 32.0 / 255.0, 64.0)

        self.assertRaises(AssertionError, rgb_to_hsl, -16.0 / 255.0, 32.0 / 255.0, 64.0 / 255.0)
        self.assertRaises(AssertionError, rgb_to_hsl, 16.0 / 255.0, -32.0 / 255.0, 64.0 / 255.0)
        self.assertRaises(AssertionError, rgb_to_hsl, 16.0 / 255.0, 32.0 / 255.0, -64.0 / 255.0)

        h, s, l = rgb_to_hsl(16.0 / 255.0, 32.0 / 255.0, 64.0 / 255.0)
        self.assertIsInstance(h, float)
        self.assertIsInstance(s, float)
        self.assertIsInstance(l, float)

        # colorsys.rgb_to_hls(128 / 255, 0 / 255, 255 / 255) =  (0.7503267973856209, 0.5, 1.0)
        h, s, l = rgb_to_hsl(128 / 255, 0 / 255, 255 / 255)
        self.assertAlmostEqual(h * 360, 0.7503267973856209 * 360, places=6)
        self.assertAlmostEqual(s * 100, 1.0 * 100, places=6)
        self.assertAlmostEqual(l * 100, 0.5 * 100, places=6)

        # colorsys.rgb_to_hls(0 / 255, 0 / 255, 0 / 255) =  (0.0, 0.0, 0.0)
        h, s, l = rgb_to_hsl(0 / 255, 0 / 255, 0 / 255)
        self.assertEqual(h * 360, 0)
        self.assertEqual(s * 100, 0)
        self.assertEqual(l * 100, 0)


class Test_HSL2RGB_Variables(unittest.TestCase):

    def runTest(self) -> None:
        """
        TEST hsl_to_rgb algorithm

        :return: void
        """
        # colorsys.hls_to_rgb(0.6893939393939394, 0.13333333333333333, 0.6470588235294118)
        # '(0.07058823529411762, 0.047058823529411764, 0.2196078431372549) = RGB (18, 12, 56)
        # Above values provided by colorsys.hsl_to_rgb algorithm

        # Check the type of the value returned
        rgb = hsl_to_rgb(0.6893939393939394, 0.6470588235294118, 0.13333333333333333)
        self.assertIsInstance(rgb, tuple)

        # Check the values HSL compare to colorsys values (7 decimals)
        r, g, b = hsl_to_rgb(0.6893939393939394, 0.6470588235294118, 0.13333333333333333)
        valid_decimal = 7
        self.assertEqual(round(r * 255.0, valid_decimal), round(0.07058823529411762 * 255, valid_decimal))
        self.assertEqual(round(g * 255.0, valid_decimal), round(0.047058823529411764 * 255, valid_decimal))
        self.assertEqual(round(b * 255.0, valid_decimal), round(0.2196078431372549 * 255, valid_decimal))

        self.assertRaises(AssertionError, hsl_to_rgb, 16.0, 0.1, 0.5)
        self.assertRaises(AssertionError, hsl_to_rgb, 0.2, 32.0, 0.1)
        self.assertRaises(AssertionError, hsl_to_rgb, 0.2, 0.1, 64.0)

        self.assertRaises(AssertionError, hsl_to_rgb, -0.1, 0.2, 0.3)
        self.assertRaises(AssertionError, hsl_to_rgb, 0.2, -0.1, 0.3)
        self.assertRaises(AssertionError, hsl_to_rgb, 0.2, 0.3, -0.1)

        r, g, b = hsl_to_rgb(0.6893939393939394, 0.6470588235294118, 0.13333333333333333)
        self.assertIsInstance(r, float)
        self.assertIsInstance(g, float)
        self.assertIsInstance(b, float)

        # (0.9763779527559056, 0.2529411764705882, 0.9844961240310078) RGB (128, 1, 19)
        # (0.5019607843137255, 0.0039215686274509665, 0.07450980392156815)
        r, g, b = hsl_to_rgb(0.9763779527559056, 0.9844961240310078, 0.2529411764705882)
        self.assertAlmostEqual(r * 255.0, 0.5019607843137255 * 255, places=6)
        self.assertAlmostEqual(g * 255.0, 0.0039215686274509665 * 255, places=6)
        self.assertAlmostEqual(b * 255.0, 0.07450980392156815 * 255, places=6)

        # colorsys.rgb_to_hls(0 / 255, 0 / 255, 0 / 255) =  (0.0, 0.0, 0.0)
        r, g, b = hsl_to_rgb(0 / 255, 0 / 255, 0 / 255)
        self.assertEqual(r * 255.0, 0)
        self.assertEqual(g * 255.0, 0)
        self.assertEqual(b * 255.0, 0)


class Test_RGB2HSL_recurrence(unittest.TestCase):

    def runTest(self) -> None:
        """
        TEST rgb_to_hsl & hsl_to_rgb

        Recurrent Test with unique RGB values pushed in a loop to
        check if the values drift after N (1e6) iterations.
        This test is essentials to prove that the RGB values are
        accurate to 1e6 decimal and to observed no degradation of the
        values overtimes using both algorithms rgb_to_hsl & hsl_to_rgb, back to back

        :return: void
        """
        # colorsys rgb_to_hsl (18 / 255, 12 / 255, 56 / 255)
        # HSL = (0.6893939393939394, 0.13333333333333333, 0.647058823529411
        r = 18.0 / 255.0
        g = 12.0 / 255.0
        b = 56.0 / 255.0
        iteration = int(1e6)
        for x in range(iteration):
            h, s, l = rgb_to_hsl(r, g, b)
            r, g, b = hsl_to_rgb(h, s, l)
        self.assertAlmostEqual(r, 18.0 / 255.0, places=10)
        self.assertAlmostEqual(g, 12.0 / 255.0, places=10)
        self.assertAlmostEqual(b, 56.0 / 255.0, places=10)


if __name__ == '__main__':

    suite = unittest.TestSuite()

    suite.addTests([
        Test_RGB2HSL_Values(),
        Test_RGB2HSL_Variables(),
        Test_HSL2RGB_Variables(),
        Test_RGB2HSL_recurrence()
    ])

    unittest.TextTestRunner().run(suite)

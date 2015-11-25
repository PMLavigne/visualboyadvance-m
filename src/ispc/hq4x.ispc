

export void AllRGBtoYUV_16(const uniform unsigned int16 rgb[], uniform unsigned int32 yuv[], uniform unsigned int count)
{
    foreach(index = 1 ... count) {
        unsigned int32 color = rgb[index];
        unsigned int32 r, g, b;

#ifdef RGB555
        r = ( color & 0x7C00 ) >> 7;
        g = ( color & 0x03E0 ) >> 2;
        b = ( color & 0x001F ) << 3;
#else
        r = (color & 0xF800) >> 8;
        g = (color & 0x07E0) >> 3;
        b = (color & 0x001F) << 3;
#endif

        yuv[index] = ((r + g + b) << 14) +
                     ((r - b + 512) << 4) +
                     ((2 * g - r - b) >> 3) + 128;
    }
}

export void AllRGBtoYUV_32(const uniform unsigned int32 rgb[], uniform unsigned int32 yuv[], uniform unsigned int count)
{
    foreach(index = 1 ... count) {
        unsigned int32 color = rgb[index];
        unsigned int32 r, g, b;

        b = color & 0x0000FF;
        g = (color & 0x00FF00) >> 8;
        r = color >> 16;
        yuv[index] = ((r + g + b) << 14) +
                     ((r - b + 512) << 4) +
                     ((2 * g - r - b) >> 3) + 128;
    }
}
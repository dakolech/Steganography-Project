#require 'chunky_png'
require 'oily_png'

image = ChunkyPNG::Image.from_file('images/cat_big.png')
image[0, 0] = ChunkyPNG::Color.rgba(255, 0,0, 128)
image.line(1, 1, 10, 1, ChunkyPNG::Color.from_hex('#aa007f'))
image.save('images/cat_big_changed.png')

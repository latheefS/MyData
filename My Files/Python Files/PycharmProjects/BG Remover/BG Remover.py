import output
from rembg import remove
from PIL import Image
image_input = Image.open(r'C:\Users\LatheefS\Desktop\Latheeef\SAR01696.JPG')
output = remove(image_input)
output.save(r'C:\Users\LatheefS\Desktop\SAR01696bg.png')
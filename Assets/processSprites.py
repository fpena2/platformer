from PIL import Image
import sys
import os
import glob
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--mir", nargs=1,
                    help="Folder of images to mirror", metavar='path')
parser.add_argument("--hor", nargs=1,
                    help="Folder of images to add horrizontally", metavar='path')
parser.add_argument("--ver", nargs=1,
                    help="Folder of images to add vertically", metavar='path')
args = vars(parser.parse_args())


print(args)
if args["mir"]:
    mirrorImg(args["mir"])
elif args["hor"]:
    horizonalSheet(args["hor"])
elif args["ver"]:
    verticalSheet(args["ver"])


def mirrorImg(folder):
    if (not os.path.isdir(folder)):
        sys.exit('Provide valid folder')
    for imgFile in glob.glob(os.path.join(os.getcwd(), folder, "*.png")):
        fileName = os.path.basename(imgFile)
        im = Image.open(imgFile).transpose(Image.FLIP_LEFT_RIGHT)
        im.save("FLIP_" + fileName)


def horizonalSheet(folder):
    imgList = []
    for imgFile in glob.glob(os.path.join(os.getcwd(), folder, "*.png")):
        fileName = os.path.basename(imgFile)
        imgList.append(fileName)

    images = map(Image.open, imgFile)
    widths, heights = zip(*(i.size for i in images))
    sumWidth = sum(widths)
    maxHeight = max(heights)
    newImg = Image.new("RGB", (sumWidth, maxHeight))

    count = 0
    for img in images:
        newImg.paste(img, (count, 0))
        count += img.size[0]

    newImg.save("HSprite.png")


def verticalSheet():
    pass

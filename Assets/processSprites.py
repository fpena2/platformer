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


def mirrorImg(folder):
    if (not os.path.isdir(folder)):
        sys.exit('Provide valid folder')
    for imgFile in glob.glob(os.path.join(os.getcwd(), folder, "*.png")):
        fileName = os.path.basename(imgFile)
        im = Image.open(imgFile).transpose(Image.FLIP_LEFT_RIGHT)
        im.save("FLIP_" + fileName)


def directionalSheet(arg, folder):
    imgList = []
    for imgFile in glob.glob(os.path.join(os.getcwd(), folder, "*.png")):
        imgList.append(imgFile)
    # Sort images based on numbers from filename
    imgList.sort(key=lambda x:
                 int(x[x.rfind("/")+1:x.rfind(".")]))

    images = list(Image.open(img) for img in imgList)
    widths, heights = zip(*(i.size for i in images))
    # Horizontal sprite sheet
    if arg == "hor":
        sumWidth = sum(widths)
        maxHeight = max(heights)
        newImg = Image.new("RGBA", (sumWidth, maxHeight))

        count = 0
        for img in images:
            newImg.paste(img, (count, 0))
            count += img.size[0]
        newImg.save("HSprite.png")

    else:
        maxWidth = max(widths)
        sumHeight = sum(heights)
        newImg = Image.new("RGBA", (maxWidth, sumHeight))

        count = 0
        for img in images:
            newImg.paste(img, (0, count))
            count += img.size[1]
        newImg.save("VSprite.png")


for aPath in args.values():
    if aPath is not None:
        if os.path.isdir(aPath[0]):
            if args["mir"]:
                mirrorImg(args["mir"][0])
            elif args["hor"]:
                directionalSheet("hor", args["hor"][0])
            elif args["ver"]:
                directionalSheet("ver", args["ver"][0])


import sys

points = []
for ln in sys.stdin:
	points += [ln.split(' ')]
	
colorCode = {
	'G': 'GreenSpace',
	'Y': 'YellowSpace',
	'R': 'RedSpace'
}

for (x, y, color) in points:
	print 'spaceAt(%sf, %sf, %s)' % (x, y, colorCode[color[0]])


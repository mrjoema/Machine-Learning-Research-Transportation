import gmplot
import sqlite3
from scipy.io import loadmat
import polyline

# Helper function
def decode_polyline(polyline_str):
    index, lat, lng = 0, 0, 0
    coordinates = []
    changes = {'latitude': 0, 'longitude': 0}

    # Coordinates have variable length when encoded, so just keep
    # track of whether we've hit the end of the string. In each
    # while loop iteration, a single coordinate is decoded.
    while index < len(polyline_str):
        # Gather lat/lon changes, store them in a dictionary to apply them later
        for unit in ['latitude', 'longitude']:
            shift, result = 0, 0

            while True:
                byte = ord(polyline_str[index]) - 63
                index+=1
                result |= (byte & 0x1f) << shift
                shift += 5
                if not byte >= 0x20:
                    break

            if (result & 1):
                changes[unit] = ~(result >> 1)
            else:
                changes[unit] = (result >> 1)

        lat += changes['latitude']
        lng += changes['longitude']

        coordinates.append((lat / 100000.0, lng / 100000.0))

    return coordinates

############################################################

x = loadmat('test_result.mat')
labels = x['label']

# Connect to SQLite Database
conn = sqlite3.connect('traffic.db')
print ("Opened database successfully");

speedingDict = {}

for label in labels:
    label = int(label or 0)
    speedingDict[label] = 0

speedingCounts = 0;
plotCount = 0;
count = 0

gmap = gmplot.GoogleMapPlotter(40.7538404,-74.007241, 10)

# Select all speed records
cursor = conn.execute("SELECT EncodedPolyLine from SENSOR_INFO")
rows = cursor.fetchall()
for row in rows:
    coord_str = row[0]
    print(count,': ',coord_str)
    try:
        coord_list = polyline.decode(coord_str)
        x_data = []
        y_data = []
        for coordinate in coord_list:
            x_data.append(coordinate[0])
            y_data.append(coordinate[1])
        print('----')
        # plot heatmap
        if len(x_data) == len(y_data):
            gmap.plot(x_data, y_data, 'cornflowerblue', edge_width=5)
            plotCount += 1
    except IndexError:
        print('Skip this record')
    count += 1

print('Speeding Counts: ', speedingCounts)

gmap.draw("sensor.html")
print('Result plotted: ', plotCount)
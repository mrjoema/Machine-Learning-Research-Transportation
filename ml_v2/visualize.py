import gmplot
import sqlite3
from scipy.io import loadmat

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
# Select all speed records
cursor = conn.execute("SELECT speed from TRAFFIC_TEST_RECORD")
for row in cursor:
    # assign car speed
    carSpeed = row[0]
    # assign linkid
    linkid = int(labels[count, 0] or 0)
    cursor2 = conn.execute("SELECT mean from SPEED_LIMIT WHERE linkid=?", (linkid,))
    row = cursor2.fetchall()
    speed_limit = int(row[0][0])
    # Debug useage
    #print(linkid, ': ', speed_limit)
    if float(carSpeed) > (speed_limit + 5):
        value = speedingDict[linkid]
        value += 1
        speedingDict[linkid] = value
        speedingCounts+=1
    count+=1

print('Speeding Counts: ', speedingCounts)

# Print the dictionary with the id as a key and the value as a frequency
for key, value in speedingDict.items():
    print(key, ': ', value)


gmap = gmplot.GoogleMapPlotter(40.7538404,-74.007241, 2)

# Plot on the map
for key, value in speedingDict.items():
    cursor3 = conn.execute("SELECT linkPoints from SENSOR_INFO WHERE linkid=?", (key,))
    row = cursor3.fetchall()
    coord_str = row[0][0]
    coord_list = coord_str.split()
    x_data = []
    y_data = []
    print(key, '----')
    for coordinate in coord_list:
        list = coordinate.split(',')
        if len(list) == 2:
            try:
                print(list)
                x_data.append(float(list[0]))
                y_data.append(float(list[1]))
            except ValueError:
                print ('Invalid value! Skip this record')
    print('----')
    # plot heatmap
    if len(x_data) == len(y_data):
        plotCount+=1
        gmap.plot(x_data, y_data, 'cornflowerblue', edge_width= 10)

#gmap.scatter(x_data, y_data, c='r', marker=True)

# save it to html
gmap.draw("country_heatmap.html")
print('Result plotted: ', plotCount)
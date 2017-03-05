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

sensorDict = {}

# Connect to SQLite Database
conn = sqlite3.connect('traffic.db')
print ("Opened database successfully");
cursor = conn.execute("SELECT linkid from SENSOR_INFO")

# init the sensor dictionary
for sensor_id in cursor:
    id = sensor_id[0]
    sensorDict[id] = 0

print('Total records: ', len(labels))

# put the data into the dict
for label in labels:
    label = int(label or 0)
    value = sensorDict[label]
    value += 1
    sensorDict[label] = value

topk = 10
plotCount = 0
gmap = gmplot.GoogleMapPlotter(40.7538404,-74.007241, 10)
# Plot on the map
# go through the dict with the descending order
for key, value in sorted(sensorDict.items(), key=lambda kv: kv[1], reverse=True):
    cursor3 = conn.execute("SELECT EncodedPolyLine from SENSOR_INFO WHERE linkid=?", (key,))
    row = cursor3.fetchall()
    coord_str = row[0][0]
    # print(coord_str)
    # plot it
    try:
        coord_list = polyline.decode(coord_str)
        x_data = []
        y_data = []
        for coordinate in coord_list:
            x_data.append(coordinate[0])
            y_data.append(coordinate[1])
        # plot heatmap
        if len(x_data) == len(y_data):
            plotCount += 1
            gmap.heatmap(x_data, y_data)
            # gmap.scatter(x_data, y_data, '#f45f42', size= value + 20 , marker=False)
            topk = topk - 1
            print(key, ': ', value)
    except IndexError:
        print('Skip this record')

    if topk == 0:
        break

conn.close()

# save it to html
gmap.draw("topk-visited-result.html")
print('Result plotted: ', plotCount)


#print(speedingDict)
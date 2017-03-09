import gmplot
import sqlite3
from scipy.io import loadmat
import polyline

topk = 10

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

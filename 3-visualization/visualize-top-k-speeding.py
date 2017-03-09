import gmplot
import sqlite3
from scipy.io import loadmat
import polyline

topk = 10

x = loadmat('test_result.mat')
labels = x['label']

# Connect to SQLite Database
conn = sqlite3.connect('traffic.db')
print ("Opened database successfully");

speedingDict = {}

cursor = conn.execute("SELECT linkid from SENSOR_INFO")
# init the sensor dictionary
for sensor_id in cursor:
    id = sensor_id[0]
    speedingDict[id] = 0

speedingCounts = 0
plotCount = 0
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
    if float(carSpeed) > (speed_limit + 10):
        value = speedingDict[linkid]
        value += 1
        speedingDict[linkid] = value
        speedingCounts+=1
    count+=1

print('Speeding Counts: ', speedingCounts)

# Print the dictionary with the id as a key and the value as a frequency
#for key, value in speedingDict.items():
#    print(key, ': ', value)

gmap = gmplot.GoogleMapPlotter(40.7538404,-74.007241, 10)

# Sort the dictionary
#speedingDict = sorted(speedingDict.items(), key=lambda kv: kv[1], reverse=True)

# Plot on the map
for key, value in sorted(speedingDict.items(), key=lambda kv: kv[1], reverse=True):
    cursor3 = conn.execute("SELECT EncodedPolyLine from SENSOR_INFO WHERE linkid=?", (key,))
    row = cursor3.fetchall()
    coord_str = row[0][0]
    #print(coord_str)
    try:
        coord_list = polyline.decode(coord_str)
        x_data = []
        y_data = []
        for coordinate in coord_list:
            x_data.append(coordinate[0])
            y_data.append(coordinate[1])
        # plot heatmap
        if len(x_data) == len(y_data):
            plotCount+=1
            gmap.heatmap(x_data, y_data)
            #gmap.scatter(x_data, y_data, '#f45f42', size= value + 20 , marker=False)
            topk = topk - 1
            print(key, ': ', value)
    except IndexError:
        print('Skip this record')

    if topk == 0:
        break

conn.close()

# save it to html
gmap.draw("topk-speeding-result.html")
print('Result plotted: ', plotCount)

#print(speedingDict)

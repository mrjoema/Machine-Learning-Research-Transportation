import gmplot
import sqlite3
from scipy.io import loadmat
import polyline

x = loadmat('test_result.mat')
labels = x['label']

# Connect to SQLite Database
conn = sqlite3.connect('traffic.db')
print ("Opened database successfully");
count = 0
plotCount = 0

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

gmap.draw("sensor.html")
print('Result plotted: ', plotCount)
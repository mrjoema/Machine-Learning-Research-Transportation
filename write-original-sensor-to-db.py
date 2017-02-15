import csv
import sqlite3

conn = sqlite3.connect('traffic.db')
conn.execute('''CREATE TABLE IF NOT EXISTS SENSOR_INFO
             (linkid integer, linkPoints TEXT,
             EncodedPolyLine TEXT, EncodedPolyLineLvls TEXT,
             Borough TEXT, linkName TEXT, Owner TEXT)''')

f = open('linkinfo-copy.csv')
csv_f = csv.reader(f)

count = 0
for row in csv_f:
    linkid = row[0]
    coordList = row[1]
    encodedPolyLine = row[2]
    encodedPolyLineLvls = row[3]
    borough = row[5]
    linkName = row[6]
    owner = row[7]
    conn.execute("insert into SENSOR_INFO (linkid, linkPoints, EncodedPolyLine, EncodedPolyLineLvls, Borough, linkName, Owner) VALUES (?,?,?,?,?,?,?)",
                 (linkid, coordList, encodedPolyLine, encodedPolyLineLvls, borough, linkName, owner))
    # Save (commit) the changes
    conn.commit()
    print("row inserted !!")
conn.close()

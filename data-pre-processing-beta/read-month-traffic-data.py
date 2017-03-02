import csv
import random
import sqlite3
import re

# 0 = id
# 1 = speed
# 2 = time
# 3 = status
# 4 = date
# 5 = linkid

conn = sqlite3.connect('traffic.db')
conn.execute('DROP TABLE TRAFFIC_RECORD')
conn.execute('''CREATE TABLE IF NOT EXISTS TRAFFIC_RECORD
             (id INTEGER, speed REAL, date_time TEXT, linkid INTEGER)''')



writeCount = 0

fileList = ['traffic-csv/january2016.csv', 'traffic-csv/february2016.csv', 'traffic-csv/march2016.csv',
            'traffic-csv/april2016.csv', 'traffic-csv/may2016.csv', 'traffic-csv/june2016.csv',
            'traffic-csv/july2016.csv', 'traffic-csv/august2016.csv', 'traffic-csv/september2016.csv',
            'traffic-csv/october2016.csv',
            'traffic-csv/november2016.csv', 'traffic-csv/december2016.csv']

# Read the csv file
for month in fileList:

    # Randomly Select 5000 record in each month
    for count in range(2000):
        f = open(month)
        lines = f.read().splitlines()
        if not lines:
            continue
        line = random.choice(lines)
        row = line.split(',')
        #row = re.sub('[!"@#$]', '', line)

        # debug use
        print(writeCount, ': ',line)

        id = row[0]
        speed = row[1]
        time = row[2]
        date = row[4]
        linkid = row[5]

        # Insert a row of data
        conn.execute("INSERT INTO TRAFFIC_RECORD (id, speed, date_time, linkid) VALUES (?,?,?,?)",
                     (id, speed, date, linkid))
        # Save (commit) the changes
        conn.commit()

        # Record count
        writeCount = writeCount + 1

    print('finish ', month, ' ', writeCount)

conn.close()

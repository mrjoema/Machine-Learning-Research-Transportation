import csv
import sqlite3

# 0 = id
# 1 = speed
# 2 = time
# 3 = status
# 4 = date
# 5 = linkid

conn = sqlite3.connect('traffic.db')
conn.execute('''CREATE TABLE IF NOT EXISTS TRAFFIC_RECORD
             (id INTEGER, speed REAL, date_time TEXT, linkid INTEGER, speeding Boolean)''')

count = 0

fileList = ['traffic-csv/january2016.csv', 'traffic-csv/february2016.csv', 'traffic-csv/march2016.csv',
            'traffic-csv/april2016.csv', 'traffic-csv/may2016.csv', 'traffic-csv/june2016.csv',
            'traffic-csv/july2016.csv', 'traffic-csv/august2016.csv', 'traffic-csv/september2016.csv',
            'traffic-csv/october2016.csv',
            'traffic-csv/november2016.csv', 'traffic-csv/december2016.csv']

# Read the csv file
f = open('traffic-csv/january2016.csv')
csv_f = csv.reader(f)

for month in fileList:
    f = open(month)
    csv_f = csv.reader(f)
    count = 0
    for row in csv_f:
        id = row[0]
        speed = row[1]
        time = row[2]
        date = row[4]
        linkid = row[5]
        # skip the first line
        if count == 0:
          count = count + 1
          continue

        cursor = conn.execute("SELECT mean from SPEED_LIMIT WHERE linkid=?",(linkid,))
        row = cursor.fetchall()
        speed_limit = int(row[0][0])
        speeding = False
        if float(speed) > (speed_limit + 5):
          speeding = True

        # Insert a row of data
        conn.execute("INSERT INTO TRAFFIC_RECORD (id, speed, date_time, linkid, speeding) VALUES (?,?,?,?,?)",
                     (id, speed, date, linkid, speeding))
        # Save (commit) the changes
        conn.commit()
        print('finish ', month, ' ', count)
        # put 2000 records for each file
        if count == 5000:
          break
        count += 1
conn.close()

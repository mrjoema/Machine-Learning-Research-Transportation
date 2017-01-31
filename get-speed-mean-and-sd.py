import csv
import sqlite3
import json
import requests
import statistics

APP_ID = 'rd4eEBg2OOFWcpzvnxwq'
APP_CODE = 'LVnnCLb3RB6K8guq-Y4zvg'
REST_URL = "https://route.cit.api.here.com/routing/7.2/getlinkinfo.json"

params = dict(
    waypoint = '0,0',
    app_id = APP_ID,
    app_code =APP_CODE,
)


def get_speed_limit(coordList):
    sum = 0
    count = 0
    for coordinate in coordList:
        params['waypoint'] = coordinate
        resp = requests.get(url=REST_URL, params=params)
        data = json.loads(resp.text)
        response = data.get('response', 0)
        if response == 0:
            continue
        speed = data['response']['link'][0].get('speedLimit', 0)
        if speed == 0:
            continue
        sum += speed
        count += 1
    return (sum * 2.23694) / count

def get_speed_list(coordList):
    speed_list = []
    for coordinate in coordList:
        params['waypoint'] = coordinate
        resp = requests.get(url=REST_URL, params=params)
        data = json.loads(resp.text)
        response = data.get('response', 0)
        if response == 0:
            continue
        speed = data['response']['link'][0].get('speedLimit', 0)
        if speed == 0:
            continue
        speed_list.append(speed * 2.23694)
    return speed_list

def write_to_db(c, mean, sd, size):
    # Create table

    # Insert a row of data
    c.execute("insert into SPEED_LIMIT (mean, sd, size) VALUES (?,?,?)",(mean, sd, size))

    # Save (commit) the changes
    conn.commit()


f = open('linkinfo-copy.csv')
csv_f = csv.reader(f)

LINK_ID = 'linkId'  # name of the table to be created
BOROUGH = 'Borough' # name of the column
LINK_NAME = 'linkName'  # column data type
OWNER = "Owner"
ENCODEDPOLYLINE = "EncodedPolyLine"
ENCODEDPOLYLINE_LEVELS = "EncodedPolyLineLvls"
SPEEDLIMIT = "Speed Limit"

list = []
count = 0
for row in csv_f:
  coordList = row[1].split(' ')
  list.append(get_speed_list(coordList))
  print('finish ', count)
  count += 1

print("Ready to read data to db")

conn = sqlite3.connect('mean_sd.db')
conn.execute('''CREATE TABLE IF NOT EXISTS SPEED_LIMIT
             (ID INTEGER PRIMARY KEY AUTOINCREMENT, mean real, sd real, size integer)''')
for traffics in list:
     sd = statistics.stdev(traffics)
     mean = statistics.median(traffics)
     write_to_db(conn, mean, sd, len(traffics))
     print("row inserted !!")

conn.close()

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

def write_to_db(c, id, mean, sd, size):
    # Insert a row of data
    c.execute("insert into SPEED_LIMIT (linkid, mean, sd, size) VALUES (?,?,?,?)",(id,mean, sd, size))
    # Save (commit) the changes
    c.commit()


LINK_ID = 'linkId'  # name of the table to be created
BOROUGH = 'Borough' # name of the column
LINK_NAME = 'linkName'  # column data type
OWNER = "Owner"
ENCODEDPOLYLINE = "EncodedPolyLine"
ENCODEDPOLYLINE_LEVELS = "EncodedPolyLineLvls"
SPEEDLIMIT = "Speed Limit"

# Read the csv file
f = open('linkinfo-copy.csv')
csv_f = csv.reader(f)
idlist = []
list = []
count = 0
for row in csv_f:
  linkid = row[0]
  coordList = row[1].split(' ')
  # function get_speed_list() returns the list with speed limit of each sensor
  list.append(get_speed_list(coordList))
  idlist.append(linkid)
  print('finish ', count)
  count += 1

print("Ready to read data to db")

conn = sqlite3.connect('traffic.db')
conn.execute('''CREATE TABLE IF NOT EXISTS SPEED_LIMIT
             (linkid integer, mean real, sd real, size integer)''')
count = 0
for id, traffics in zip(idlist, list):
     # use the lib to get the standard deviation
     sd = statistics.stdev(traffics)
     # use the lib to get the average speed limit
     mean = statistics.median(traffics)
     # get the id
     linkid = idlist[count]
     # function to write data to the database
     write_to_db(conn, id, mean, sd, len(traffics))
     print("row inserted !!")
conn.close()

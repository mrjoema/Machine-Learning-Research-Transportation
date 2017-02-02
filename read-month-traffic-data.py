import csv
import sqlite3

#0 = id
#1 = speed
#2 = time
#3 = status
#4 = date
#5 = linkid

# Read the csv file
f = open('linkinfo-copy.csv')
csv_f = csv.reader(f)
idlist = []
list = []
count = 0
for row in csv_f:
  id = row[0]
  coordList = row[1].split(' ')
  # function get_speed_list() returns the list with speed limit of each sensor
  list.append(get_speed_list(coordList))
  idlist.append(linkid)
  print('finish ', count)
  count += 1
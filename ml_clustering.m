dbfile = fullfile('traffic.db');

conn = sqlite(dbfile);
curs = fetch(conn,'select * from TRAFFIC_RECORD where speeding = 1');
cd /opt/data
rm australia.osm.bz2
wget http://download.geofabrik.de/openstreetmap/australia-oceania/australia.osm.bz2

rm -R pgsqldump
mkdir pgsqldump

cd /opt/osm/osmosis/package/bin
bzcat /opt/data/australia.osm.bz2 | ./osmosis --read-xml file=- --bounding-box top=-37.425 left=144.288 bottom=-38.442 right=145.873 --tf accept-ways 'highway=*' --used-node --write-pgsql-dump directory=/opt/data/pgsqldump

cd /opt/data
rm road_all.*
rm road_vehicles.*
sudo -u postgres psql -d bze -f /opt/osm/queries-road.sql
sudo -u postgres pgsql2shp -f road_all.shp bze osm_roads
sudo -u postgres pgsql2shp -f road_vehicles.shp bze "select * from osm_roads where typ in ('motorway','motorway_link','primary','primary_link','residential','road','secondary','secondary_link','tertiary','tertiary_link','trunk','trunk_link')"
tar -zcvpf road_all.tar.gz ./road_all.*
tar -zcvpf road_vehicles.tar.gz ./road_vehicles.*
rm /usr/share/apache2/bip/data/PGDUMP/road_all.tar.gz
rm /usr/share/apache2/bip/data/PGDUMP/road_vehicles.tar.gz
mv road_all.tar.gz /usr/share/apache2/bip/data/PGDUMP/
mv road_vehicles.tar.gz /usr/share/apache2/bip/data/PGDUMP/

cd /opt/data
rm australia.osm.bz2
wget http://download.geofabrik.de/openstreetmap/australia-oceania/australia.osm.bz2

rm -R pgsqldump
mkdir pgsqldump
cd /opt/osm/osmosis/package/bin
bzcat /opt/data/australia.osm.bz2 | ./osmosis --read-xml file=- --tf accept-nodes 'power=*' --tf reject-ways --tf reject-relations --write-pgsql-dump directory=/opt/data/pgsqldump
cd /opt/data
sudo -u postgres psql -d power -f /opt/osm/queries-power-nodes.sql

rm -R pgsqldump
mkdir pgsqldump
cd /opt/osm/osmosis/package/bin
bzcat /opt/data/australia.osm.bz2 | ./osmosis --read-xml file=- --tf accept-ways 'power=*' --used-node --tf reject-relations --write-pgsql-dump directory=/opt/data/pgsqldump
cd /opt/data
sudo -u postgres psql -d power -f /opt/osm/queries-power-ways.sql


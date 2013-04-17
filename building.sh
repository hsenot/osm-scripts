cd /opt/data
rm australia.osm.bz2
wget http://download.geofabrik.de/openstreetmap/australia-oceania/australia.osm.bz2

rm -R pgsqldump
mkdir pgsqldump

cd /opt/osm/osmosis/bin/
bzcat /opt/data/australia.osm.bz2 | ./osmosis --read-xml file=- --tf accept-ways 'building=*' --used-node --write-pgsql-dump directory=/opt/data/pgsqldump

cd /opt/data
rm buildings.sql
sudo -u postgres psql -d bip -f /opt/osm/queries.sql
zip buildings.sql.zip buildings.sql
rm /usr/share/apache2/bip/data/PGDUMP/buildings.sql.zip
mv buildings.sql.zip /usr/share/apache2/bip/data/PGDUMP/

cd /usr/share/apache2/oauth-twitter
php tweet.php


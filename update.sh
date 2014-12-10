# Download file
wget http://download.geofabrik.de/australia-oceania/australia-latest.osm.pbf -O australia-latest.osm.pbf

# Read and import
imposm --read --write --overwrite-cache -d osm -m mymapping.py australia-latest.osm.pbf

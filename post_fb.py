import facebook
import time
import sys

access_token = sys.argv[1]
id_page      = sys.argv[2]
photo        = sys.argv[3]
location     = sys.argv[4]

album_exists = False
id_album = None


if __name__ == '__main__':
	graph = facebook.GraphAPI(access_token = access_token, version='2.8')

	# test if album exists
	res = graph.get_all_connections(id = id_page, connection_name = 'albums')

	for album in res:
		if album['name'] == location:
			album_exists = True
			id_album = album['id']
			break;

	# add new album
	if not album_exists :
		new_album = graph.put_object(
			parent_object = id_page,
			connection_name = 'albums',
			name = location,
			location = location
		)
		id_album = new_album['id']

	# add photo
	graph.put_photo(
		image    = open(photo, 'rb'),
		album_path = id_album + '/photos',
		caption  = "ISS is above {0}".format(location),
		backdated_time = int(time.time()),
		backdated_time_granularity = 'min'
	)





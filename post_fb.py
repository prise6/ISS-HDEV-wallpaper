import facebook
import time
import sys


print str(sys.argv)

access_token = sys.argv[1]
id_page      = sys.argv[2]
photo        = sys.argv[3]
location     = sys.argv[4]


# location = 'Brazil'
# photo = './Collections/20170319-123501.jpg'

album_exists = False
id_album = None


if __name__ == '__main__':
	# main()

	print("ok")

	graph = facebook.GraphAPI(access_token = access_token, version='2.8')
	print(graph)

	# tester sur l'album existe
	res = graph.get_all_connections(id = id_page, connection_name = 'albums')

	for album in res:
		print(album)
		if album['name'] == location:
			album_exists = True
			id_album = album['id']
			break;

	# ajout du nouvel album
	if not album_exists :
		new_album = graph.put_object(
			parent_object = id_page,
			connection_name = 'albums',
			name = location,
			location = location
		)
		print(new_album)
		id_album = new_album['id']

	print(id_album)
	

	# ajout de la photo
	graph.put_photo(
		image    = open(photo, 'rb'),
		album_path = id_album + '/photos',
		caption  = "ISS is above {0}".format(location),
		backdated_time = int(time.time()),
		backdated_time_granularity = 'min'
	)





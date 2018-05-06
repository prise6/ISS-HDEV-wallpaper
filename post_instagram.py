from InstagramAPI import InstagramAPI
import time
import sys
import yaml

# get arguments
conf_file = sys.argv[1]
photo     = sys.argv[2]
location  = sys.argv[3]


# yaml file
with open(conf_file, 'r') as stream:
	try:
		conf = yaml.load(stream)
	except yaml.YAMLError as exc:
		print(exc)
		sys.exit(1)


InstagramAPI = InstagramAPI(conf['instagram']['login'], conf['instagram']['password'])
InstagramAPI.login()  # login


InstagramAPI.uploadPhoto(
	photo, 
	caption="#ISS is above #{0}".format(location.replace(" ", ""))
)
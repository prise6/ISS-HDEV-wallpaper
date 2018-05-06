import twitter
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


if __name__ == '__main__':

	# connect to app
	api = twitter.Api(
		consumer_key        = conf['twitter']['consumer_key'],
		consumer_secret     = conf['twitter']['consumer_secret'],
		access_token_key    = conf['twitter']['access_token_key'],
		access_token_secret = conf['twitter']['access_token_secret']
	)

	# post tweet + media
	api.PostMedia(
		status = "#ISS is above #{0}".format(location.replace(" ", "")),
		media  = photo
	)

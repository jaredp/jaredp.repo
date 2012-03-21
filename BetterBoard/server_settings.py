from settings import *

DATABASES['default']['NAME'] = 'BetterBoard'
DATABASES['default']['USER'] = 'devuser'
DATABASES['default']['PASSWORD'] = 'water'

STATIC_ROOT = '/var/www/html/djangolandstatic'
STATIC_URL = '/djangolandstatic/'
ADMIN_MEDIA_PREFIX = '/djangolandstatic/admin/'

SUB_SITE = 'betterboard'
ROOT_URLCONF = 'subsite_url_conf'

LOGIN_URL = '/betterboard/accounts/login/'
LOGIN_REDIRECT_URL = '/betterboard/'

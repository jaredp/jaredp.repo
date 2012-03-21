from django.conf.urls.defaults import *
from django.conf import settings

urlpatterns = patterns('',
    (r'^%s/' % settings.SUB_SITE, include('urls')),
)

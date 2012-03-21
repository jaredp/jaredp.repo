from django.conf.urls.defaults import *
from BBCore.models import *
from BBCore.views import *

from django.views.generic import TemplateView

urlpatterns = patterns('BBCore.views',
    url(r'^$', home),
    url(r'^rss/', AssignmentFeed()),
    
    url(r'class/(?P<course_id>\d+)/rss/$', AssignmentFeed()),
    url(r'class/(?P<course_id>\d+)/$', assignment_book),
    
    url(r'post/(?P<post_id>\d+)/$', post_detail),
    
    url(r'grades/$', grade_book),
    url(r'newpost/$', TemplateView.as_view(template_name='BBCore/new_post.html')),
    
    url(r'(?P<redirect>.*)comment/(?P<post_id>\d+)/$', comment),
    url(r'(.*)new_post/$', new_post),
)

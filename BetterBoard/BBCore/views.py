from django.http import HttpResponse, HttpResponseForbidden, HttpResponseRedirect
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response, get_object_or_404
from django.template import RequestContext
from BBCore.models import *

import datetime

@login_required
def assignment_book(request, course_id=None):
    q = Assignment.objects.all()

    if course_id:
        if not Section.objects.filter(course=course_id, students=request.user).exists():
            return HttpResponseForbidden("You are not in this class.  Get out.")
        q = q.filter(section__course=course_id)
    else:
        q = q.filter(section__students=request.user)
        
    q = q.select_related()
        
    # todo: filter to upcoming only: below works, enable prev posts
    
    course_filter = None
    if course_id:
        course_filter = Section.objects.get(pk=course_id)
    
    return render_to_response('BBCore/assignment_book.html', {
        'homeworks': q.order_by('date'),                            #.filter(date__gt=datetime.datetime.now()),
        'docs': q.filter(date=None),
        'course_filter':  course_filter,
    }, context_instance=RequestContext(request))
    
home = assignment_book
    
def post_detail(request, post_id):
    try:
        assignment = Assignment.objects.select_related().filter(post=post_id, section__students=request.user)[0]
    except IndexError:
        return HttpResponseForbidden("You are not in this class.  Get out.")
    
    return render_to_response('BBCore/post_detail.html', {
        'duedate': assignment.date,
        'post': assignment.post,
        'section': assignment.section,
        'grades': Grade.objects.filter(student=request.user, assignment=assignment),
    }, context_instance=RequestContext(request))

def comment(request, post_id, redirect):
    Comment(post=Post.objects.get(pk=post_id), text=request.POST['comment'], by=request.user).save()
    return HttpResponseRedirect('/' + redirect)
    
def grade_book(request):
    return render_to_response('BBCore/grade_book.html', {
        'grades': Grade.objects.filter(student=request.user).select_related(),
    }, context_instance=RequestContext(request))
    
def new_post(request, redirect):
    return HttpResponse(unicode(request.POST))
    #return HttpResponseRedirect('/' + redirect)


from django.contrib.syndication.views import Feed

class AssignmentFeed(Feed):
    title = "BetterBoard Assignments"
    link = "/foo"
#    description = "Updates on changes and additions to chicagocrime.org."

    def get_object(self, request, course_id=None):
        #check to see if the user is actually logged in or not
        if course_id:
            return get_object_or_404(Course, pk=course_id)
        else:
            return None
        
    def items(self, course):
        q = Assignment.objects.order_by('date')[:30]
        
        if course:
            q = q.filter(section__course=course)
        
        q.select_related()
        return q
        
    def item_title(self, item):
        text = item.post.text
        return text[0:text.find('\n')]

    def item_description(self, item):
        return item.post.html

    def item_link(self, item):
        #return '/post/%i/' % item.post.id
        return '/'
    
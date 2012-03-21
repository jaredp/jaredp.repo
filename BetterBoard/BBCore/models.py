from django.db import models
from django.contrib.auth.models import User

class Course(models.Model):
    name = models.CharField(max_length=20)
    def __unicode__(self):
        return self.name

class Section(models.Model):
    course = models.ForeignKey(Course)
    name = models.CharField(max_length=10)  # change later
    students = models.ManyToManyField(User)
    teacher = models.ManyToManyField(User, related_name='teaching')
        
    def __unicode__(self):
        return '%s of %s' % (self.name, self.course)

from text_to_embedded import html_from_text

class Post(models.Model):
    text = models.TextField()
    html = models.TextField()
    
    by = models.ForeignKey(User)
    
    def save(self, *args, **kwargs):
        self.html = html_from_text(self.text)
        super(Post, self).save(*args, **kwargs)
    
    def __unicode__(self):
        return self.text
                
def clearPostsHTML():
    for i in Post.objects.all():
        i.save()
    
class Assignment(models.Model):
    post = models.ForeignKey(Post)
    section = models.ForeignKey(Section)
    date = models.DateTimeField( null=True, blank=True )
    grades = models.ManyToManyField(User, through='Grade')

class Grade(models.Model):
    assignment = models.ForeignKey(Assignment)
    student = models.ForeignKey(User)
    points = models.PositiveIntegerField()
    
    def __unicode__(self):
        return str(self.points)

class Comment(Post):
    post = models.ForeignKey(Post, related_name='comments')
    timestamp = models.DateTimeField(auto_now_add=True)

class Upload(models.Model):
    post = models.ForeignKey(Post)
    file = models.FileField(upload_to='PostedFiles')

from os import path
def filename_from_file(file):
    return path.split(file.name)[1]
    
from django.core.files import File
File.filename = filename_from_file



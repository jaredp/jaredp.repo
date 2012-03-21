from django.contrib import admin
from models import *

admin.site.register(Section)
class SectionInline(admin.TabularInline):
    model = Section

class CourseAdmin(admin.ModelAdmin):
    inlines = (SectionInline,)
admin.site.register(Course, CourseAdmin)

class GradesInline(admin.TabularInline):
    model = Grade
admin.site.register(Grade)

class AssignmentAdmin(admin.ModelAdmin):
    list_display = ('post', 'section', 'date')
    inlines = (GradesInline,)
admin.site.register(Assignment, AssignmentAdmin)

class AssignmentInline(admin.TabularInline):
    model = Assignment
    inlines = (GradesInline,)

class CommentsInline(admin.TabularInline):
    model = Comment
    fk_name = 'post'
    exclude = ('html',)
    
class UploadsInline(admin.TabularInline):
    model = Upload

class PostAdmin(admin.ModelAdmin):
    inlines = (UploadsInline, AssignmentInline, CommentsInline,)
    exclude = ('html',)
admin.site.register(Post, PostAdmin)

admin.site.register(Comment)

'''
class ClassPeriodAdmin(admin.ModelAdmin):
    list_display = ('label', 'start', 'end',)
    list_editable = list_display[1:]
    ordering = ('start', 'label',)

admin.site.register(ClassPeriod, ClassPeriodAdmin)
admin.site.register(DaySchedule)
admin.site.register(Schoolday)
'''

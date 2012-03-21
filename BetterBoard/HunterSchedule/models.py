from django.db import models



class ClassPeriod(models.Model):
    start = models.TimeField()
    end = models.TimeField()
    label = models.CharField(max_length=20)
    def __unicode__(self):
        return self.label

class DaySchedule(models.Model):
    periods = models.ManyToManyField(ClassPeriod)
    label = models.CharField(max_length=20)
    def __unicode__(self):
        return self.label

class Schoolday(models.Model):
    date = models.DateField()
    schedule = models.ForeignKey(DaySchedule)




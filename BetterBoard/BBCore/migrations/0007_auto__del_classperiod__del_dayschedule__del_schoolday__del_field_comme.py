# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):
    
    def forwards(self, orm):
        
        # Deleting model 'ClassPeriod'
        db.delete_table('BBCore_classperiod')

        # Deleting model 'DaySchedule'
        db.delete_table('BBCore_dayschedule')

        # Removing M2M table for field periods on 'DaySchedule'
        db.delete_table('BBCore_dayschedule_periods')

        # Deleting model 'Schoolday'
        db.delete_table('BBCore_schoolday')

        # Removing M2M table for field classes on 'Section'
        db.delete_table('BBCore_section_classes')

        # Deleting field 'Comment.by'
        db.delete_column('BBCore_comment', 'by_id')

        # Adding field 'Post.by'
        db.add_column('BBCore_post', 'by', self.gf('django.db.models.fields.related.ForeignKey')(default=None, to=orm['auth.User']), keep_default=False)
    
    
    def backwards(self, orm):
        
        # Adding model 'ClassPeriod'
        db.create_table('BBCore_classperiod', (
            ('start', self.gf('django.db.models.fields.TimeField')()),
            ('end', self.gf('django.db.models.fields.TimeField')()),
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('label', self.gf('django.db.models.fields.CharField')(max_length=20)),
        ))
        db.send_create_signal('BBCore', ['ClassPeriod'])

        # Adding model 'DaySchedule'
        db.create_table('BBCore_dayschedule', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('label', self.gf('django.db.models.fields.CharField')(max_length=20)),
        ))
        db.send_create_signal('BBCore', ['DaySchedule'])

        # Adding M2M table for field periods on 'DaySchedule'
        db.create_table('BBCore_dayschedule_periods', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('dayschedule', models.ForeignKey(orm['BBCore.dayschedule'], null=False)),
            ('classperiod', models.ForeignKey(orm['BBCore.classperiod'], null=False))
        ))
        db.create_unique('BBCore_dayschedule_periods', ['dayschedule_id', 'classperiod_id'])

        # Adding model 'Schoolday'
        db.create_table('BBCore_schoolday', (
            ('date', self.gf('django.db.models.fields.DateField')()),
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('schedule', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['BBCore.DaySchedule'])),
        ))
        db.send_create_signal('BBCore', ['Schoolday'])

        # Adding M2M table for field classes on 'Section'
        db.create_table('BBCore_section_classes', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('section', models.ForeignKey(orm['BBCore.section'], null=False)),
            ('classperiod', models.ForeignKey(orm['BBCore.classperiod'], null=False))
        ))
        db.create_unique('BBCore_section_classes', ['section_id', 'classperiod_id'])

        # Adding field 'Comment.by'
        db.add_column('BBCore_comment', 'by', self.gf('django.db.models.fields.related.ForeignKey')(default=1, to=orm['auth.User']), keep_default=False)

        # Deleting field 'Post.by'
        db.delete_column('BBCore_post', 'by_id')
    
    
    models = {
        'BBCore.assignment': {
            'Meta': {'object_name': 'Assignment'},
            'date': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'grades': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.User']", 'through': "orm['BBCore.Grade']", 'symmetrical': 'False'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'post': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['BBCore.Post']"}),
            'section': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['BBCore.Section']"})
        },
        'BBCore.comment': {
            'Meta': {'object_name': 'Comment', '_ormbases': ['BBCore.Post']},
            'post': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'comments'", 'to': "orm['BBCore.Post']"}),
            'post_ptr': ('django.db.models.fields.related.OneToOneField', [], {'to': "orm['BBCore.Post']", 'unique': 'True', 'primary_key': 'True'}),
            'timestamp': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'BBCore.course': {
            'Meta': {'object_name': 'Course'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '20'})
        },
        'BBCore.grade': {
            'Meta': {'object_name': 'Grade'},
            'assignment': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['BBCore.Assignment']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'points': ('django.db.models.fields.PositiveIntegerField', [], {}),
            'student': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['auth.User']"})
        },
        'BBCore.post': {
            'Meta': {'object_name': 'Post'},
            'by': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['auth.User']"}),
            'html': ('django.db.models.fields.TextField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'text': ('django.db.models.fields.TextField', [], {})
        },
        'BBCore.section': {
            'Meta': {'object_name': 'Section'},
            'course': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['BBCore.Course']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '10'}),
            'students': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.User']", 'symmetrical': 'False'})
        },
        'BBCore.upload': {
            'Meta': {'object_name': 'Upload'},
            'file': ('django.db.models.fields.files.FileField', [], {'max_length': '100'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'post': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['BBCore.Post']"})
        },
        'auth.group': {
            'Meta': {'object_name': 'Group'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '80'}),
            'permissions': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.Permission']", 'symmetrical': 'False', 'blank': 'True'})
        },
        'auth.permission': {
            'Meta': {'unique_together': "(('content_type', 'codename'),)", 'object_name': 'Permission'},
            'codename': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'content_type': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['contenttypes.ContentType']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        },
        'auth.user': {
            'Meta': {'object_name': 'User'},
            'date_joined': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '75', 'blank': 'True'}),
            'first_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'groups': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.Group']", 'symmetrical': 'False', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_active': ('django.db.models.fields.BooleanField', [], {'default': 'True', 'blank': 'True'}),
            'is_staff': ('django.db.models.fields.BooleanField', [], {'default': 'False', 'blank': 'True'}),
            'is_superuser': ('django.db.models.fields.BooleanField', [], {'default': 'False', 'blank': 'True'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'last_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'password': ('django.db.models.fields.CharField', [], {'max_length': '128'}),
            'user_permissions': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.Permission']", 'symmetrical': 'False', 'blank': 'True'}),
            'username': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '30'})
        },
        'contenttypes.contenttype': {
            'Meta': {'unique_together': "(('app_label', 'model'),)", 'object_name': 'ContentType', 'db_table': "'django_content_type'"},
            'app_label': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'model': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        }
    }
    
    complete_apps = ['BBCore']

from django.db import models
from django.forms import ModelForm

# Create your models here.

class Micropost(models.Model):
	content = models.TextField()

class MicropostForm(ModelForm):
	class Meta:
		model = Micropost
		fields = ['content']

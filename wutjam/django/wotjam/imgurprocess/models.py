from django.db import models

class Upload(models.Model):
    upload_file = models.CharField(max_length=300)
# Create your models here.

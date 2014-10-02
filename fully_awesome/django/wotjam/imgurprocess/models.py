from django.forms import ModelForm
from imgurprocess.models import ModelForm

class Upload(models.Model):

    upload_file = models.CharField(max_length=300)
# Create your models here.

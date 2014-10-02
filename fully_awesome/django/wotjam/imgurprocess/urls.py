from django.conf.urls import patterns, url

from imgurprocess import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='index'),
)
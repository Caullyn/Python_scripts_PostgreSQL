from django.conf.urls import patterns, include, url
from django.contrib import admin
from imgurprocess import views

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'wotjam.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^imgurprocess/', include('imgurprocess.urls')),
    url(r'^admin/', include(admin.site.urls)),
)

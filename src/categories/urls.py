
from .controllers import getall
from django.urls import path
urlpatterns = [
    path('', getall, name='getall'),
   
]
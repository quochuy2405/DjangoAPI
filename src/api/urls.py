from django.urls import path
from products import controllers as pr
urlpatterns = [
    path('get/', pr.getAllProducts),
]

from django.urls import path
from . import views
from products import views as pr
urlpatterns = [
    path('get_all/', views.getData),
    path('get/', pr.getAllProducts),
]

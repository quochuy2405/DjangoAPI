from django.urls import path
from orders import controllers as od
from .views import getData 

urlpatterns = [
    path('order/checkout', od.place_order, name='place_order'),
    path('test', getData, name='test'),
]

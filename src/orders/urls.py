
from .controllers import createOrders ,checkQuantity
from django.urls import path
urlpatterns = [
    path('checkout', createOrders, name='createOrders'),
    path('check_quantity', checkQuantity, name='checkQuantity'),
]
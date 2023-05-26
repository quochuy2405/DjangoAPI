
from .controllers import checkoutOrder ,checkQuantity
from django.urls import path
urlpatterns = [
    path('checkout', checkoutOrder, name='checkoutOrder'),
    path('check_quantity', checkQuantity, name='checkQuantity'),
]

from .controllers import getAllProducts ,getProductByCategoryId
from django.urls import path
urlpatterns = [
    path('', getAllProducts, name='getAllProducts'),
    path('<int:id>', getProductByCategoryId, name='getProductByCategoryId'),
]

from .controllers import getAllProducts ,getProductByCategoryId,getProductById
from django.urls import path
urlpatterns = [
    path('', getAllProducts, name='getAllProducts'),
    path('cat/<int:id>', getProductByCategoryId, name='getProductByCategoryId'),
    path('prod/<int:id>', getProductById, name='getProductById'),
]
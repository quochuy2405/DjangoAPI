from django.db import models
from categories import models as cat
class Product(models.Model):
    name = models.CharField(max_length=255)
    category = models.ForeignKey(cat.Category, on_delete=models.CASCADE)
    description = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.IntegerField()

    def __str__(self):
        return self.name

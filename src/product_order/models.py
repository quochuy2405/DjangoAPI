from django.db import models
from products import models as prod
from orders import models as o
class ProductOrder(models.Model):
    product = models.ForeignKey(prod.Product, on_delete=models.CASCADE)
    order = models.ForeignKey(o.Order, on_delete=models.CASCADE)
    quantity = models.IntegerField()

    def __str__(self):
        return f"{self.product} - {self.order}"

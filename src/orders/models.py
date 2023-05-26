from django.db import models
from users import models as u
class Order(models.Model):
    address_number = models.CharField(max_length=255)
    ward = models.CharField(max_length=255)
    district = models.CharField(max_length=255)
    province = models.CharField(max_length=255)
    checkout_id = models.CharField(max_length=255)
    email = models.EmailField()
    name = models.CharField(max_length=255)
    user = models.ForeignKey(u.User, on_delete=models.CASCADE)

    def __str__(self):
        return self.name

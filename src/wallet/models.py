from django.db import models
from users import models as u
class Wallet(models.Model):
    user = models.ForeignKey(u.User, on_delete=models.CASCADE)
    balance = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Wallet for {self.user}"

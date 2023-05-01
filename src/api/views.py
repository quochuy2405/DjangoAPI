from rest_framework.response import Response
from rest_framework.decorators import api_view
from base.models import Item
from .serializers import ItemSerializers

@api_view(['GET'])

def getData(request):
    item= Item.objects.all()
    serialize = ItemSerializers(item,many=True)
    return Response(serialize.data)
from django.shortcuts import render
from django.http import JsonResponse
from connection import connect as conn 
# Create your views here.
def getAllProducts(res):
    con = conn.connect()
    con.close()
    response_data = {
        "conn":"ok"
        }
    return JsonResponse(response_data, status=201)
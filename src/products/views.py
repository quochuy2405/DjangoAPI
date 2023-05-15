from django.shortcuts import render
from django.http import JsonResponse
from django.db import connection  
# Create your views here.
def getAllProducts(res):
    
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM IS_PRODUCT')
    rows = cursor.fetchall()
     # close the cursor and connection
    cursor.close()
    connection.close()
    print(rows)
    # create a response dictionary containing the rows
    response_data = {
        'rows': rows,
        'message': 'Retrieved all rows from IS_PRODUCT table successfully.'
    }
    return JsonResponse(response_data, status=200)
from django.shortcuts import render
from django.http import JsonResponse
from connection import db_connect  
# Create your views here.
def getAllProducts(res):
    conn = db_connect.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM IS_PRODUCT')
    rows = cursor.fetchall()
     # close the cursor and connection
    cursor.close()
    conn.close()
    print(rows)
    # create a response dictionary containing the rows
    response_data = {
        'rows': rows,
        'message': 'Retrieved all rows from IS_PRODUCT table successfully.'
    }
    return JsonResponse(response_data, status=200)
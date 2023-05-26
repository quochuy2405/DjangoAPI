from django.shortcuts import render
from django.http import JsonResponse
from django.db import connection
# Create your views here.
def getAllProducts(res):
    
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM PRODUCTS')
    rows = cursor.fetchall()
     # close the cursor and connection
     # get the column names
    columns = [desc[0].lower()  for desc in cursor.description]

    # convert rows into a list of dictionaries
    data = [dict(zip(columns, row)) for row in rows]
    cursor.close()
    connection.close()
   
    # create a response dictionary containing the rows
    response_data = {
        'rows': data,
        'message': 'Retrieved all rows from PRODUCTS table successfully.'
    }
    return JsonResponse(response_data, status=200)

def getProductByCategoryId(request, id):
    try:
        
        cursor = connection.cursor()
        cursor.execute(f'SELECT * FROM PRODUCTS WHERE category_id = {id} ')
        rows = cursor.fetchall()
        # close the cursor and connection
        # get the column names
        columns = [desc[0].lower()  for desc in cursor.description]

        # convert rows into a list of dictionaries
        data = [dict(zip(columns, row)) for row in rows]
        cursor.close()
        connection.close()
   
        # create a response dictionary containing the rows
        response_data = {
            'rows': data,
            'message': 'Retrieved all rows from Catergories table successfully.',
            'status': 'success'
        }
        return JsonResponse(response_data, status=200)
    except:
        return JsonResponse(status=400)
    
def getProductById(request, id):
    try:
        
        cursor = connection.cursor()
        cursor.execute(f'SELECT * FROM PRODUCTS WHERE id = {id} ')
        rows = cursor.fetchall()
        # close the cursor and connection
        # get the column names
        columns = [desc[0].lower()  for desc in cursor.description]

        # convert rows into a list of dictionaries
        data = [dict(zip(columns, row)) for row in rows]
        cursor.close()
        connection.close()
       
        # create a response dictionary containing the rows
        response_data = {
            'rows': data[0],
            'message': 'Retrieved all rows from Catergories table successfully.',
            'status': 'success'
        }
        return JsonResponse(response_data, status=200)
    except:
        return JsonResponse(status=400)
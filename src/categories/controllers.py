
from django.shortcuts import render
from django.http import JsonResponse
from django.db import connection
# Create your views here.
def getall(res):
    
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM Categories')
    rows = cursor.fetchall()
    # close the cursor and connection
     # get the column names
    columns = [desc[0] for desc in cursor.description]

    # convert rows into a list of dictionaries
    data = [dict(zip(columns, row)) for row in rows]
    cursor.close()
    connection.close()
    print(rows)
    # create a response dictionary containing the rows
    response_data = {
        'rows': data,
        'message': 'Retrieved all rows from Catergories table successfully.',
        'status': 'success'
    }
    return JsonResponse(response_data, status=200)

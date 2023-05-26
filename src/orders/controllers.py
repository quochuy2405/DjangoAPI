import json
from django.db import transaction, IntegrityError,connection
from rest_framework.response import Response
from rest_framework.decorators import api_view


@api_view(['POST'])
def place_order(request):
    try:
        data = request.data
        address_number = data['address_number']
        ward = data['ward']
        district = data['district']
        province = data['province']
        checkout_id = data['checkout_id']
        email = data['email']
        name = data['name']
        user_id = data['user_id']
        total = data['total']
        products = data['products']

        with transaction.atomic():
            # Lock the product to avoid conflicts
            cursor = connection.cursor()
            for product in products:
                cursor.execute(f"SELECT * FROM PRODUCTS WHERE ID ={product['id']}")
                row = cursor.fetchone()
                columns = [desc[0] for desc in cursor.description]
                data = [dict(zip(columns, row))]
                if data[0]['QUANTITY']< 1:  # Assuming the quantity column is at index 2
                    raise Exception('Sản phẩm đã hết hàng.')
                # Deduct money from wallet using the procedure DeductMoneyFromWallet
    
            cursor.callproc('DeductMoneyFromWallet', [user_id, total])
              # Insert order into the database
            for product in products:
                ord_id = cursor.var(int)
                cursor.execute(f"""
                    INSERT INTO orders (addressNumber, ward, district, province, checkoutId, email, name, user_id)
                    VALUES ('{address_number}', '{ward}', '{district}', '{province}', '{checkout_id}', '{email}', '{name}', {int(user_id)})
                """)
                cursor.execute("SELECT MAX(id) FROM orders")
                row = cursor.fetchone()
                order_id = row[0]
               
                cursor.execute(f"""
                    INSERT INTO product_order (product_id, order_id, quantity)
                    VALUES ({product['id']}, {order_id}, {product['quantity']})
                """)
            
            cursor.close()
        

        message = {"message": "Đặt hàng thành công","status":'success'}
        return Response(message)

    except IntegrityError:
        error_message = {"message": "Đã có lỗi xảy ra trong quá trình xử lý đặt hàng.","status":'failed'}
        transaction.rollback()
        return Response(error_message)

    except Exception as e:
        print(e.args[0])
        error_message = str(e)  # Convert the DatabaseError object to a string
        lines = error_message.split('\n')  # Split the error message by newline character
        first_line = lines[0].replace('ORA-20001:','')  # Get the first line

        error_message = {"message": f"Lỗi khi đặt hàng: {first_line}", "status": 'failed'}
        transaction.rollback()
        return Response(error_message)



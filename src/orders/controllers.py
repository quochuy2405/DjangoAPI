import json
from django.db import transaction, IntegrityError,connection
from rest_framework.response import Response
from rest_framework.decorators import api_view


@api_view(['POST'])
def createOrders(request):
    try:
        data = request.data
        address_number = data['address_number']
        ward = data['ward']
        district = data['district']
        province = data['province']
        checkout_id = data['checkout_id']
        email = data['email']
        phone = data['phone']
        name = data['name']
        user_id = data['user_id']
        total = data['total']
        payment_methods = data['payment_methods']
        status = data['status']
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
                    raise Exception(f"Sản phẩm {data[0]['name']} đã hết hàng.")
                # Deduct money from wallet using the procedure DeductMoneyFromWallet
    
            cursor.callproc('DeductMoneyFromWallet', [user_id, total])
              # Insert order into the database
            for product in products:
                ord_id = cursor.var(int)
                cursor.execute(f"""
                    INSERT INTO orders (
                    addressnumber,
                    ward,
                    district,
                    province,
                    checkoutid,
                    email,
                    phone,
                    payment_methods,
                    status,
                    name,
                    user_id)
                    VALUES (
                    '{address_number}',
                    '{ward}', 
                    '{district}',
                    '{province}', 
                    '{checkout_id}',
                    '{email}',
                    '{phone}',
                    '{payment_methods}',
                    '{status}',
                    '{name}',
                    {int(user_id)})
                """)
                cursor.execute("SELECT MAX(id) FROM orders")
                row = cursor.fetchone()
                order_id = row[0]
               
                cursor.execute(f"""
                    INSERT INTO product_order (product_id, order_id, quantity)
                    VALUES ({product['id']}, {order_id}, {product['quantityOrder']})
                """)
            
            cursor.close()
        

        message = {"message": "Đặt hàng thành công","status":'success'}
        return Response(message)

    except IntegrityError:
        error_message = {"message": "Đã có lỗi xảy ra trong quá trình xử lý đặt hàng.","status":'failed'}
        transaction.rollback()
        return Response(error_message,status=400)

    except Exception as e:
        print(e.args[0])
        error_message = str(e)  # Convert the DatabaseError object to a string
        lines = error_message.split('\n')  # Split the error message by newline character
        first_line = lines[0].replace('ORA-20001:','')  # Get the first line

        error_message = {"message": f"Lỗi khi đặt hàng: {first_line}", "status": 'failed'}
        transaction.rollback()
        return Response(error_message,status=400)


@api_view(['POST'])
def checkQuantity(request):
    try:
        data = request.data
        products = data['products']
       

        with transaction.atomic():
            # Lock the product to avoid conflicts
            cursor = connection.cursor()
            for product in products:
                cursor.execute(f"SELECT * FROM PRODUCTS WHERE ID ={int(product['id'])}")
                row = cursor.fetchone()
                columns = [desc[0] for desc in cursor.description]
                data = [dict(zip(columns, row))]
                if data[0]['QUANTITY']< 1:  # Assuming the quantity column is at index 2
                    raise Exception(f"Sản phẩm {data[0]['name']} đã hết hàng.")
                cursor.callproc('CHECK_PRODUCT_QUANTITY_PROCEDURE', [product['id'], int(product['quantityOrder'])])

        message = {"message": "Đủ sản phẩm cho hóa đơn này","status":'success'}
        return Response(message)

    except IntegrityError:
        error_message = {"message": "Đã có lỗi xảy ra trong quá trình xử lý đặt hàng.","status":'failed'}
        transaction.rollback()
        return Response(error_message,status=400)

    except Exception as e:
        print(e.args[0])
        error_message = str(e)  # Convert the DatabaseError object to a string
        lines = error_message.split('\n')  # Split the error message by newline character
        first_line = lines[0].replace('ORA-20001:','')  # Get the first line

        error_message = {"message": f"Lỗi khi đặt hàng: {first_line}", "status": 'failed'}
        transaction.rollback()
        return Response(error_message,status=400)



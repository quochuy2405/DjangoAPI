import cx_Oracle
def connect():
    try:
      
        # establish a connection to the database
        connection = cx_Oracle.connect('huy/123456@//localhost:1521/orcl')

        # print a success message
        print('Successfully connected to Oracle database')

        # do some database operations here
        # close the database connection
        return connection
    except cx_Oracle.DatabaseError as e:
        # print an error message if the connection failed
        print('Failed to connect to Oracle database:', e)
        return None
    

  
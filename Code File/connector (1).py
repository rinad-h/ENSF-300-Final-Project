import mysql.connector
from mysql.connector import Error
from tabulate import tabulate

'''
log in --
prompt username + password
hardcode port and host...?

identify what kind of user (admin, data entry, end)

code for admin: ✔
• Can add users. ✔
• Can edit users. ✔
• Can block users. ✔
• Can make changes to database (modify tables attributes and constraints) ✔

Data entry users
• Can add information tuples to the database as long as the information being added meets the
database constraints ✔
• Can modify existing information in the database
    1. update ✔
    2. delete

End user
• Can lookup information in the database (ideally a remote user on a website that browses the
offerings of the museum, but we will have it simulated as part of the main program). ✔
'''

#log in


#connect to server
def connect():
    try:
        username = input("\nusername: ")
        user_pass = input("password: ")
        cnx = mysql.connector.connect(
                    host = "127.0.0.1",
                    port = 3306,
                    user = username,
                    password = user_pass,
                    database = "artmuseum")

        if cnx.is_connected():
            print("\nConnected to MySQL.") 
            return cnx
    except:
        print("Error connecting to MySQL. Please try again.")
        return connect()
    
#connect as a user
def authenticate_user():
    global cur
    username = input("\nusername: ") #username is unique
    if username != 'Guest':
        password = input("password: ")
    else:
        print("Welcome! You are now logged in as a guest.")
        role = 'end_user'
        return role
    
    user_type_name = {
        'admin': "Admin",
        'data_entry': "Data Entry User",
        'end_users': "End User"
    }
    
    cur.execute("SELECT role FROM users WHERE username = %s AND password = %s", (username, password))
    role = cur.fetchone()

    cur.execute("SELECT block_status FROM users WHERE username = %s AND password = %s", (username, password))
    block_status = cur.fetchone()

    if role:
        if block_status[0] == True:
            print("Your user has been blocked.")
            main()
        else:
            print(f"\nLogin successful! Welcome, {username}.\nYour role is: {user_type_name[role[0]]}.\n")
            return role[0]  # Return the user's role

    else:
        print("\nInvalid username or password. Please try again.")
        return authenticate_user()
    
def add_user():
    username = input("What is the username?: ")
    cur.execute("SELECT username FROM users WHERE username = %s", (username,))
    exist = cur.fetchone()
    if exist:
            while(True):
                user_choice = input("This user already exists. How would you like to continue?\nSelect 1 to try again\nSelect 2 to redirect to homepage.")
                if user_choice == '1':
                    add_user()
                    break
                elif user_choice == '2':
                    admin_home()
                else:
                    print("That is not a valid choice. Please try again.\n")
    password = input("What is the password?: ")
    while (True):
        role = input("What is the role of the user?: ")
        if (role != 'admin' and (role != 'data_entry') and (role != 'end_user')):
            print("Invalid role. Please try again.")
        else:
            break
    query = "INSERT INTO users (username, password, role) VALUES (%s, %s, %s)"
    val = (username, password, role)
    cur.execute(query, val)
    cnx.commit()
    print(f"\nSuccessfully added user {username}\n")

def remove_user():
    username = input("What is the username?: ")
    password = input("What is the password?: ")
    query = "DELETE FROM users WHERE username = %s AND password = %s"
    val = (username, password)
    cur.execute(query, val)
    cnx.commit()

def block_user():
    chose = input("Would you like to block or unblock a user?\n1 - Block\n2 - Unblock\n3 - Return Home\n")
    if chose == '3':
        admin_home()
        return
    username = input("What is the username?: ")
    password = input("What is the password?: ")
    cur.execute("SELECT block_status FROM users WHERE username = %s AND password = %s", (username, password))
    user_status = cur.fetchall()
    if not user_status:
        print("User not found.")
        block_user()

    current_status = user_status[0][0]
    query = ''
    if chose == '1':
        if current_status == False:
            query = "UPDATE users SET block_status = True WHERE username = %s AND password = %s"
        elif current_status == True:
            print("User is already blocked!\n")
            block_user()
    elif chose == '2':
        if current_status == True:
            query = "UPDATE users SET block_status = False WHERE username = %s AND password = %s"
        elif current_status == False:
            print("User is already unblocked!\n")
            block_user()
    else:
        print("That's not a valid input. Please try again.")
        block_user()
    val = (username, password)
    cur.execute(query, val)
    cnx.commit()
    if chose == '1':
        print("User succesfully blocked.")
    elif chose == '2':
        print("User successfully unbloked.")

def change_database():
    while (True):
        query = input("Enter sql command or enter 'q' to quit to home page: ")
        if query == 'q':
            admin_home()
            return
        else:
            try:
                # Check if the query is a SELECT query
                if query.startswith('select'):
                    cur.execute(query)  # Execute the SELECT query
                    result = cur.fetchall()  # Fetch all the rows
                    columns = [desc[0] for desc in cur.description]  # Get column names
                    print(tabulate(result, headers=columns, tablefmt='grid'))  # Print table using tabulate
                
                else:
                    # Execute other queries (INSERT, UPDATE, DELETE)
                    cur.execute(query)  # Execute other queries
                    cnx.commit()  # Commit the changes
                    print("Command successful!")
            except mysql.connector.Error as err:  # Catch MySQL specific errors
                print(f"Error: {err}")
        
            except Exception as e:  # Catch other exceptions and print details
                print(f"Unexpected error: {e}. Please try again.")

def admin_home():
    user_input = ''
    while user_input != '6':
        user_input = input("What are you looking to do today?\n1 - Add a user\n2 - Remove a user\n3 - Block a user\n4 - Make changes to the database\n5 - Log out\n6 - Shut down program\n")
        if user_input == '1':
            add_user()
        elif user_input == '2':
            remove_user()
        elif user_input == '3':
            block_user()
        elif user_input == '4':
            change_database()
        elif user_input == '5':
            main()
        elif user_input == '6':
            exit()
        else:
            print("Invalid choice. Please try again.")

def info_search(role):
    while True:
        user_input = input("What are you searching for today?:\n1 - Art Pieces\n2 - Artists\n3 - Exhibitions\n4 - Collections\n5 - Return Home\n")

        table = {
            '1': 'ART_OBJECT',
            '2': 'ARTIST',
            '3': 'EXHIBITION'
        }

        if user_input in table:

            if user_input == '1':
                print("What would you like to search by?:")
                print("1 - ID Number")
                print("2 - Title")
                print("3 - Origin")
                print("4 - Year")
                print("5 - Epoch")
                print("6 - Style")
                print("7 - Return Home")
            
            elif user_input == '2':
                print("What would you like to search by?:")
                print("1 - Author Name")
                print("2 - Date of Birth")
                print("3 - Date of Death")
                print("4 - Country of Origin")
                print("5 - Main Style")
                print("6 - Epoch")
                print("7 - Return Home")

            elif user_input == '3':
                print("What would you like to search by?:")
                print("1 - Exhibition Name")
                print("2 - Start of Exhbition")
                print("3 - End of Exhibition")
                print("4 - Return Home")


            art_pieces_variables = {
                '1': "Id_no",
                '2': "Title",
                '3': "Origin",
                '4': "Year",
                '5': "Epoch",
                '6': "Style"
            }

            artist_variables = {
                '1': 'AName',
                '2': 'Date_born',
                '3': 'Date_died',
                '4': 'Country_of_origin',
                '5': 'Main_style',
                '6': 'Epoch'
            }

            exhibition_variables = {
                '1': 'EName',
                '2': 'Start_date',
                '3': 'End_date'
            }

            table_name = {
                '1': art_pieces_variables,
                '2': artist_variables,
                '3': exhibition_variables
            }

            search_type = input()
            if ((user_input == '1' or '2') and search_type == '7') or (user_input == '3' and search_type == '4'):
                if role == 'data_entry':
                   print("Welcome back to the data entry user homepage.")
                   data_entry_home()
                elif role == 'end_user':
                   print("Welcome back to the guest user homepage.")
                   end_user_home()
            elif (search_type == '1') or (search_type == '2') or (search_type == '3') or (search_type == '4') or (search_type == '5') or (search_type == '6'):
                search = input("Enter your search: ")
                query = f"SELECT * FROM {table[user_input]} WHERE {table_name[user_input][search_type]} = %s;"
                val = (search,)
                try:
                    cur.execute(query, val)
                    results = cur.fetchall()
                    if results:
                        column_names = [desc[0] for desc in cur.description]  # Get column names dynamically
                        print("\nResults Found:\n")
                        for idx, row in enumerate(results, start=1):  # Enumerate rows for numbering
                            print(f"Result {idx}:")
                            for col_name, value in zip(column_names, row):
                                print(f"{col_name}: {value}")  # Dynamically label each value
                            print("-" * 40)  # Separator for better readability
                    else:
                        print("No matching results found.")
                except:
                    print(query, (val))
                    print(f"An error occurred. Restarting search...")
                    info_search(role)
            else:
                print("Invalid input. Please try again.")
        elif (user_input == '4'):
            while True:
                collection_type = input("What kind of collection would you like to search?\n1 - Permanent Collection\n2 - Borrowed Collection\n3 - Return Home\n")
                if collection_type == '1': #permanent collections
                    while True:
                        search_by = input("What would you like to search by?\n1 - Item Number\n2 - Status\n3 - Date Acquired\n4 - Return Home\n")
                        permanent_collection_variables = {
                            '1': 'item_no',
                            '2': 'Status',
                            '3': 'Date_acquired'
                        }
                        if search_by in permanent_collection_variables:
                            search = input("Enter your search: ")
                            query = f"SELECT * FROM PERMANENT_COLLECTION WHERE {permanent_collection_variables[search_by]} = %s;"
                            val = (search,)
                            try:
                                cur.execute(query, val)
                                results = cur.fetchall()
                                if results:
                                    column_names = [desc[0] for desc in cur.description]  # Get column names dynamically
                                    print("\nResults Found:\n")
                                    for idx, row in enumerate(results, start=1):  # Enumerate rows for numbering
                                        print(f"Result {idx}:")
                                        for col_name, value in zip(column_names, row):
                                            print(f"{col_name}: {value}")  # Dynamically label each value
                                        print("-" * 40)  # Separator for better readability
                                else:
                                    print("No matching results found.")
                            except:
                                print(query, (val))
                                print(f"An error occurred. Restarting search...")
                                info_search(role)
                        elif search_by == '4':
                            if role == 'data_entry':
                                data_entry_home()
                            elif role == 'end_user':
                                end_user_home()
                            else:
                                print("Error. Exiting...")
                                exit()
                        else:
                            print("Invalid Reponse. Please try again.")
                        break
                elif collection_type == '2': #borrowed collections
                    while True:
                        search_by = input("What would you like to search by?\n1 - Item Number\n2 - Date Borrowed\n3 - Date Returned\n4 - Name\n5 - Return Home\n")
                        borrowed_collection_variables = {
                            '1': 'item_no',
                            '2': 'Date_borrowed',
                            '3': 'Date_returned',
                            '4': 'B_CName'
                        }
                        if search_by in borrowed_collection_variables:
                            search = input("Enter your search: ")
                            query = f"SELECT * FROM BORROWED WHERE {borrowed_collection_variables[search_by]} = %s;"
                            val = (search,)
                            try:
                                cur.execute(query, val)
                                results = cur.fetchall()
                                if results:
                                    column_names = [desc[0] for desc in cur.description]  # Get column names dynamically
                                    print("\nResults Found:\n")
                                    for idx, row in enumerate(results, start=1):  # Enumerate rows for numbering
                                        print(f"Result {idx}:")
                                        for col_name, value in zip(column_names, row):
                                            print(f"{col_name}: {value}")  # Dynamically label each value
                                        print("-" * 40)  # Separator for better readability
                                else:
                                    print("No matching results found.")
                            except:
                                print(query, (val))
                                print(f"An error occurred. Restarting search...")
                                info_search(role)
                        elif search_by == '5':
                            if role == 'data_entry':
                                data_entry_home()
                            elif role == 'end_user':
                                end_user_home()
                            else:
                                print("Error. Exiting...")
                                exit()
                        else:
                            print("Invalid Reponse. Please try again.")
                        break
                elif collection_type == '3':
                    if role == 'data_entry':
                        data_entry_home()
                    elif role == 'end_user':
                        end_user_home()
                    else:
                        print("Error. Exiting...")
                        exit()
                else:
                    print("Invalid input. Please try again/")
        elif (user_input == '5'):
            if role == 'data_entry':
                data_entry_home()
            elif role == 'end_user':
                end_user_home()
        else:
            print("Invalid input. Please try again.")

def insert_data():
    '''
    Insert new tuples to a specific table in the database by first selecting the table for data
    insertion, then either:
        i. Providing a file with information line separated, where each line represents an
        entry that should be made to the table of choice
        ii. Providing a sequence of entries through detailed prompts ( for example ask the
        user to provide art piece name, then upon entering the value ask for the data,
        followed by type, etc...)
    '''
    #select table
    table_name = ''
    while True:
        print("What table would you like to edit?")
        cur.execute("SHOW TABLES")
        for (table,) in cur:
            print(table)
        table_name = input()
        try:
            cur.execute("SHOW TABLES")
            tables = [row[0].lower() for row in cur.fetchall()]  # Normalize to lowercase
            if (table_name.lower() in tables) == False:
                print(f"Error: Table '{table_name}' does not exist. Please enter a valid table name.")
            else:
                break
        except mysql.connector.Error as err:
            print(f"Error checking table existence: {err}")
            return  # Exit if there is a database error

    #chose what kind of insertion
    insertion_type = input("What method will you use to insert the data?\n1 - File\n2 - Sequence\n")
    #a) file
    if insertion_type == '1':
        file_path = input("Enter the path to your file: ")
        try:
            with open(file_path, 'r') as file:
                lines = file.readlines()

            # Fetch column names dynamically
            cur.execute(f"DESCRIBE {table_name};")
            columns = [desc[0] for desc in cur.fetchall()]
            
            # Prepare the SQL INSERT statement with placeholders
            query = f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({', '.join(['%s'] * len(columns))});"
            
            # Process each line to create a tuple for insertion
            data = []
            for line in lines:
                # Strip line and split by commas
                cleaned_line = line.strip().split(',')
                #C:\Users\abiaj\OneDrive\Desktop\demo_file_300_project.txt
                # Ensure the data matches the number of columns
                if len(cleaned_line) == len(columns):
                    data.append(tuple(cleaned_line))
                else:
                    print(f"Skipping line due to column mismatch: {line.strip()}")
                    continue
            
            # Debug: Print the prepared data to check it
            print("Data to insert:")
            for row in data:
                print(row)

            # Insert the data
            if data:
                cur.executemany(query, data)
                cnx.commit()
                print(f"Successfully inserted {len(data)} rows into {table_name}.")
            else:
                print("No valid data to insert.")

        except Exception as e:
            print(f"Error reading file or inserting data: {e}")

    #b) sequence of entries
    if insertion_type == '2':
        try:
            # Fetch column names dynamically
            cur.execute(f"DESCRIBE {table_name};")
            columns = cur.fetchall()
            
            # Prepare to store the values for insertion
            column_names = [col[0] for col in columns]
            data = []

            print(f"Please provide values for the following columns in {table_name}.")
            print(f"Columns: {', '.join(column_names)}")
            
            # Prompt the user for each column value
            row = []
            for col in columns:
                col_name = col[0]
                col_type = col[1]

                # Prompt for input
                value = input(f"Enter value for '{col_name}' ({col_type}): ").strip()

                # Handle NULL values
                if value.lower() == 'null':
                    value = None

                # Convert data types if necessary
                if "int" in col_type and value is not None:
                    value = int(value)
                elif "decimal" in col_type or "float" in col_type and value is not None:
                    value = float(value)

                row.append(value)

            # Add the row to the data list
            data.append(tuple(row))

            # Insert the collected data into the table
            query = f"INSERT INTO {table_name} ({', '.join(column_names)}) VALUES ({', '.join(['%s'] * len(column_names))});"
            cur.executemany(query, data)
            cnx.commit()
            print(f"Successfully inserted {len(data)} rows into {table_name}.")

        except Exception as e:
            print(f"Error inserting data: {e}")

def update_data():
    '''
    Update and delete tuples in the database by providing search field values. Make sure to
    show appropriate messages for successful updates and deletions, and also descriptive
    messages for failed attempts
    '''
    while True:
        manipulation = input("What are you looking to do?\n1 - Update data\n2 - Delete data\n3 - Return to Home\n")
        if manipulation == '1':
            print("What table are you looking to update?")
            cur.execute("SHOW TABLES")
            for (table,) in cur:
                print(table)
            table_name = input()

            cur.execute(f"SHOW KEYS FROM {table_name} WHERE Key_name = 'PRIMARY'")
            # Fetch and print primary key columns
            primary_key = ', '.join([info[4] for info in cur.fetchall()])
            print(f"What is the {primary_key} of the item you wish to update?: ")
            identifier = input()

            cur.execute(f"DESCRIBE {table_name}")
            print("What part of the record are you updating?:")
            columns = [row[0] for row in cur.fetchall()]
            for column in columns:
                print(column)
            column = input()

            print("What would you like to change this part of the record to?: ")
            updated_val = input()

            query = f"UPDATE {table_name} SET {column} = %s WHERE {primary_key} = %s;"
            val = (updated_val, identifier)
            try:
                cur.execute(query, val)
                if cur.rowcount > 0:
                    cnx.commit()
                    print("Update successful.")
                    break
                else:
                    print("Error with values. Restarting update...")
            except Exception as e:
                print(f"Unexpected error: {e}. Restarting update...")
                break
        elif manipulation == '2':
            try:
                print("What table are you looking to delete from?")
                cur.execute("SHOW TABLES")
                for (table,) in cur:
                    print(table)
                table_name = input()

                cur.execute(f"SHOW KEYS FROM {table_name} WHERE Key_name = 'PRIMARY'")
                # Fetch and print primary key columns
                primary_key = ', '.join([info[4] for info in cur.fetchall()])
                print(f"What is the {primary_key} of the item you wish to delete?: ")
                identifier = input()
                '''
                query = f"DELETE FROM {table_name} WHERE {primary_key} = %s;"
                val = (identifier,)
                try:
                    cur.execute(query, val)
                    if cur.rowcount > 0:
                        cnx.commit()
                        print("Deleted successfully.")
                        break
                    else:
                        print("Error with values. Restarting update...")
                except Exception as e:
                    print(f"Unexpected error: {e}. Restarting update...")
                    break
                '''
                # Step 1: Find all tables that reference the primary key
                query = f"""
                    SELECT 
                        table_name, 
                        column_name
                    FROM 
                        information_schema.key_column_usage
                    WHERE 
                        referenced_table_name = '{table_name}' 
                        AND referenced_column_name = '{primary_key}';
                """
                cur.execute(query)
                references = cur.fetchall()

                # Step 2: Delete from each table that references the primary key
                for table, column in references:
                    delete_query = f"DELETE FROM {table} WHERE {column} = %s;"
                    cur.execute(delete_query, (identifier,))
                    print(f"Deleted from {table}, where {column} = {identifier}")

                # Step 3: Delete from the parent table (the table you are sure about)
                delete_parent_query = f"DELETE FROM {table_name} WHERE {primary_key} = %s;"
                cur.execute(delete_parent_query, (identifier,))
                print(f"Deleted from {table_name}, where {primary_key} = {identifier}")

                # Commit the changes
                cnx.commit()
                print("All related rows deleted successfully.")

            except mysql.connector.Error as err:
                print(f"Error: {err}")
            except Exception as e:
                print(f"Unexpected error: {e}")  
        elif manipulation == '3':
            data_entry_home()
        else:
            print("Invalid answer. Try again.")
                    
def data_entry_home():
    user_input = ''
    role = 'data_entry'
    while user_input != '5':
        user_input = input("What are you looking to do today?\n1 - Lookup information\n2 - Insert Data\n3 - Update/Delete information\n4 - Log out\n5 - Shut down program\n")
        if user_input == '1':
            info_search(role)
        elif user_input == '2':
            insert_data()
        elif user_input == '3':
            update_data()
        elif user_input == '4':
            main()
        elif user_input == '5':
            exit()
        else:
            print("Invalid choice. Please try again.")

def end_user_home():
    role = 'end_user'
    info_search(role)

def main():
    print("\nWelcome user! Please enter your art museum username and password. To connect as a guest and lookup information, use the 'Guest' username.")
    user_type = authenticate_user()
    if user_type == 'admin':
        admin_home()
    elif user_type == 'data_entry':
        data_entry_home()
    elif user_type == 'end_user':
        end_user_home()
    else:
        print("Error. Exiting...")
        exit()
        

print("\nEnter MySQL username and password.")
cnx = connect()
cur = cnx.cursor()
main()

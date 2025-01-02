-- 1) Show all tables and explain how they are related to one another (keys, triggers, etc.)
SHOW TABLES;

SELECT 
    TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, 
    REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'ARTMUSEUM' 
    AND REFERENCED_TABLE_NAME IS NOT NULL;

SHOW TRIGGERS LIKE 'ARTMUSEUM%';

/*The query SHOW TABLES; retrieves a list of all the tables in the ARTMUSEUM database. 
This allows us to see which entities (such as PAINTING, USERS, BORROWED, etc.) exist within the database 
and serves as a foundation for further exploration into how they interact with one another.

The second query retrieves the foreign key relationships between tables using INFORMATION_SCHEMA.KEY_COLUMN_USAGE. 
This allows us to see how tables are related. Specifically, it shows which columns in one table reference primary 
keys in another table, enforcing referential integrity between them.

The third query SHOW TRIGGERS LIKE 'ARTMUSEUM%'; is used to display any triggers that may exist in the database. 
Triggers are special stored procedures that are automatically executed in response to certain actions 
(such as INSERT, UPDATE, or DELETE operations) on a table.*/

-- 2) A basic retrieval query

-- Write a query to list all artist names, the year they were born, and where they are from.
SELECT AName, Date_born, Country_of_origin
FROM ARTIST AS A, ART_OBJECT AS O
WHERE A.AName = O.A_Name;

-- 3) A retrieval query with ordered results

-- Retrieve all sculptures, ordered by 'Height' in ascending order
SELECT item_no, Height, Weight, Material
FROM SCULPTURE
ORDER BY Height ASC;

-- Retrieve all sculptures, ordered by 'Weight' in descending order
SELECT item_no, Height, Weight, Material
FROM SCULPTURE
ORDER BY Weight DESC;

-- 4) A nested retrieval query

-- Retrieve sculptures where the height is greater than the average height of all sculptures
SELECT item_no, Height, Weight, Material
FROM SCULPTURE
WHERE Height > (
    SELECT AVG(Height)
    FROM SCULPTURE
);



-- 5) A retrieval query using joined tables

-- Write a query to list the ID number and title of the sculptures and paintings that have the style "modern"
SELECT A.Id_No, A.Title
FROM ART_OBJECT A
WHERE A.Style = "Modern" AND A.Id_No IN
	(SELECT item_no
	 FROM ART_OBJECT A RIGHT JOIN PAINTING P ON A.Id_No = P.item_no
		UNION ALL
		SELECT item_no
		FROM ART_OBJECT A RIGHT JOIN SCULPTURE S ON A.Id_No = S.item_no);


-- 6) An update operation with any necessary triggers

-- Create an update trigger for the borrowed table that:
-- will not allow someone to set a borrowed date that is earlier than the current borrowed date
DROP TRIGGER IF EXISTS DATE_BORROWED_VIOLATION;
CREATE TRIGGER DATE_BORROWED_VIOLATION
BEFORE UPDATE ON BORROWED
FOR EACH ROW
SET NEW.DATE_BORROWED = if((SELECT Date_borrowed 
							FROM BORROWED
                            WHERE item_no = OLD.item_no) < NEW.DATE_BORROWED, NEW.DATE_BORROWED, OLD.DATE_BORROWED);

-- UPDATE OPERATION - should not work due to trigger
UPDATE BORROWED 
SET Date_borrowed = '2020-09-30'
WHERE item_no = 2128;

-- UPDATE OPERATION - should  work 
UPDATE BORROWED 
SET Date_borrowed = '2020-10-04'
WHERE item_no = 2128;


-- 7) A deletion operation with any necessary triggers

-- Create the ARCHIVED_COLLECTION table
CREATE TABLE ARCHIVED_COLLECTION (
    item_no            VARCHAR(10) NOT NULL,
    Status            VARCHAR(20) NOT NULL,
    Cost              INT,
    Date_acquired     INT,
    deletion_date     DATE,
    PRIMARY KEY (item_no, deletion_date)  -- Optional: ensures unique deletion records per item
);

-- Drop the trigger if it exists
DROP TRIGGER IF EXISTS ARCHIVE_COLLECTION;

-- Create the trigger to archive records upon deletion
CREATE TRIGGER ARCHIVE_COLLECTION
AFTER DELETE ON PERMANENT_COLLECTION
FOR EACH ROW
    INSERT INTO ARCHIVED_COLLECTION (item_no, Status, Cost, Date_acquired, deletion_date)
    VALUES (OLD.item_no, OLD.Status, OLD.Cost, OLD.Date_acquired, CURDATE());

-- Deletion operation
DELETE FROM PERMANENT_COLLECTION WHERE item_no = '2286' OR item_no = '1350' OR item_no = '1851';

USE master
GO

CREATE DATABASE HOTEL
GO

USE HOTEL
GO

CREATE TABLE Hotel
(
   HotelID int NOT NULL IDENTITY PRIMARY KEY,
   Name varchar(30) NOT NULL,
   Address varchar(40) NOT NULL,
   PhoneNumber varchar(15) NOT NULL CONSTRAINT CK_Hotel_PhoneNumber CHECK (PhoneNumber LIKE ('8-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')),
   Website varchar(30) NOT NULL,
   Email varchar(30) NOT NULL
)
GO

CREATE TABLE Category -- room types
(
   CategoryID int NOT NULL IDENTITY PRIMARY KEY,
   Name varchar(9) NOT NULL CONSTRAINT CK_Category_Name CHECK (Name IN ('single','double','twin','triple','quadriple')), 
   Floor char(1) NOT NULL CONSTRAINT CK_RoomInfo_Floor CHECK (Floor LIKE ('[1-5]')),
   Capacity char(1) NOT NULL CONSTRAINT CK_Category_Capacity CHECK (Capacity LIKE ('[1-4]')),
   Price int NOT NULL CONSTRAINT UQ_Category_Price UNIQUE (Price)
)
GO

ALTER TABLE Category
DROP CONSTRAINT CK_Category_Name
GO

CREATE TABLE RoomInfo -- room information
(
   RoomInfoID int NOT NULL IDENTITY PRIMARY KEY,
   Number int NOT NULL,
   Condition varchar(20) NOT NULL CONSTRAINT CK_RoomInfo_Condition CHECK (Condition IN ('free','busy','cleaning')), -- current state of the room
   Date date
)
GO


CREATE TABLE BookInfo -- booking information 
(
   BookInfoID int NOT NULL IDENTITY PRIMARY KEY,
   DateBook datetime, -- booking date
   BookedDate date,  -- first day of booking
   QuantityDays int NOT NULL ,  -- number of days booked
   Payment varchar(20) CONSTRAINT CK_BookInfo_Payment CHECK (Payment IN ('bank card','cash')), -- payment in cash or by credit card
   ClientsID int NOT NULL,
   PersonalID int NOT NULL,
   PriceForBook int default 0,
   RoomID int NOT NULL
)
GO

CREATE TABLE Room 
(
  RoomID int NOT NULL IDENTITY PRIMARY KEY,
  HotelID int NOT NULL CONSTRAINT FK_Room_Hotel FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID), -- ID of the hotel where the room is located
  Number int NOT NULL CONSTRAINT UQ_Room_Number UNIQUE CHECK (Number LIKE ('[1-5][0-9][0-9]')), -- room number
  CategoryID int NOT NULL CONSTRAINT FK_Room_Category FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID), -- Room type ID
  RoomInfoID int NOT NULL CONSTRAINT FK_Room_Room_Info FOREIGN KEY (RoomInfoID) REFERENCES RoomInfo(RoomInfoID) -- additional information on a specific number
)
GO

ALTER TABLE BookInfo
ADD CONSTRAINT FK_BookInfo_Room FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
GO

CREATE TABLE Personal -- working staff
(
  PersonalID int NOT NULL IDENTITY PRIMARY KEY,
  FName varchar(20) NOT NULL,
  LName varchar(20) NOT NULL,
  PositionID int NOT NULL,
  HotelID int NOT NULL 
)
GO

ALTER TABLE BookInfo
ADD CONSTRAINT FK_BookInfo_Personal FOREIGN KEY (PersonalID) REFERENCES Personal(PersonalID)
GO


ALTER TABLE Personal
ADD CONSTRAINT FK_Personal_Hotel FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
GO

CREATE TABLE Position -- hotel employee position
(
  PositionID int NOT NULL IDENTITY PRIMARY KEY,
  Name varchar(15) NOT NULL CONSTRAINT CK_Position_Name CHECK (Name IN ('administrator','cleaner')), -- наименование должности
  Salary decimal(9,2) NOT NULL
)
GO

ALTER TABLE Personal
ADD CONSTRAINT FK_Personal_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
GO


CREATE TABLE Clients  
(
  ClientsID int NOT NULL IDENTITY PRIMARY KEY,
  FName varchar(20) NOT NULL,
  LName varchar(20) NOT NULL,
  Phone varchar(15) NOT NULL CONSTRAINT CK_Clients_Phone CHECK (Phone LIKE ('8-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')),
  Email varchar(30),
  DocumentID int NOT NULL, 
  BankCard int
)
GO


ALTER TABLE BookInfo
ADD CONSTRAINT FK_BookInfo_CLients FOREIGN KEY (ClientsID) REFERENCES Clients(ClientsID)
GO


CREATE TABLE Document
(
  DocumentID int NOT NULL IDENTITY PRIMARY KEY,
  Type varchar(20) NOT NULL CONSTRAINT CK_Document_Type CHECK (Type IN ('foreign passport','russian passport')),  
  Series char(4) NOT NULL, 
  Number char(6) NOT NULL, 
  BirthDate date 
)
GO

ALTER TABLE Clients
ADD CONSTRAINT FK_Clients_Documents FOREIGN KEY (DocumentID) REFERENCES Document(DocumentID)
GO


CREATE TABLE Cleaning -- cleaning table
(
  CleaningID int NOT NULL IDENTITY PRIMARY KEY,
  HotelID int NOT NULL CONSTRAINT FK_Cleaning_Hotel FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID), 
  PersonalID int NOT NULL CONSTRAINT FK_Cleaning_Persoanl FOREIGN KEY (PersonalID) REFERENCES Personal(PersonalID), 
  NumberID int NOT NULL CONSTRAINT FK_Cleaning_Room FOREIGN KEY (NumberID) REFERENCES Room(RoomID), 
  CleaningDate date
)
GO


ALTER TABLE Clients
ALTER COLUMN Email varchar(150) 
GO

INSERT INTO Document([Type],[Series],[Number],[BirthDate]) VALUES('russian passport','2941','3146','16/11/1989'),('russian passport','5195','6875','25/05/1989'),('russian passport','8987','7010','25/08/1985'),('foreign passport','8705','4052','08/10/1997'),('foreign passport','9605','7243','02/04/1982');
INSERT INTO Category([Name],[Floor],[Capacity],[Price]) VALUES ('single','1',1,'1000'),('double',2,'2','2000'),('twin',3,'2','2150'),('triple',4,'3','3000'),('quadriple',5,'4','4000');
INSERT INTO Hotel VALUES ('HolidayInn','Russia,Moscow,Studencheskaya street,21','8-987-673-72-22','HolidayInn.com','HolidayInn@gmail.com'),('United Kingdom','Russia,Moscow,Studencheskaya street,74','8-123-534-26-96','UnitedKingdom.com','UnitedKingdom@mail.ru');
INSERT INTO Position VALUES ('Administrator','60000'),('Cleaner','25000');
INSERT INTO Personal VALUES ('John','Weely','1','1'),('Ethan','King','1','1'),('Megan','Ver','1','1'),('Amir','Nicolas','2','1'),('Sky','Hilarry','2','1'),('Jaime','Wing','2','1'),('Jessica','Collins','2','1');
INSERT INTO Clients VALUES ('John','Snow','8-987-673-72-19','m1124214@edu.misis.ru',1,78643),('Elvis','American','8-123-123-12-12','m324234@edu.ru',2,96527),('Megan','Welly','8-923-234-75-97','m854745@edu.ru',3,54645645),('Fol','Henry','8-000-765-67-67','dsfds@m.ru',4,45678),('Hotel','Hotel','8-983-233-23-23','m12415@edu.ru',5,0);
INSERT INTO RoomInfo Values (101,'free','28-12-2019'),(101,'free','29-12-2019'),(101,'free','30-12-2019'),(101,'free','31-12-2019'),(101,'free','01-01-2020'),(101,'free','02-01-2020'),(101,'free','03-01-2020'),(101,'free','04-01-2020'),(101,'free','05-01-2020'),(201,'free','28-12-2019'),(201,'free','29-12-2019'),(201,'free','30-12-2019'),(201,'free','31-12-2019'),(201,'free','01-01-2020'),(201,'free','02-01-2020'),(201,'free','03-01-2020'),(201,'free','04-01-2020'),(201,'free','05-01-2020'),(301,'free','28-12-2019'),(301,'free','29-12-2019'),(301,'free','30-12-2019'),(301,'free','31-12-2019'),(301,'free','01-01-2020'),(301,'free','02-01-2020'),(301,'free','03-01-2020'),(301,'free','04-01-2020'),(301,'free','05-01-2020'),(401,'free','28-12-2019'),(401,'free','29-12-2019'),(401,'free','30-12-2019'),(401,'free','31-12-2019'),(401,'free','01-01-2020'),(401,'free','02-01-2020'),(401,'free','03-01-2020'),(401,'free','04-01-2020'),(401,'free','05-01-2020'),(501,'free','28-12-2019'),(501,'free','29-12-2019'),(501,'free','30-12-2019'),(501,'free','31-12-2019'),(501,'free','01-01-2020'),(501,'free','02-01-2020'),(501,'free','03-01-2020'),(501,'free','04-01-2020'),(501,'free','05-01-2020');
INSERT INTO Room VALUES (1,101,1,1),(1,201,2,10),(1,301,3,19),(1,401,4,29),(1,501,5,39);

GO
CREATE TRIGGER TR_PriceForBook -- Trigger, when inserting reservation information, counts the total cost of the reservation (number of days* price per room)
ON BookInfo
FOR INSERT
AS
IF @@ROWCOUNT = 0
    RETURN
   SET NOCOUNT ON
UPDATE BookInfo
SET PriceForBook=(SELECT QuantityDays FROM BookInfo WHERE BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo))*(SELECT Price FROM Category where CategoryID=(SELECT CategoryID FROM Room where RoomID=(SELECT RoomID FROM BookInfo where BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo))))
GO

GO
CREATE TRIGGER TR_Condition -- A trigger that, after adding booking information for certain dates, immediately changes the status of the room to "busy" for these dates.
ON BookInfo
FOR INSERT
AS
IF @@ROWCOUNT = 0
    RETURN
   SET NOCOUNT ON
DECLARE @X int,@Y date
SET @X=(Select QuantityDays FROM BookInfo WHERE BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo));
SET @Y=(SELECT BookedDate FROM BookInfo WHERE BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo));
WHILE @X>0
BEGIN
UPDATE RoomInfo
SET Condition='busy' where (Number=(SELECT Number FROM Room WHERE RoomID=(SELECT RoomID FROM BookInfo WHERE BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo)))) AND Date=(SELECT @Y)
SET @Y=DATEADD(day,1,@Y)
SET @X=@X-1
END
GO

GO
CREATE TRIGGER TR_Money -- A trigger that waits 5 seconds for the total cost of the reservation to be updated, in order to then debit this money from the client's bank card and add it to the hotel's bank card.
ON BookInfo
FOR INSERT
AS
IF @@ROWCOUNT = 0
    RETURN
   SET NOCOUNT ON
WAITFOR DELAY '00:00:05';
DECLARE @M int=0
SET @M=(SELECT BankCard FROM CLients WHERE ClientsID=(SELECT ClientsID FROM BookInfo WHERE BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo)));
DECLARE @H int=0
SET @H=(SELECT BankCard FROM Clients WHERE ClientsID=5);
DECLARE @P int=0
SET @P=(SELECT PriceForBook FROM BookInfo WHERE BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo));
PRINT @P
UPDATE Clients
SET BankCard=@M-@P WHERE ClientsID=(SELECT ClientsID FROM BookInfo WHERE BookInfoID=(SELECT MAX(BookInfoID) FROM BookInfo));
UPDATE Clients
SET BankCard=@H+@P WHERE ClientsID=5;
GO

INSERT INTO BookInfo([DateBook],[BookedDate],[QuantityDays],[Payment],[ClientsID],[PersonalID],[RoomID]) VALUES ('14-12-2019','30-12-2019',5,'bank card',2,3,3),('17-12-2019','31-12-2019',6,'bank card',3,2,1);

GO
CREATE VIEW PersonalInfo -- A view that stores information about what position and how much each employee earns
AS
SELECT c.FName+c.LName as FULLNAME,ci.Name,ci.Salary FROM Personal as c
JOIN Position as ci
ON c.PositionID=ci.PositionID
GO

GO
CREATE VIEW ClientsInfo -- A view with full information about the hotel client
AS
SELECT p.FName +' '+ p.LName as FULLNAME,q.Series,q.Number FROM Clients as p
JOIN Document as q
ON p.DocumentID=q.DocumentID
GO

GO
CREATE FUNCTION fnBookInfo (@DateFrom DATE, @DateTo DATE) -- A function that searches for bookings that were made from a certain date to a certain date
RETURNS TABLE
AS
RETURN
( SELECT DateBook FROM BookInfo WHERE DateBook BETWEEN @DateFrom AND @DateTo )
GO

GO
CREATE FUNCTION fnBookRooms(@FName varchar(30),@LName varchar(30)) -- A function that shows by first and last name when a person made a reservation, how many days he lived in the hotel and how much he paid
RETURNS TABLE
AS
RETURN
(SELECT cm.FName+' '+cm.LName as FuulName,c.QuantityDays,c.DateBook,c.PriceForBook FROM BookInfo c
JOIN Clients cm
ON c.ClientsID=cm.ClientsID
WHERE FName=@FName AND LName=@LName)
GO

GO
CREATE FUNCTION fnAvgDaysPrice() -- A function that counts how many days on average live in the most expensive type of room
RETURNS TABLE
AS
RETURN
(SELECT AVG(QuantityDays) as AVGDAYS FROM BookInfo WHERE RoomID=(SELECT RoomID FROM Room WHERE CategoryID=(SELECT CategoryID FROM Category WHERE Price=(SELECT MAX(Price) FROM Category))))
GO

GO
CREATE PROCEDURE spaddcategory2 -- Procedure - adding a new room category
@Name varchar(9),
@Floor char(1),
@Capacity char(1),
@Price int
AS
SET NOCOUNT ON
INSERT INTO Category VALUES (@Name,@Floor,@Capacity,@Price)
GO

GO
CREATE PROCEDURE spsearchfreerooms -- Procedure - viewing numbers by a certain date and by status (busy or free)
@Condition varchar(20),
@Date date
AS
SET NOCOUNT ON
SELECT Number FROM RoomInfo WHERE Condition=@Condition AND Date=@Date
GO

GO
CREATE PROCEDURE spaddpersonal -- Procedure - adding a new employee
@FName varchar(20),
@LName varchar(20),
@PositionID int,
@HotelID int
AS
SET NOCOUNT ON
INSERT INTO Personal VALUES(@FName,@LName,@PositionID,@HotelID)
GO

SELECT*FROM fnBookInfo ('17-12-2019','21-12-2019') -- The function issued that in the period from December 17, 2019 to December 21, 2019, there was 1 reservation that was made on December 20, 2019
GO

SELECT*FROM fnBookRooms ('John','Snow') -- By name and surname, we looked at when a person made a reservation, how many days he lived and how much he paid
Go

SELECT*FROM fnAvgDaysPrice() -- How many days on average book the most expensive room category
Go

EXEC spaddcategory2'procedure',2,3,14353 -- Added a new room category
SELECT*FROM Category
GO

EXEC spsearchfreerooms 'free','30-12-2019' -- found out which numbers are available on December 30
GO

EXEC spaddpersonal 'proc','proc',1,1 -- Added a new employee
select*from Personal


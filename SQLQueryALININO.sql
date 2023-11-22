CREATE DATABASE AliAndNino
Use AliAndNino

CREATE TABLE Categories 
(
	Id int identity primary key,
	Title nvarchar(50) not null,
	ParentCategoryId int references Categories(Id),
	IsDeleted bit not null default 0
)

CREATE TABLE Books 
(
	Id int identity primary key,
	Title nvarchar(50) not null,
	Description nvarchar(250),
	ActualPrice money not null check (ActualPrice > 0),
	DiscountPrice money check (DiscountPrice > 0),
	PublishingHouseId int references PublishingHouses(Id),
	StockCount int not null, 
	ArticleCode varchar(50),
	BindingId int references Bindings(Id),
	Pages int,
	IsDeleted bit not null default 0
)

ALTER TABLE Books
ADD CategoryId int references Categories(Id)


CREATE TABLE Authors 
(
	Id int identity primary key,
	Name nvarchar(15) not null,
	Surname nvarchar(20) not null default 'XXX',
	IsDeleted bit not null default 0
)

CREATE TABLE BooksAuthors 
(
	Id int identity primary key,
	BookId int references Books(Id),
	AuthorId int references Authors(Id)
)

CREATE TABLE PublishingHouses 
(
	Id int identity primary key,
	Title nvarchar(50) not null,
	IsDeleted bit not null default 0
)

CREATE TABLE Genres 
(
	Id int identity primary key,
	Title nvarchar(30),
	IsDeleted bit not null default 0
)

CREATE TABLE BooksGenres 
(
	Id int identity primary key,
	BookId int references Books(Id),
	GenreId int references Genres(Id)
)

CREATE TABLE Bindings 
(
	Id int identity primary key,
	Title nvarchar(20),
	IsDeleted bit not null default 0
)

CREATE TABLE Languages 
(
	Id int identity primary key,
	Title nvarchar(20),
	IsDeleted bit not null default 0
)

CREATE TABLE BooksLanguages 
(
	Id int identity primary key,
	BookId int references Books(Id),
	LanguageId int references Languages(Id)
)

CREATE TABLE Comments 
(
	Id int identity primary key,
	Description nvarchar(50),
	BookId int references Books(Id),
	Rating float check (Rating >= 0 and Rating <= 5),
	Name nvarchar(15) not null,
	Email nvarchar(20) not null,
	ImageUrl nvarchar(max),
	IsDeleted bit not null default 0
)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------- INSERT DATA WITH PROCEDURES
--(Nermin muellim demisdiki butun insertleri eyni PROCEDURE icinde yazmalisiniz, yaza bilmedim ona gore her table-a ayri-ayri yazdim)

CREATE PROCEDURE usp_InsertCategories
(@Title nvarchar(50), @ParentCategoryId int, @IsDeleted bit)
AS
BEGIN 
	INSERT INTO Categories VALUES (@Title, @ParentCategoryId, @IsDeleted)
END

usp_InsertCategories 'Electronics', Null, 0
usp_InsertCategories 'Best Sellers', Null, 0
SELECT * FROM Categories



CREATE PROCEDURE usp_InsertBooks
(@Title nvarchar(50), @Description nvarchar(250), @ActualPrice money, @DiscountPrice money, @PublishingHouseId int, @StockCount int, @ArticleCode varchar(50), @BindingId int, @Pages int, @IsDeleted bit, @CategoryId int)
AS
BEGIN 
	INSERT INTO Books VALUES (@Title, @Description, @ActualPrice, @DiscountPrice, @PublishingHouseId, @StockCount, @ArticleCode , @BindingId, @Pages, @IsDeleted, @CategoryId)
	
END

usp_InsertBooks 'My Policeman', 'It is in 1950s Brighton that Marion first catches sight of the handsome and enigmatic Tom. He teaches her to swim in the shadow of the pier and Marion is smitten - determined her love will be enough for them both.',
			    22.20, 17.76, 1, 50, 'FFG453', 1, 250, 0, 2
SELECT * FROM Books



CREATE PROCEDURE usp_InsertAuthors
(@Name nvarchar(15), @Surname nvarchar(20), @IsDeleted bit)
AS
BEGIN 
	INSERT INTO Authors VALUES (@Name, @Surname, @IsDeleted)
END

usp_InsertAuthors 'Bethan','Roberts',0



CREATE PROCEDURE usp_InsertPublishingHouses
(@Title nvarchar(50), @IsDeleted bit)
AS
BEGIN 
	INSERT INTO PublishingHouses VALUES (@Title, @IsDeleted)
END

usp_InsertPublishingHouses 'Qanun Nesriyyat', 0



CREATE PROCEDURE usp_InsertGenres
(@Title nvarchar(50), @IsDeleted bit)
AS
BEGIN 
	INSERT INTO Genres VALUES (@Title, @IsDeleted)
END

usp_InsertGenres 'Roman', 0



CREATE PROCEDURE usp_InsertBindings
(@Title nvarchar(50), @IsDeleted bit)
AS
BEGIN 
	INSERT INTO Bindings VALUES (@Title, @IsDeleted)
END

usp_InsertBindings 'Yumshaq', 0



CREATE PROCEDURE usp_InsertLanguages
(@Title nvarchar(50), @IsDeleted bit)
AS
BEGIN 
	INSERT INTO Languages VALUES (@Title, @IsDeleted)
END

usp_InsertLanguages 'En', 0



CREATE PROCEDURE usp_InsertComments
(@Description nvarchar(250), @BookId int, @Rating float, @Name nvarchar(15), @Email nvarchar(20), @ImageURL nvarchar(max), @IsDeleted bit)
AS
BEGIN 
	INSERT INTO Comments VALUES (@Description, @BookId, @Rating, @Name, @Email, @ImageURL, @IsDeleted)
END

usp_InsertComments 'Good book :)', 1, 4.5, 'Gunash', 'Gunash@gmail.com', 'URLHGDVSNDU654GV', 0



CREATE PROCEDURE usp_InsertBooksAuthors
(@BookId int, @AuthorId int)
AS
BEGIN 
	INSERT INTO BooksAuthors VALUES (@BookId, @AuthorId)
END

usp_InsertBooksAuthors 1,1



CREATE PROCEDURE usp_InsertBooksLanguages
(@BookId int, @LanguageId int)
AS
BEGIN 
	INSERT INTO BooksLanguages VALUES (@BookId, @LanguageId)
END

usp_InsertBooksLanguages 1,1



CREATE PROCEDURE usp_InsertBooksGenres
(@BookId int, @GenreId int)
AS
BEGIN 
	INSERT INTO BooksGenres VALUES (@BookId, @GenreId)
END

usp_InsertBooksGenres 1,1 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------- UPDATE DATA WITH PROCEDURES

CREATE PROCEDURE usp_UpdateCategories
@Id int, @Title nvarchar(50), @ParentCategoryId int
AS
BEGIN
    UPDATE Categories
    SET Title = @Title, ParentCategoryId = @ParentCategoryId
    WHERE Id = @Id
END



CREATE PROCEDURE usp_UpdateAuthor
@Id int, @Name nvarchar(15),@Surname nvarchar(20)
AS
BEGIN
	UPDATE Authors
	SET Name = @Name, Surname = @Surname
	WHERE Id = @Id
END

usp_UpdateAuthor 1, 'Kanan', 'Aliyev'



CREATE PROCEDURE usp_UpdatePublishingHouses
@Id int, @Title nvarchar(50)
AS
BEGIN
	UPDATE PublishingHouses
	SET Title = @Title
	WHERE Id = @Id
END



CREATE PROCEDURE usp_UpdateGenre
@Id int, @Title nvarchar(50)
AS
BEGIN
	UPDATE Genres
	SET Title = @Title
	WHERE Id = @Id
END



CREATE PROCEDURE usp_UpdateBinding
@Id int, @Title nvarchar(50)
AS
BEGIN
	UPDATE Bindings
	SET Title = @Title
	WHERE Id = @Id
END



CREATE PROCEDURE usp_UpdateLanguage
@Id int, @Title nvarchar(50)
AS
BEGIN
	UPDATE Languages
	SET Title = @Title
	WHERE Id = @Id
END


CREATE PROCEDURE usp_UpdateComments
(@Id int, @Description nvarchar(250), @BookId int, @Rating float, @Name nvarchar(15), @Email nvarchar(20))
AS
BEGIN 
	UPDATE Comments
	SET Description = @Description, BookId = @BookId, Rating = @Rating, Name = @Name, Email = @Email
	WHERE Id = @Id
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------- CREATE TRIGGER FOR CHANGE ISDELETE

CREATE TRIGGER ChangeIsDeletedCategories
ON Categories
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Categories
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted)
END



CREATE TRIGGER ChangeIsDeletedAuthors
ON Authors
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Authors
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted)
END



CREATE TRIGGER ChangeIsDeletedPublishingHouses
ON PublishingHouses
INSTEAD OF DELETE
AS
BEGIN
    UPDATE PublishingHouses
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted)
END



CREATE TRIGGER ChangeIsDeletedGenres
ON Genres
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Genres
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted)
END



CREATE TRIGGER ChangeIsDeletedBindings
ON Bindings
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Bindings
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted)
END



CREATE TRIGGER ChangeIsDeletedLanguages
ON Languages
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Languages
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted)
END



CREATE TRIGGER ChangeIsDeletedComments
ON Comments
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Comments
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted)
END

--SQL quan ly quan caphe


-- Lai -- 
--tao bang database 
CREATE DATABASE CoffeManagement
GO

--su dung database da tao la quanlyquancafe
USE CoffeManagement
GO

--tao cac table --

--Tao table tai khoan
CREATE TABLE Account
(
	UserName NVARCHAR(100) PRIMARY KEY,
	DisplayName NVARCHAR(100)NOT NULL DEFAULT N'Admin',
	PassWord NVARCHAR(100) NOT NULL DEFAULT 0,
	Type INT NOT NULL DEFAULT 0 --loai tai khoan -- 0:Quan ly -- 1:Nhan vien
)
GO

-- End -- 

-- Luan -- 
--Tao table ban nuoc
CREATE TABLE TableDrink
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100)NOT NULL DEFAULT N'chua dat ten',
	status NVARCHAR(100) NOT NULL DEFAULT N'Trống' --Status ban trong hoac co nguoi
)
GO
-- END -- 

-- Nguyen -- 
--tao table loai thuc uong
CREATE TABLE TypeDrink
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100)NOT NULL DEFAULT N'chua dat ten'
)
GO

--tao table thuc uong cua loai thuc uong nao
CREATE TABLE drink
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100)NOT NULL DEFAULT N'chua dat ten',
	idTypeDrink INT NOT NULL,
	price FLOAT NOT NULL DEFAULT 0
	
	FOREIGN KEY (idTypeDrink) REFERENCES dbo.TypeDrink(id)
)
GO

-- END -- 

-- Truc -- 
--tao table hoa don ban

CREATE TABLE Bill
(
	id INT IDENTITY PRIMARY KEY,
	DateCheckIn Date NOT NULL DEFAULT GETDATE(),
	DateCheckOut Date,
	idTable INT NOT NULL,
	status INT NOT NULL DEFAULT 0 --0:chua thanh toan , 1: da thanh toan
	
	FOREIGN KEY (idTable) REFERENCES dbo.TableDrink(id)
)
GO

--Them cot giam gia
ALTER TABLE Bill
ADD discount INT DEFAULT 0
GO

--Thêm cột Tổng tiền hóa đơn
ALTER TABLE dbo.Bill ADD totalPrice FLOAT
GO

-- Thêm cột Delete cho bàn
ALTER TABLE dbo.TableDrink
ADD deleteTable NVARCHAR(10) DEFAULT N'false'
GO

--tao table bao cao hoa don 
CREATE TABLE DrinkBill
(  
	id INT IDENTITY PRIMARY KEY,
	idBill INT NOT NULL,
	idDrink INT NOT NULL,
	count INT NOT NULL DEFAULT 0
	
	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idDrink) REFERENCES dbo.Drink(id)
)
GO

-- END -- 

CREATE PROC SP_Ban
AS SELECT * FROM dbo.TableDrink WHERE deleteTable = N'false'
GO

EXEC SP_Ban

GO

--Them ban
CREATE PROC SP_themBan(@name NVARCHAR(100),@status NVARCHAR(100))
AS
BEGIN
	INSERT INTO TableDrink(name,status)
	VALUES(@name,@status)
END

EXEC SP_themBan N'ban 11',N''

GO
--Cap nhat ban
CREATE PROC SP_capnhatBan(@id INT,@name NVARCHAR(100),@status NVARCHAR(100))
AS
BEGIN
	UPDATE TableDrink
	SET name = @name,status = @status
	WHERE id = @id
END
GO

EXEC SP_capnhatBan 1,N'Bàn 1',N'Trống'
GO

--Delete ban
CREATE PROC SP_xoaBan(@id INT)
AS
BEGIN
	UPDATE TableDrink SET deleteTable = N'true'
	WHERE id = @id
END
GO

EXEC SP_xoaBan 1
GO


-- lay danh sach tai khoan
CREATE PROC SP_Account
AS SELECT *FROM dbo.Account
GO
EXEC SP_Account
GO

--Lấy danh sách tài khoản theo username
CREATE PROC SP_getAccount(@username NVARCHAR)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @username
END
GO

--them tai khoan
CREATE PROC SP_themTaikhoan(@Username NVARCHAR(100),@Displayname NVARCHAR(100),@Password NVARCHAR(100),@type INT)
AS
BEGIN
	INSERT INTO Account(UserName,DisplayName,PassWord,Type)
	VALUES(@Username,@Displayname,@Password,@type)
END
GO
--cap nhat tai khoan
CREATE PROC SP_capnhatTaikhoan(@Username NVARCHAR(100),@Displayname NVARCHAR(100),@Password NVARCHAR(100),@type INT)
AS
BEGIN
	UPDATE Account
	SET UserName = @Username ,DisplayName = @Displayname,PassWord = @Password,Type =@type
	WHERE UserName = @Username
END
GO

EXEC SP_capnhatTaikhoan N'lai',N'lainguyen',N'1',1
GO

EXEC SP_themTaikhoan N'Admin',N'Admin',N'1',0
GO

--Delete taikhoan
CREATE PROC SP_xoaTaikhoan(@username NVARCHAR(100))
AS
BEGIN
	DELETE FROM Account
	WHERE UserName = @username
END
GO

EXEC SP_xoaTaikhoan N'lai'
GO

--lay danh sach loai thuc uong
CREATE PROC SP_LoaiDrink
AS 
BEGIN
	SELECT *FROM dbo.TypeDrink
END
GO

EXEC SP_LoaiDrink
GO

--lay danh sach typedrink theo id

CREATE PROC SP_LoaiDrinkId(@id INT)
AS 
BEGIN
	SELECT *FROM dbo.TypeDrink WHERE id = @id
END
GO


--them loai thuc uong
CREATE PROC SP_themLoaidrink(@name NVARCHAR(100))
AS
BEGIN
	INSERT INTO TypeDrink(name)
	VALUES(@name)
END
GO

EXEC SP_themLoaidrink N'Capuchino'
GO

--cap nhat loai thuc uong
CREATE PROC SP_capnhatLoaidrink(@id INT,@name NVARCHAR(100))
AS
BEGIN
	UPDATE TypeDrink
	SET name = @name
	WHERE id = @id
END
GO

EXEC SP_capnhatLoaidrink 4,N'Capuchino'
GO

--delete loai thuc uong
CREATE PROC SP_xoaLoaidrink(@id INT)
AS
BEGIN
	DELETE FROM TypeDrink
	WHERE id = @id
END
GO

GO
EXEC SP_xoaLoaidrink 1
GO

--lay danh sach thuc uong
CREATE PROC SP_listDrink
AS 
BEGIN
	SELECT * FROM drink 
END
GO

EXEC SP_listDrink
GO

--them thuc uong
CREAtE PROC SP_themDrink(@name NVARCHAR(100),@idloai INT,@price FLOAT)
AS
BEGIN
	INSERT INTO drink(name,idTypeDrink,price)
	VALUES(@name,@idloai,@price)
END
GO

EXEC SP_themDrink N'Sữa',4,22000
GO

--Update drink
CREATE PROC SP_updateDrink(@id INT ,@name NVARCHAR(100),@idloai INT,@price FLOAT)
AS
BEGIN
	UPDATE drink SET name = @name, idTypeDrink = @idloai, price = @price
	WHERE id = @id
END

GO

--Xoa drink
CREATE PROC SP_deleteDrink(@id INT)
AS
BEGIN
	DELETE drink WHERE id = @id
END
GO

INSERT INTO Bill(DateCheckIn,DateCheckOut,idTable,status)
VALUES (GETDATE(),GETDATE(),3,1)

GO

INSERT INTO DrinkBill(idBill,idDrink,count)
VALUES (6,4,1)
GO


SELECT d.name,db.count,d.price,d.price*db.count AS TotalPrice FROM dbo.DrinkBill AS db,dbo.drink AS d,dbo.Bill AS bi
WHERE db.idBill = bi.id AND db.idDrink = d.id AND status = 0 AND bi.idTable = 3

Go


--Lay danh sach drink theo id Typedrink
CREATE PROC SP_getDrinkbyIdTypeDrink(@id INT)
AS
BEGIN
SELECT * from drink WHERE idTypeDrink = @id
END
GO

EXEC SP_getDrinkbyIdTypeDrink 4

GO


--Them Hoa don theo ban
CREATE PROC SP_AddBill(@idTable INT)
AS
BEGIN
	INSERT INTO Bill(DateCheckIn,DateCheckOut,idTable,status,discount)
	VALUES (GETDATE() ,NULL,@idTable,0,0)
END
GO

--Them drinkbill theo idBill
CREATE PROC SP_AddDrinkBill (@idBill INT,@idDrink INT,@count INT)
AS
BEGIN
	DECLARE @exBillif INT
	DECLARE @drinkcout INT = 1
	SELECT @exBillif = id,@drinkcout = b.count 
	FROM DrinkBill AS b WHERE idBill = @idBill AND idDrink = @idDrink
	IF(@exBillif > 0)
	BEGIN
		DECLARE @newcount INT = @drinkcout + @count
		IF(@newcount > 0)
			UPDATE DrinkBill SET count = @drinkcout + @count WHERE idDrink = @idDrink
		ELSE
			DELETE DrinkBill WHERE idBill = @idBill AND idDrink = @idDrink
	END
	ELSE
	BEGIN
		INSERT INTO DrinkBill(idBill,idDrink,count)
		VALUES(@idBill,@idDrink,@count)
	END
END
GO

--Xóa drink theo id Type Drink
CREATE PROC SP_deleteDrinkByType(@idType INT)
AS
BEGIN
	DELETE drink WHERE idTypeDrink = @idType
END

GO

--Xoa drink khi drink nam trong drinkbill
CREATE PROC SP_deleteDrinkbyId(@idDrink INT)
AS
BEGIN
	DELETE DrinkBill WHERE idDrink = @idDrink
END
GO

--Xoa bill nam trong Table de xoa Table
CREATE PROC SP_deleteBillbyIdTable(@idTable INT)
AS
BEGIN
	DELETE Bill WHERE idTable = @idTable
END
GO
--xoa bill nam trong drinkbill de xoa table
CREATE PROC SP_deleteDrinkBillByidBill(@idBill INT)
AS
BEGIN
	DELETE DrinkBill WHERE idBill = @idBill
END
GO
--Cap nhat Bill 
CREATE PROC SP_BillidTable(@id INT,@discount INT,@totalPrice FLOAT)
AS
BEGIN 
	UPDATE Bill SET DateCheckOut = GETDATE(), status = 1, discount = @discount, totalPrice = @totalPrice WHERE id = @id
END
GO


--lay danh sach hoa don

CREATE PROC SP_getHoadon(@dateCheckIn DATE, @dateCheckOut DATE)
AS
BEGIN
	SELECT t.name AS [Tên Bàn], DateCheckIn AS [Ngày Vào], DateCheckOut AS [Ngày Ra], discount AS [Giảm Giá %], b.totalPrice AS [Tổng Tiền]
	FROM Bill AS b, TableDrink AS t
	WHERE DateCheckIn >= @dateCheckIn AND DateCheckOut <= @dateCheckOut AND b.status = 1 AND t.id = b.idTable
END
GO

--Update status cho table khi thêm drink
CREATE TRIGGER TG_updateDrinkBill 
ON dbo.DrinkBill FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @idBill INT
	SELECT @idBill = idBill FROM inserted
	
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill AND status = 0
	
	UPDATE dbo.TableDrink SET status = N'Có người' WHERE id = @idTable
END
GO

--Update status cho table khi thanh toán
CREATE TRIGGER TG_updateBill
ON dbo.Bill FOR UPDATE
AS
BEGIN
	DECLARE @idBill INT
	SELECT @idBill = id FROM inserted
	
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill
	
	DECLARE @count INT = 0
	SELECT @count = COUNT(*) FROM dbo.Bill WHERE idTable = @idTable AND status = 0
	
	IF(@count = 0)
		UPDATE dbo.TableDrink SET status = N'Trống' WHERE id = @idTable
END
GO

--Chức năng chuyển bàn

Create PROC SP_chuyenBan(@idTable1 INT,@idTable2 INT)
AS
BEGIN
	DECLARE @idFirstBill INT
	DECLARE @idSecondBill INT
	
	DECLARE @statusFirstTable INT = 1
	DECLARE @statusSecondTable INT = 1
	
	SELECT @idSecondBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
	
	IF(@idFirstBill IS NULL)
	BEGIN
		PRINT N'01'
		INSERT Bill(DateCheckIn ,DateCheckOut ,idTable ,status)
		VALUES(GETDATE() ,NULL ,@idTable1 ,0)
		SELECT @idFirstBill = MAX(id) FROM Bill WHERE idTable = @idTable1 AND status = 0
	END
	
	SELECT @statusFirstTable = COUNT(*) FROM DrinkBill WHERE idBill = @idFirstBill
	
	IF(@idSecondBill IS NULL)
	BEGIN
		PRINT N'02'
		INSERT Bill(DateCheckIn ,DateCheckOut ,idTable ,status)
		VALUES(GETDATE() ,NULL ,@idTable2 ,0)
		SELECT @idSecondBill = MAX(id) FROM Bill WHERE idTable = @idTable2 AND status = 0
		SET @statusSecondTable = 1
	END
	
	SELECT @statusSecondTable = COUNT(*) FROM DrinkBill WHERE idBill = @idSecondBill
	
	SELECT id INTO IDBillInfoTable FROM dbo.DrinkBill WHERE idBill = @idSecondBill
	
	UPDATE DrinkBill SET idBill = @idSecondBill WHERE idBill = @idFirstBill
	
	UPDATE DrinkBill SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF(@statusFirstTable = 0)
		UPDATE dbo.TableDrink SET status = N'Trống' WHERE id = @idTable2
	
	IF(@statusSecondTable = 0)
		UPDATE dbo.TableDrink SET status = N'Trống' WHERE id = @idTable1
END
GO

--Trigger cap nhat sau khi delete drink trong drinkbill

CREATE TRIGGER TG_deleteDrinkBill 
ON dbo.DrinkBill FOR DELETE
AS
BEGIN
	DECLARE @idDrinkBill INT
	DECLARE @idBill INT
	SELECT @idDrinkBill = id, @idBill = deleted.idBill FROM deleted
	
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM Bill WHERE id = @idBill
	
	DECLARE @count INT = 0
	
	SELECT @count = COUNT(*) FROM DrinkBill, Bill WHERE idBill = @idBill AND Bill.id = @idDrinkBill AND Bill.status = 0
	IF(@count = 0)
		UPDATE TableDrink SET status = N'Trống' WHERE id = @idTable
END
GO

--Fuction tieng viet khong dau
CREATE FUNCTION [dbo].[GetUnsignString](@strInput NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
AS
BEGIN     
    IF @strInput IS NULL RETURN @strInput
    IF @strInput = '' RETURN @strInput
    DECLARE @RT NVARCHAR(4000)
    DECLARE @SIGN_CHARS NCHAR(136)
    DECLARE @UNSIGN_CHARS NCHAR (136)

    SET @SIGN_CHARS       = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ'+NCHAR(272)+ NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
    SET @COUNTER = 1
 
    WHILE (@COUNTER <=LEN(@strInput))
    BEGIN   
      SET @COUNTER1 = 1
      --Tim trong chuoi mau
       WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1)
       BEGIN
     IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) )
     BEGIN           
          IF @COUNTER=1
              SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1)                   
          ELSE
              SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER)    
              BREAK         
               END
             SET @COUNTER1 = @COUNTER1 +1
       END
      --Tim tiep
       SET @COUNTER = @COUNTER +1
    END
    RETURN @strInput
END

SELECT * FROM Account WHERE dbo.GetUnsignString(UserName) LIKE N'%' + dbo.GetUnsignString(N'la') + '%'
GO




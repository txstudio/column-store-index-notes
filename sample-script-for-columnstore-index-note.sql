-- ---------------------------------------------
-- #1 叢集資料行存放區索引是否可以與非叢資料列索引並存 ?
-- ---------------------------------------------
CREATE CLUSTERED COLUMNSTORE INDEX [cci_SalesOrderDetail]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
GO

CREATE NONCLUSTERED INDEX [ix_SalesOrderDetail_rowguid]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]([rowguid])
GO

CREATE NONCLUSTERED INDEX [ix_SalesOrderDetail_SalesOrderID]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]([SalesOrderID])
GO


--DROP INDEX [cci_SalesOrderDetail]
--	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
--GO
--DROP INDEX [ix_SalesOrderDetail_rowguid]
--	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
--GO
--DROP INDEX [ix_SalesOrderDetail_SalesOrderID]
--	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
--GO


-- ---------------------------------------------
-- #2 叢集資料行存放區索引與非叢集資料行存放區索引是否可以並存 ?
-- ---------------------------------------------
CREATE CLUSTERED COLUMNSTORE INDEX [cci_SalesOrderDetail]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [nci_SalesOrderDetail_rowguid]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]([rowguid])
GO


--DROP INDEX [cci_SalesOrderDetail]
--	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
--GO


-- ---------------------------------------------
-- #3 有叢集資料列索引的資料表可以建立幾個非叢集資料行存放區索引 ?
-- ---------------------------------------------
CREATE CLUSTERED INDEX [pk_SalesOrderDetail]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]([SalesOrderDetailID])
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [nci_SalesOrderDetail_rowguid]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]([rowguid])
GO

--建立第二個 nonclustered columnstore index 會取得下列錯誤訊息
--Msg 35339, Level 16, State 1, Line 50
--Multiple columnstore indexes are not supported.
CREATE NONCLUSTERED COLUMNSTORE INDEX [nci_SalesOrderDetail_SalesOrder]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]([SalesOrderDetailID],[SalesOrderID])
GO


--DROP INDEX [pk_SalesOrderDetail]
--	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
--GO

--DROP INDEX [nci_SalesOrderDetail_rowguid]
--	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
--GO



-- ---------------------------------------------
-- #4 資料表有一個叢集資料列索引的話是否可以直接建立叢集資料行存放區索引 ?
-- ---------------------------------------------
CREATE CLUSTERED INDEX [pk_SalesOrderDetail]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]([SalesOrderDetailID])
GO

--會取得下列錯誤
--Msg 7999, Level 16, State 9, Line 81
--Could not find any index named 'cci_SalesOrderDetail' for table 'dbo.SalesOrderDetailFromAdventureWorks2017'.
CREATE CLUSTERED COLUMNSTORE INDEX [cci_SalesOrderDetail]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
	WITH (DROP_EXISTING = ON)
GO

--INDEX 名稱要相同
CREATE CLUSTERED COLUMNSTORE INDEX [pk_SalesOrderDetail]
	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
	WITH (DROP_EXISTING = ON)
GO

--DROP INDEX [pk_SalesOrderDetail]
--	ON [dbo].[SalesOrderDetailFromAdventureWorks2017]
--GO
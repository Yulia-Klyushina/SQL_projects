SELECT [Sales].[Customers].[custid]
      , [Sales].[Customers].[companyname]
   FROM [Sales].[Customers]
  WHERE [custid] NOT IN 
  (SELECT [custid] FROM [Sales].[Orders]);
-- WITH CTE AS 
-- (SELECT [Sales].[Customers].[custid]
--       , [Sales].[Customers].[companyname]
--       , [Sales].[Orders].[orderid]
--     FROM [Sales].[Customers]
--     LEFT JOIN [Sales].[Orders] ON [Sales].[Customers].[custid] = [Sales].[Orders].[custid])
-- SELECT [custid]
--        , [companyname]
--        , [orderid]
--        FROM CTE
--        WHERE [orderid] IS NULL;
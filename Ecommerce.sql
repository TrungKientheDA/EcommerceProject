SELECT * FROM test;

-- CÂU 1
-- MAX
SELECT TOP (3) Product_Category, sum(cast(Sales AS numeric)) AS Sales
FROM test
GROUP BY Product_Category
ORDER BY Sales DESC;

-- MIN
SELECT TOP (3) Product_Category, sum(cast(Sales AS numeric)) AS Sales
FROM test
GROUP BY Product_Category
ORDER BY Sales ASC;

-- CÂU 2
CREATE TABLE band (
  band_start INT,
  band_end INT
);
INSERT INTO band VALUES
	(0, 100),
	(100, 200),
	(200, 300),
	(300, 400),
	(400, 500),
	(500, 600),
	(600, 700),
	(700, 800),
	(800, 900),
	(900, 1000),
	(1000, 1100);

SELECT CONCAT(band.band_start, '-', band.band_end) as band, COUNT(test.Sales) as no_customer
FROM test
JOIN band
ON cast(test.Sales as numeric) > band.band_start AND cast(test.Sales as numeric) <= band.band_end
GROUP BY CONCAT(band.band_start, '-', band.band_end);

-- CÂU 3
CREATE VIEW cohort AS
SELECT
  Customer_id,
  -- Lấy tháng đặt hàng đầu tiên của mỗi khách hàng
  DATEADD(month, DATEDIFF(month, 0, MIN(Order_Date) OVER (PARTITION BY Customer_id)), 0) AS first_order_month,
  -- Lấy tháng đặt hàng hiện tại của mỗi đơn hàng
  DATEADD(month, DATEDIFF(month, 0, Order_Date), 0) AS current_order_month,
  -- Đếm số lượng đơn hàng trong mỗi tháng của mỗi khách hàng
  COUNT(Sales) OVER (PARTITION BY Customer_id, DATEADD(month, DATEDIFF(month, 0, Order_Date), 0)) AS order_count
FROM test;
SELECT * FROM cohort;
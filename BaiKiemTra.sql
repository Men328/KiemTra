-- EX2:
ALTER TABLE carts
ADD FOREIGN KEY(productid) REFERENCES products(productid);

ALTER TABLE carts
ADD FOREIGN KEY(userid) REFERENCES users(userid);

ALTER TABLE reviews 
ADD FOREIGN KEY(userid) REFERENCES users(userid);

ALTER TABLE reviews 
ADD FOREIGN KEY(productid) REFERENCES products(productid);

ALTER TABLE images
ADD FOREIGN KEY(productid) REFERENCES products(productid);

ALTER TABLE products
ADD FOREIGN KEY(categoryid) REFERENCES categories(categoryid);

ALTER TABLE products
ADD FOREIGN KEY(storeid) REFERENCES stores(storeid);

ALTER TABLE order_details
ADD FOREIGN KEY(productid) REFERENCES products(productid);

ALTER TAble order_details
ADD FOREIGN KEY(productid) REFERENCES products(productid);

ALTER TAble orders
ADD FOREIGN KEY(userid) REFERENCES users(userid);

ALTER TABLE orders
ADD FOREIGN KEY(storeid) REFERENCES stores(storeid);

ALTER TABLE stores
ADD FOREIGN KEY(userid) REFERENCES users(userid);

-- EX3:
-- Liệt kê tất cả các thông tin về sản phẩm (products).
SELECT * FROM products;

-- Tìm tất cả các đơn hàng (orders) có tổng giá trị (totalPrice) lớn hơn 500,000.
SELECT orderId, nameOrder, totalPrice FROM orders
WHERE totalPrice > 500.000;

-- Liệt kê tên và địa chỉ của tất cả các cửa hàng (stores).
SELECT storeName, addressStore FROM stores;

-- Tìm tất cả người dùng (users) có địa chỉ email kết thúc bằng '@gmail.com'.
SELECT * FROM users
WHERE email LIKE '%@gmail.com';

-- Hiển thị tất cả các đánh giá (reviews) với mức đánh giá (rate) bằng 5.
SELECT content FROM reviews
WHERE rate = 5;

-- Liệt kê tất cả các sản phẩm có số lượng (quantity) dưới 10.
SELECT * FROM products
WHERE quantity < 10;

-- Tìm tất cả các sản phẩm thuộc danh mục categoryId = 1.
SELECT productId, productName FROM products
WHERE categoryId = 1;

-- Đếm số lượng người dùng (users) có trong hệ thống.
SELECT DISTINCT COUNT(userid) AS SoLuongNguoiDung FROM users;

-- Tính tổng giá trị của tất cả các đơn hàng (orders).
SELECT SUM(totalPrice) AS TongGiaTriCacDonHang FROM orders;

-- Tìm sản phẩm có giá cao nhất (price).
SELECT productId, productName FROM products
WHERE price IN (
	SELECT MAX(price) AS GiaCaoNhat FROM products
)
LIMIT 1;

-- Liệt kê tất cả các cửa hàng đang hoạt động (statusStore = 1).
SELECT storeId, storeName, statusstore FROM stores
WHERE statusstore = 1;

-- Đếm số lượng sản phẩm theo từng danh mục (categories).
SELECT c.categoryId, COUNT(p.productId) AS SoLuongSanPham FROM products AS p
INNER JOIN categories AS c ON c.categoryId = p.categoryId
GROUP BY c.categoryId;

-- Tìm tất cả các sản phẩm mà chưa từng có đánh giá.
SELECT p.* FROM products p
LEFT JOIN reviews r ON p.productId = r.productId
WHERE r.productId IS NULL;

-- Hiển thị tổng số lượng hàng đã bán (quantityOrder) của từng sản phẩm.
SELECT DISTINCT od.productId, COUNT(od.quantityOrder) TongSoHangDaBan FROM order_details AS od
INNER JOIN products AS p ON p.productId = od.productId
GROUP BY od.productId;

-- Tìm các người dùng (users) chưa đặt bất kỳ đơn hàng nào.
SELECT * FROM users AS u
WHERE NOT EXISTS (
    SELECT 1 FROM orders AS o
    WHERE o.userId = u.userId
);

-- Hiển thị tên cửa hàng và tổng số đơn hàng được thực hiện tại từng cửa hàng.
SELECT DISTINCT s.storeId, s.storeName, COUNT(o.orderId) AS TongSoDonHang FROM orders AS o
INNER JOIN stores AS s ON o.storeId = s.storeId
GROUP BY s.storeId;

-- Hiển thị thông tin của sản phẩm, kèm số lượng hình ảnh liên quan.
SELECT p.*, COUNT(imageProduct) AS SoHinhAnh FROM products AS p
GROUP BY p.productId;

-- Hiển thị các sản phẩm kèm số lượng đánh giá và đánh giá trung bình.
SELECT p.productId, p.productName, COUNT(r.reviewId) AS SoLuongDanhGia,
AVG(r.rate) AS DanhGiaTrungBinh FROM products AS p
LEFT JOIN reviews AS r ON r.productId = p.productId
GROUP BY p.productId, p.productName;

-- Tìm người dùng có số lượng đánh giá nhiều nhất.
SELECT u.userId, u.userName, COUNT(r.reviewId) AS SoDanhGia FROM users AS u
LEFT JOIN reviews AS r ON u.userId = r.userId
GROUP BY u.userId, u.userName
ORDER BY SoDanhGia DESC
LIMIT 1;

-- Hiển thị top 3 sản phẩm bán chạy nhất (dựa trên số lượng đã bán).
SELECT p.productId, p.productName, SUM(od.quantityOrder) AS SoluongDaBan FROM products AS p
JOIN order_details AS od ON p.productId = od.productId
GROUP BY p.productId, p.productName
ORDER BY SoLuongDaBan DESC
LIMIT 3;

-- Tìm sản phẩm bán chạy nhất tại cửa hàng có storeId = 'S001'.
SELECT p.productId, p.productName, SUM(od.quantityOrder) AS SoLuongBan FROM products AS p
JOIN order_details AS od ON p.productId = od.productId
JOIN orders AS o ON od.orderId = o.orderId
WHERE o.storeId = 'S001'
GROUP BY p.productId, p.productName
ORDER BY totalQuantitySold DESC
LIMIT 1;

-- Hiển thị danh sách tất cả các sản phẩm có giá trị tồn kho lớn hơn 1 triệu (giá * số lượng).
SELECT * FROM products
WHERE price * quantity > 1000000;

-- Tìm cửa hàng có tổng doanh thu cao nhất.
SELECT s.storeId, s.storeName, SUM(o.totalPrice) AS TongDoanhThu FROM stores AS s
JOIN orders AS o ON s.storeId = o.storeId
GROUP BY s.storeId, s.storeName
ORDER BY TongDoanhThu DESC
LIMIT 1;

-- Hiển thị danh sách người dùng và tổng số tiền họ đã chi tiêu.
SELECT u.userId, u.userName, SUM(o.totalPrice) AS TongChiTieu FROM users AS u
LEFT JOIN orders AS o ON u.userId = o.userId
GROUP BY u.userId, u.userName;

-- Tìm đơn hàng có tổng giá trị cao nhất và liệt kê thông tin chi tiết.
SELECT od.* FROM orders AS o
INNER JOIN order_details AS od ON od.orderId = o.orderid
ORDER BY totalPrice DESC
LIMIT 1;

-- Tính số lượng sản phẩm trung bình được bán ra trong mỗi đơn hàng.

-- Hiển thị tên sản phẩm và số lần sản phẩm đó được thêm vào giỏ hàng.
SELECT p.productName, SUM(c.quantityCart) AS totalAddedToCart
FROM products p
JOIN carts AS c ON p.productId = c.productId
GROUP BY p.productName;

-- Tìm tất cả các sản phẩm đã bán nhưng không còn tồn kho trong kho hàng.

-- Tìm các đơn hàng được thực hiện bởi người dùng có email là duong@gmail.com'.
SELECT o.* FROM orders AS o
JOIN users AS u ON o.userId = u.userId
WHERE u.email = 'duong@gmail.com';

-- Hiển thị danh sách các cửa hàng kèm theo tổng số lượng sản phẩm mà họ sở hữu.
SELECT s.storeId, s.storeName, SUM(p.quantity) AS TongSoLuongSanPham FROM stores AS s
LEFT JOIN products AS p ON s.storeId = p.storeId
GROUP BY s.storeId, s.storeName;

-- EX4:
-- View hiển thị tên sản phẩm (productName) và giá (price)
-- từ bảng products với giá trị giá (price) lớn hơn 500,000 có tên là expensive_products
CREATE VIEW expensive_products AS
SELECT productName, price
FROM products
WHERE price > 500.000;

-- Truy vấn dữ liệu từ view vừa tạo expensive_products
SELECT * FROM expensive_products;

-- Làm thế nào để cập nhật giá trị của view?
-- Ví dụ, cập nhật giá (price) thành 600,000 cho sản phẩm có tên Product A
-- trong view expensive_products.
UPDATE expensive_products
SET price = 600.000
WHERE productName = 'Loa Máy tính Để Bàn';

-- Làm thế nào để xóa view expensive_products?
DROP VIEW expensive_products;

--  Tạo một view hiển thị tên sản phẩm (productName),
-- tên danh mục (categoryName) bằng cách kết hợp bảng products và categories.
CREATE VIEW ProductName_CategoryName AS
SELECT p.productName, c.categoryName FROM products AS p
INNER JOIN categories AS c ON c.categoryId = p.categoryId;

-- EX5:
-- Làm thế tạo một index trên cột productName của bảng products?
CREATE INDEX idx_productName
ON products (productName);

-- Hiển thị danh sách các index trong cơ sở dữ liệu?
SHOW INDEX FROM products;

-- Trình bày cách xóa index idx_productName đã tạo trước đó?
DROP INDEX idx_productName ON products;

-- Tạo một procedure tên getProductByPrice để lấy danh sách sản phẩm
-- với giá lớn hơn một giá trị đầu vào (priceInput)?
DELIMITER $$
CREATE PROCEDURE getProductByPrice(IN priceInput DECIMAL(10, 2))
BEGIN
    SELECT * FROM products
    WHERE price > priceInput;
END $$
DELIMITER ;

-- Làm thế nào để gọi procedure getProductByPrice với đầu vào là 500000?
CALL getProductByPrice(500000);

-- Tạo một procedure getOrderDetails trả về thông tin chi tiết đơn hàng với đầu vào là orderId?
DELIMITER $$
CREATE PROCEDURE getOrderDetails(IN orderIdInput INT)
BEGIN
    SELECT * FROM order_details 
    WHERE orderId = orderIdInput;
END $$
DELIMITER ;

-- Làm thế nào để xóa procedure getOrderDetails?
DROP PROCEDURE getOrderDetails;

-- Tạo một procedure tên addNewProduct để thêm mới một sản phẩm vào bảng products. 
-- Các tham số gồm productName, price, description, và quantity.
DELIMITER $$
CREATE PROCEDURE addNewProduct(
    IN productName VARCHAR(255),
    IN price DECIMAL(10, 2),
    IN `description` TEXT,
    IN quantity INT
)
BEGIN
    INSERT INTO products (productName, price, `description`, quantity)
    VALUES (productName, price, `description`, quantity);
END $$
DELIMITER ;

-- Tạo một procedure tên deleteProductById để xóa sản phẩm
-- khỏi bảng products dựa trên tham số productId.
DELIMITER $$
CREATE PROCEDURE deleteProductById(
    IN productIdInput INT
)
BEGIN
    DELETE FROM products
    WHERE productId = productIdInput;
END $$
DELIMITER ;

-- Tạo một procedure tên searchProductByName để tìm kiếm sản phẩm theo tên (tìm kiếm gần đúng)
-- từ bảng products.


-- Tạo một procedure tên filterProductsByPriceRange để lấy danh sách sản phẩm
-- có giá trong khoảng từ minPrice đến maxPrice.

-- Tạo một procedure tên paginateProducts để phân trang danh sách sản phẩm,
-- với hai tham số pageNumber và pageSize.
DELIMITER $$
CREATE PROCEDURE paginateProducts(IN page_size INT, IN page_number INT)
BEGIN
	DECLARE offset_value INT;
    SET offset_value = page_size*(page_number-1);
	SELECT * FROM Employees
	LIMIT page_size
	OFFSET offset_value;
END$$
DELIMITER ;







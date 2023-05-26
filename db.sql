DROP TABLE wallet;
DROP TABLE product_order;
DROP TABLE orders;
DROP TABLE products;
DROP TABLE users;
DROP TABLE categories;
ALTER TABLE product_order DROP CONSTRAINT fk_product_id;
ALTER TABLE product_order DROP CONSTRAINT fk_order_id;

ALTER TABLE products DROP CONSTRAINT fk_category_id;

ALTER TABLE orders DROP CONSTRAINT fk_user_id;

ALTER TABLE wallet DROP CONSTRAINT fk_user_wallet_id;

CREATE TABLE categories (
    id VARCHAR2(255) PRIMARY KEY,
    name VARCHAR2(255)
);

CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    username VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    password VARCHAR2(255) NOT NULL
);

CREATE TABLE products (
    id VARCHAR2(50) PRIMARY KEY,
    name VARCHAR2(255),
    category_id VARCHAR2(255),
    descriptions VARCHAR2(255),
    details VARCHAR2(255),
    gender VARCHAR2(50),
    highlights VARCHAR2(255),
    imageName VARCHAR2(255),
    price DECIMAL(10, 2),
    quantity INT,
    sizes VARCHAR2(255),
    CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE orders (
    id NUMBER PRIMARY KEY,
    addressNumber VARCHAR2(255),
    ward VARCHAR2(255),
    district VARCHAR2(255),
    province VARCHAR2(255),
    checkoutId VARCHAR2(255),
    email VARCHAR2(255),
    name VARCHAR2(255),
    user_id NUMBER,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE product_order (
    product_id VARCHAR2(50),
    order_id NUMBER,
    quantity NUMBER,
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(id),
    PRIMARY KEY (product_id, order_id,quantity)
);

CREATE TABLE wallet (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    balance NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_user_wallet_id FOREIGN KEY (user_id) REFERENCES users(id)
);

-- KHI MUA NHIỀU HƠN SỐ LƯỢNG TỒN KHO
CREATE OR REPLACE TRIGGER check_product_quantity
BEFORE INSERT ON product_order
FOR EACH ROW
DECLARE
    v_product_quantity NUMBER;
    v_over_quantity NUMBER;
BEGIN
    -- Lấy số lượng hiện có của sản phẩm
    SELECT quantity INTO v_product_quantity
    FROM products
    WHERE id = :NEW.product_id;

    -- Kiểm tra nếu số lượng mua lớn hơn số lượng hiện có
    IF :NEW.quantity > v_product_quantity THEN
        v_over_quantity:= :NEW.quantity- v_product_quantity;
        -- Gây ra một lỗi và ngăn chặn việc thêm bản ghi vào bảng product_order
        RAISE_APPLICATION_ERROR(-20001, 'Số lượng mua vượt quá '|| v_over_quantity ||' sản phẩm.');
    END IF;

      -- Giảm số lượng tồn kho sau khi mua hàng
    v_product_quantity := v_product_quantity - :NEW.quantity ;

    -- Cập nhật số lượng tồn kho mới vào bảng products
    UPDATE products
    SET quantity = v_product_quantity
    WHERE id = :NEW.product_id;
END;
/

-- TEST TRIGGER
-- Thêm dữ liệu vào bảng products
INSERT INTO products (id, name, category_id, quantity)
VALUES ('P1', 'Product 1', 'C1', 5);

-- Thêm dữ liệu vào bảng orders
INSERT INTO orders (id, user_id)
VALUES (1, 1);

-- Thêm dữ liệu vào bảng product_order với số lượng mua hợp lệ
INSERT INTO product_order (product_id, order_id, quantity)
VALUES ('P1', 1, 3);

-- Thêm dữ liệu vào bảng product_order với số lượng mua vượt quá số lượng hiện có
INSERT INTO product_order (product_id, order_id, quantity)
VALUES ('P1', 1, 7);


INSERT INTO categories (id, name) VALUES
('1', 'Thời trang nam');
INSERT INTO categories (id, name) VALUES
('2', 'Thời trang nữ');
INSERT INTO categories (id, name) VALUES
('3', 'Giày dép');
INSERT INTO categories (id, name) VALUES
('4', 'Phụ kiện');

INSERT INTO users (id, username, email, password) VALUES
(1, 'nguyenvanA', 'nguyenvanA@example.com', 'passwordA');
INSERT INTO users (id, username, email, password) VALUES
(2, 'lethiB', 'lethiB@example.com', 'passwordB');
INSERT INTO users (id, username, email, password) VALUES
(3, 'phamvanc', 'phamvanc@example.com', 'passwordC');
INSERT INTO users (id, username, email, password) VALUES
(4, 'tranthid', 'tranthid@example.com', 'passwordD');
INSERT INTO users (id, username, email, password) VALUES
(5, 'hoangvane', 'hoangvane@example.com', 'passwordE');

INSERT INTO products (id, name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
('P1', 'Áo sơ mi nam', '1', 'Áo sơ mi nam cao cấp', 'Áo sơ mi nam màu trắng, kiểu dáng thời trang', 'Nam', 'Chất liệu cotton, thoáng mát', 'image1.jpg', 29.99, 50, 'S,M,L,XL');
INSERT INTO products (id, name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
('P2', 'Áo thun nam', '1', 'Áo thun nam hàng ngày', 'Áo thun nam màu đen, phong cách trẻ trung', 'Nam', 'Chất liệu cotton, dễ dàng phối đồ', 'image2.jpg', 19.99, 100, 'S,M,L,XL');
INSERT INTO products (id, name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
('P3', 'Đầm công sở', '2', 'Đầm công sở dáng suông', 'Đầm công sở màu xanh navy, phù hợp với công việc', 'Nữ', 'Chất liệu polyester, không nhăn', 'image3.jpg', 39.99, 30, 'S,M,L');
INSERT INTO products (id, name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
('P4', 'Áo khoác nữ', '2', 'Áo khoác nữ dạ dày', 'Áo khoác nữ dạ dày màu đen, ấm áp', 'Nữ', 'Chất liệu dạ, lót lông cừu', 'image4.jpg', 49.99, 20, 'S,M,L,XL');
INSERT INTO products (id, name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
('P5', 'Giày thể thao nam', '3', 'Giày thể thao nam cao cấp', 'Giày thể thao nam màu trắng, êm ái', 'Nam', 'Đế cao su chống trơn trượt', 'image5.jpg', 59.99, 10, '40,41,42,43');

INSERT INTO orders (id, addressNumber, ward, district, province, checkoutId, email, name, user_id) VALUES
(1, '123 ABC Street', 'Ward 1', 'District A', 'Province X', 'CHK123', 'nguyenvanA@example.com', 'Nguyen Van A', 1);
INSERT INTO orders (id, addressNumber, ward, district, province, checkoutId, email, name, user_id) VALUES
(2, '456 XYZ Street', 'Ward 2', 'District B', 'Province Y', 'CHK456', 'lethiB@example.com', 'Le Thi B', 2);
INSERT INTO orders (id, addressNumber, ward, district, province, checkoutId, email, name, user_id) VALUES
(3, '789 DEF Street', 'Ward 3', 'District C', 'Province Z', 'CHK789', 'phamvanc@example.com', 'Pham Van C', 3);
INSERT INTO orders (id, addressNumber, ward, district, province, checkoutId, email, name, user_id) VALUES
(4, '321 GHI Street', 'Ward 4', 'District D', 'Province W', 'CHK321', 'tranthid@example.com', 'Tran Thi D', 4);
INSERT INTO orders (id, addressNumber, ward, district, province, checkoutId, email, name, user_id) VALUES
(5, '654 JKL Street', 'Ward 5', 'District E', 'Province V', 'CHK654', 'hoangvane@example.com', 'Hoang Van E', 5);

INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P1', 1,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P2', 1,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P3', 2,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P4', 2,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P5', 3,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P6', 4,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P1', 5,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P3', 5,1);
INSERT INTO product_order (product_id, order_id,quantity) VALUES
('P5', 5,1);

INSERT INTO wallet (id, user_id, balance) VALUES
(1, 1, 1000.00);
INSERT INTO wallet (id, user_id, balance) VALUES
(2, 2, 500.50);
INSERT INTO wallet (id, user_id, balance) VALUES
(3, 3, 250.75);
INSERT INTO wallet (id, user_id, balance) VALUES
(4, 4, 100.25);
INSERT INTO wallet (id, user_id, balance) VALUES
(5, 5, 50.50);


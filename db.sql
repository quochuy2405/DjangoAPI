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
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255)
);

CREATE TABLE users (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    password VARCHAR2(255) NOT NULL
);

CREATE TABLE products (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255),
    category_id NUMBER,
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
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
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
    product_id NUMBER,
    order_id NUMBER,
    quantity NUMBER,
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(id),
    PRIMARY KEY (product_id, order_id)
);

CREATE TABLE wallet (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id NUMBER NOT NULL,
    balance NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_user_wallet_id FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Procedure
CREATE OR REPLACE PROCEDURE DeductMoneyFromWallet(
    p_user_id IN NUMBER,
    p_amount IN NUMBER
) AS
    v_balance NUMBER(10, 2);
BEGIN
    -- Lấy số dư trong ví của người dùng
    SELECT balance INTO v_balance
    FROM wallet
    WHERE user_id = p_user_id;

    -- Kiểm tra xem số dư có đủ để trừ hay không
    IF v_balance >= p_amount THEN
        -- Trừ số tiền từ số dư trong ví
        UPDATE wallet
        SET balance = balance - p_amount
        WHERE user_id = p_user_id;

        COMMIT;
    ELSE
        -- Ném ra một lỗi nếu số dư không đủ
        RAISE_APPLICATION_ERROR(-20001, 'Số dư trong ví không đủ để thực hiện giao dịch.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Ném ra một lỗi nếu người dùng không có ví
        RAISE_APPLICATION_ERROR(-20002, 'Người dùng không có ví.');
    WHEN OTHERS THEN
        -- Ném ra một lỗi khác nếu có lỗi không xác định
        RAISE_APPLICATION_ERROR(-20003, 'Đã xảy ra lỗi khi trừ tiền từ ví.');
END;
/


-- TEST TRIGGER
INSERT INTO categories ( name) VALUES
( 'Thời trang nam');
INSERT INTO categories ( name) VALUES
( 'Thời trang nữ');
INSERT INTO categories ( name) VALUES
( 'Giày dép');
INSERT INTO categories ( name) VALUES
( 'Phụ kiện');

INSERT INTO users ( username, email, password) VALUES
( 'nguyenvanA', 'nguyenvanA@example.com', 'passwordA');
INSERT INTO users ( username, email, password) VALUES
( 'lethiB', 'lethiB@example.com', 'passwordB');
INSERT INTO users ( username, email, password) VALUES
( 'phamvanc', 'phamvanc@example.com', 'passwordC');
INSERT INTO users ( username, email, password) VALUES
( 'tranthid', 'tranthid@example.com', 'passwordD');
INSERT INTO users ( username, email, password) VALUES
( 'hoangvane', 'hoangvane@example.com', 'passwordE');


INSERT INTO wallet ( user_id, balance) VALUES
( 1, 1000.00);
INSERT INTO wallet ( user_id, balance) VALUES
( 2, 500.50);
INSERT INTO wallet ( user_id, balance) VALUES
( 3, 250.75);
INSERT INTO wallet ( user_id, balance) VALUES
( 4, 100.25);
INSERT INTO wallet ( user_id, balance) VALUES
( 5, 50.50);

INSERT INTO products ( name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
( 'Áo sơ mi nam', 1, 'Áo sơ mi nam cao cấp', 'Áo sơ mi nam màu trắng, kiểu dáng thời trang', 'Nam', 'Chất liệu cotton, thoáng mát', 'image1.jpg', 29.99, 50, 'S,M,L,XL');
INSERT INTO products ( name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
( 'Áo thun nam', 1, 'Áo thun nam hàng ngày', 'Áo thun nam màu đen, phong cách trẻ trung', 'Nam', 'Chất liệu cotton, dễ dàng phối đồ', 'image2.jpg', 19.99, 100, 'S,M,L,XL');
INSERT INTO products ( name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
( 'Đầm công sở', 2, 'Đầm công sở dáng suông', 'Đầm công sở màu xanh navy, phù hợp với công việc', 'Nữ', 'Chất liệu polyester, không nhăn', 'image3.jpg', 39.99, 30, 'S,M,L');
INSERT INTO products ( name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
( 'Áo khoác nữ', 2, 'Áo khoác nữ dạ dày', 'Áo khoác nữ dạ dày màu đen, ấm áp', 'Nữ', 'Chất liệu dạ, lót lông cừu', 'image4.jpg', 49.99, 20, 'S,M,L,XL');
INSERT INTO products ( name, category_id, descriptions, details, gender, highlights, imageName, price, quantity, sizes) VALUES
( 'Giày thể thao nam', 3, 'Giày thể thao nam cao cấp', 'Giày thể thao nam màu trắng, êm ái', 'Nam', 'Đế cao su chống trơn trượt', 'image5.jpg', 59.99, 10, '40,41,42,43');


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



INSERT INTO orders (addressNumber, ward, district, province, checkoutId, email, name, user_id)
values ( '123', 'C Ward', 'XYZ District', 'PQR', '45','lethiB@example.com', 'ohnDoe', 2);




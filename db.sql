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
    id   NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    name NVARCHAR2(255)
);

CREATE TABLE users (
    id       NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    username NVARCHAR2(255) NOT NULL,
    email    NVARCHAR2(255) NOT NULL,
    password NVARCHAR2(255) NOT NULL
);

CREATE TABLE products (
    id           NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    name         NVARCHAR2(255),
    category_id  NUMBER,
    descriptions NVARCHAR2(255),
    details      NVARCHAR2(255),
    gender       NVARCHAR2(50),
    highlights   NVARCHAR2(255),
    imagename    NVARCHAR2(255),
    price        DECIMAL(10, 2),
    quantity     INT,
    sizes        NVARCHAR2(255),
    CONSTRAINT fk_category_id FOREIGN KEY ( category_id )
        REFERENCES categories ( id )
);

CREATE TABLE orders (
    id            NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    addressnumber NVARCHAR2(255),
    ward          NVARCHAR2(255),
    district      NVARCHAR2(255),
    province      NVARCHAR2(255),
    checkoutid    NVARCHAR2(255),
    email         NVARCHAR2(255),
    paymentMethods         NVARCHAR2(255),
    status         NVARCHAR2(255),
    name          NVARCHAR2(255),
    user_id       NUMBER,
    CONSTRAINT fk_user_id FOREIGN KEY ( user_id )
        REFERENCES users ( id )
);

CREATE TABLE product_order (
    product_id NUMBER,
    order_id   NUMBER,
    quantity   NUMBER,
    CONSTRAINT fk_product_id FOREIGN KEY ( product_id )
        REFERENCES products ( id ),
    CONSTRAINT fk_order_id FOREIGN KEY ( order_id )
        REFERENCES orders ( id ),
    PRIMARY KEY ( product_id,
                  order_id )
);

CREATE TABLE wallet (
    id      NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    user_id NUMBER NOT NULL,
    balance NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_user_wallet_id FOREIGN KEY ( user_id )
        REFERENCES users ( id )
);

-- Procedure
CREATE OR REPLACE PROCEDURE deductmoneyfromwallet (
    p_user_id IN NUMBER,
    p_amount  IN NUMBER
) AS
    v_balance NUMBER(10, 2);
BEGIN
-- Lấy số dư trong ví của người dùng
    SELECT
        balance
    INTO v_balance
    FROM
        wallet
    WHERE
        user_id = p_user_id;
    -- Kiểm tra xem số dư có đủ để trừ hay không
    IF v_balance >= p_amount THEN
        -- Trừ số tiền từ số dư trong ví
        UPDATE wallet
        SET
            balance = balance - p_amount
        WHERE
            user_id = p_user_id;

        COMMIT;
    ELSE
        -- Ném ra một lỗi nếu số dư không đủ để thực hiện giao dịch
        raise_application_error(-20001, 'Số dư trong ví không đủ để thực hiện giao dịch.');
    END IF;

EXCEPTION
    WHEN no_data_found THEN
-- Ném ra một lỗi nếu người dùng không có ví
        raise_application_error(-20002, 'Người dùng không có ví.');
    WHEN OTHERS THEN
-- Ném ra một lỗi khác nếu có lỗi không xác định
        raise_application_error(-20003, 'Đã xảy ra lỗi khi trừ tiền từ ví.');
END;
/

-- TEST TRIGGER
INSERT INTO categories ( name ) VALUES ( 'Thời trang nam' );

INSERT INTO categories ( name ) VALUES ( 'Thời trang nữ' );

INSERT INTO categories ( name ) VALUES ( 'Giày dép' );

INSERT INTO categories ( name ) VALUES ( 'Phụ kiện' );

INSERT INTO users (
    username,
    email,
    password
) VALUES (
    'nguyenvanA',
    'nguyenvanA@example.com',
    'passwordA'
);

INSERT INTO users (
    username,
    email,
    password
) VALUES (
    'lethiB',
    'lethiB@example.com',
    'passwordB'
);

INSERT INTO users (
    username,
    email,
    password
) VALUES (
    'phamvanc',
    'phamvanc@example.com',
    'passwordC'
);

INSERT INTO users (
    username,
    email,
    password
) VALUES (
    'tranthid',
    'tranthid@example.com',
    'passwordD'
);

INSERT INTO users (
    username,
    email,
    password
) VALUES (
    'hoangvane',
    'hoangvane@example.com',
    'passwordE'
);

INSERT INTO wallet (
    user_id,
    balance
) VALUES (
    1,
    1000000.00
);

INSERT INTO wallet (
    user_id,
    balance
) VALUES (
    2,
    500.50
);

INSERT INTO wallet (
    user_id,
    balance
) VALUES (
    3,
    250.75
);

INSERT INTO wallet (
    user_id,
    balance
) VALUES (
    4,
    100.25
);

INSERT INTO wallet (
    user_id,
    balance
) VALUES (
    5,
    50.50
);

INSERT INTO products (
    name,
    category_id,
    descriptions,
    details,
    gender,
    highlights,
    imagename,
    price,
    quantity,
    sizes
) VALUES (
    'Áo sơ mi nam',
    1,
    'Áo sơ mi nam cao cấp',
    'Áo sơ mi nam màu trắng, kiểu dáng thời trang',
    'Nam',
    'Chất liệu cotton, thoáng mát',
    'ao_so_mi',
    29.99,
    50,
    'S,M,L,XL'
);

INSERT INTO products (
    name,
    category_id,
    descriptions,
    details,
    gender,
    highlights,
    imagename,
    price,
    quantity,
    sizes
) VALUES (
    'Áo thun nam',
    1,
    'Áo thun nam hàng ngày',
    'Áo thun nam màu đen, phong cách trẻ trung',
    'Nam',
    'Chất liệu cotton, dễ dàng phối đồ',
    'ao_thun',
    19.99,
    100,
    'S,M,L,XL'
);

INSERT INTO products (
    name,
    category_id,
    descriptions,
    details,
    gender,
    highlights,
    imagename,
    price,
    quantity,
    sizes
) VALUES (
    'Đầm công sở',
    2,
    'Đầm công sở dáng suông',
    'Đầm công sở màu xanh navy, phù hợp với công việc',
    'Nữ',
    'Chất liệu polyester, không nhăn',
    'dam',
    39.99,
    30,
    'S,M,L'
);

INSERT INTO products (
    name,
    category_id,
    descriptions,
    details,
    gender,
    highlights,
    imagename,
    price,
    quantity,
    sizes
) VALUES (
    'Áo khoác nữ',
    2,
    'Áo khoác nữ dày',
    'Áo khoác nữ dày màu đen, ấm áp',
    'Nữ',
    'Chất liệu dù, lót lông cừu',
    'ao_khoac',
    49.99,
    20,
    'S,M,L,XL'
);

INSERT INTO products (
    name,
    category_id,
    descriptions,
    details,
    gender,
    highlights,
    imagename,
    price,
    quantity,
    sizes
) VALUES (
    'Giày thể thao nam',
    3,
    'Giày thể thao nam cao cấp',
    'Giày thể thao nam màu trắng, êm ái',
    'Nam',
    'Đế cao su chống trơn trượt',
    'giay',
    59.99,
    10,
    '40,41,42,43'
);

-- KHI MUA NHIỀU HƠN SỐ LƯỢNG TỒN KHO
CREATE OR REPLACE TRIGGER check_product_quantity BEFORE
    INSERT ON product_order
    FOR EACH ROW
DECLARE
    v_product_quantity NUMBER;
    v_over_quantity    NUMBER;
    v_product_name     products.name%TYPE;
BEGIN
-- Lấy số lượng hiện có của sản phẩm
    SELECT
        name,
        quantity
    INTO
        v_product_name,
        v_product_quantity
    FROM
        products
    WHERE
        id = :new.product_id;
-- Kiểm tra nếu số lượng mua lớn hơn số lượng hiện có
    IF :new.quantity > v_product_quantity THEN
        v_over_quantity := :new.quantity - v_product_quantity;
    -- Gây ra một lỗi và ngăn chặn việc thêm bản ghi vào bảng product_order
        raise_application_error(-20001, 'Hiện tại sản phẩm '
                                        || v_product_name
                                        || ' chỉ còn '
                                        || v_product_quantity
                                        || '. Bạn cần giảm tối thiểu '
                                        || v_over_quantity
                                        || ' đơn vị.');

    END IF;

  -- Giảm số lượng tồn kho sau khi mua hàng
    v_product_quantity := v_product_quantity - :new.quantity;

-- Cập nhật số lượng tồn kho mới vào bảng products
    UPDATE products
    SET
        quantity = v_product_quantity
    WHERE
        id = :new.product_id;

END;
/

-- KHI MUA NHIỀU HƠN SỐ LƯỢNG TỒN KHO
CREATE OR REPLACE PROCEDURE check_product_quantity_procedure (
    pro_id   products.id%TYPE,
    quantity products.quantity%TYPE
) AS
    v_product_quantity NUMBER;
    v_over_quantity    NUMBER;
    v_product_name     products.name%TYPE;
BEGIN
-- Lấy số lượng hiện có của sản phẩm
    SELECT
        name,
        quantity
    INTO
        v_product_name,
        v_product_quantity
    FROM
        products
    WHERE
        id = pro_id;
-- Kiểm tra nếu số lượng mua lớn hơn số lượng hiện có
    IF quantity > v_product_quantity THEN
        v_over_quantity := quantity - v_product_quantity;
    -- Gây ra một lỗi và ngăn chặn việc thêm bản ghi vào bảng product_order
        raise_application_error(-20001, 'Hiện tại sản phẩm '
                                        || v_product_name
                                        || ' chỉ còn '
                                        || v_product_quantity
                                        || '. Bạn cần giảm tối thiểu '
                                        || v_over_quantity
                                        || ' đơn vị.');

    END IF;

END;
/
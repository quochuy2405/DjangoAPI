CREATE TABLE products (
    id VARCHAR2(50) PRIMARY KEY,
    name VARCHAR2(255),
    category_code VARCHAR2(255),
    descriptions VARCHAR2(255),
    details VARCHAR2(255),
    gender VARCHAR2(50),
    highlights VARCHAR2(255),
    imageName VARCHAR2(255),
    price NUMBER(10, 2),
    quantity NUMBER,
    size VARCHAR2(255),
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
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(id),
    PRIMARY KEY (product_id, order_id)
);

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

CREATE TABLE wallet (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    balance NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

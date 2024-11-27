CREATE DATABASE shopapp;

Use shopapp;
-- AUTO_INCREMENT tự động tăng
CREATE TABLE users(
    id INT PRIMARY KEY AUTO_INCREMENT, 
    fullname VARCHAR(100) DEFAULT '',
    phone_number VARCHAR(10) NOT NULL,
    address VARCHAR(200) DEFAULT '',
    password VARCHAR(100) NOT NULL DEFAULT '', 
    created_at DATETIME,
    updated_at DATETIME,
    is_active TINYINT(1) DEFAULT 1, 
    date_of_birth DATE,
    facebook_account_id INT DEFAULT 0,
    google_account_id INT DEFAULT 0,
    role_id int DEFAULT '1',
    email varchar(255) DEFAULT '',
    profile_image varchar(255) DEFAULT ''
);
-- role
ALTER TABLE users ADD COLUMN role_id INT;
CREATE TABLE roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);
ALTER TABLE users ADD FOREIGN KEY (role_id) REFERENCES roles(id)
-- 
CREATE TABLE tokens(
    id INT PRIMARY KEY AUTO_INCREMENT,
    token VARCHAR(255) UNIQUE NOT NULL,
    token_type VARCHAR(50) NOT NULL,
    expiration_date DATETIME,
    revoked TINYINT(1) NOT NULL,
    expire TINYINT(1) NOT NULL,
    refresh_token varchar(255) DEFAULT '',
    refresh_expiration_date datetime DEFAULT NULL
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- hỗ trợ đăng nhập từ facebook và google
CREATE TABLE socical_accounts(
    id INT PRIMARY KEY AUTO_INCREMENT,
    provider VARCHAR(20) NOT NULL COMMENT 'Tên nhà social networks',
    provider_id VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL COMMENT 'Tên tài khoản',
    name VARCHAR(100) NOT NULL COMMENT 'Tên người dùng',
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Danh mục sản phẩm (Cagetory)
CREATE TABLE categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL DEFAULT'' COMMENT 'Tên danh mục, vd:Đồ điện tử'
);

-- Bảng chứa sản phẩm(product)
CREATE TABLE products(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(350) NOT NULL DEFAULT '' COMMENT 'Tên sản phẩm',
    price FLOAT NOT NULL CHECK(price >= 0),
    thumbnail VARCHAR(255) DEFAULT'',
    description LONGTEXT DEFAULT '',
    created_at DATETIME,
    updated_at DATETIME,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Đặt hàng- order
CREATE TABLE orders (
  id int PRIMARY KEY AUTO_INCREMENT,
  user_id int DEFAULT NULL,
  fullname varchar(100) DEFAULT '',
  email varchar(100) DEFAULT '',
  phone_number varchar(20) NOT NULL,
  address varchar(200) NOT NULL,
  note varchar(100) DEFAULT '',
  order_date datetime DEFAULT CURRENT_TIMESTAMP,
  status enum('pending','processing','shipped','delivered','cancelled') DEFAULT NULL COMMENT 'Trạng thái đơn hàng',
  total_money float DEFAULT NULL,
  active tinyint(1) DEFAULT NULL,
  coupon_id int DEFAULT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (coupon_id) REFERENCES coupons(id)
);

ALTER TABLE orders ADD COLUMN shipping_method VARCHAR(100);
ALTER TABLE orders ADD COLUMN shipping_address VARCHAR(200);
ALTER TABLE orders ADD COLUMN shipping_date DATE;
ALTER TABLE orders ADD COLUMN tracking_number VARCHAR(100);
ALTER TABLE orders ADD COLUMN payment_method VARCHAR(100);
-- Xóa 1 đơn hàng - Xóa mềm
ALTER TABLE orders ADD COLUMN active TINYINT(1);
-- Trạng thái đơn hàng chỉ được nhận "1 giá trị cụ thể"
ALTER TABLE orders MODIFY COLUMN status ENUM('pending', 'processing', 'shipped', 'delivered', 'canceled')
COMMENT 'Trạng thái đơn hàng';

CREATE TABLE order_details(
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    price FLOAT CHECK(price >= 0),
    number_of_products INT CHECK(number_of_products > 0),
    total_money FLOAT CHECK(total_money >= 0),
    color VARCHAR(20) DEFAULT'',
    coupon_id int DEFAULT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE product_images(
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT fk_product_image_product_id
    FOREIGN KEY (product_id) REFERENCES products(id) on DELETE CASCADE
)

CREATE TABLE comments (
  id int PRIMARY KEY AUTO_INCREMENT,
  product_id int DEFAULT NULL,
  user_id int DEFAULT NULL,
  content varchar(255) DEFAULT NULL,
  created_at datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL
) 



CREATE TABLE coupons (
  id int PRIMARY KEY AUTO_INCREMENT,
  code varchar(50) NOT NULL,
  active tinyint(1) NOT NULL DEFAULT '1'
)

CREATE TABLE favorites (
  id int PRIMARY KEY AUTO_INCREMENT,
  user_id int DEFAULT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  product_id int DEFAULT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
)

CREATE TABLE flyway_schema_history (
  installed_rank int PRIMARY KEY AUTO_INCREMENT,
  version varchar(50) DEFAULT NULL,
  description varchar(200) NOT NULL,
  type varchar(20) NOT NULL,
  script varchar(1000) NOT NULL,
  checksum int DEFAULT NULL,
  installed_by varchar(100) NOT NULL,
  installed_on timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  execution_time int NOT NULL,
  success tinyint(1) NOT NULL
)

CREATE TABLE coupon_conditions (
  id int PRIMARY KEY AUTO_INCREMENT,
  attribute varchar(255) NOT NULL,
  operator varchar(10) NOT NULL,
  value varchar(255) NOT NULL,
  discount_amount decimal(5,2) NOT NULL,
  coupon_id int NOT NULL,
  FOREIGN KEY (coupon_id) REFERENCES coupons(id)
)

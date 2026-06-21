CREATE DATABASE fishproductstore
GO

USE fishproductstore;
GO

CREATE TABLE role (
    ID_role INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL
);
GO

CREATE TABLE order_status (
    ID_status INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
GO

CREATE TABLE delivery_method (
    ID_delevery INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
GO

CREATE TABLE category (
    ID_category INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_category_ID INT,
    FOREIGN KEY (parent_category_ID) REFERENCES category(ID_category)
);
GO

CREATE TABLE account (
    ID_account INT IDENTITY(1,1) PRIMARY KEY,
    role_ID INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hasg VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    shop_address VARCHAR(200),
    FOREIGN KEY (role_ID) REFERENCES role(ID_role)
);
GO

CREATE TABLE seller_profile (
    ID_seller INT IDENTITY(1,1) PRIMARY KEY,
    account_ID INT NOT NULL,
    shop_name VARCHAR(150) NOT NULL,
    shop_description NVARCHAR(MAX),
    shop_phone INT,
    shop_address VARCHAR(200),
    FOREIGN KEY (account_ID) REFERENCES account(ID_account)
);
GO

CREATE TABLE notification (
    ID_notification INT IDENTITY(1,1) PRIMARY KEY,
    account_ID INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    message NVARCHAR(MAX),
    is_read BIT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (account_ID) REFERENCES account(ID_account)
);
GO

CREATE TABLE client_address (
    ID_address INT IDENTITY(1,1) PRIMARY KEY,
    client_ID INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    comment VARCHAR(255),
    FOREIGN KEY (client_ID) REFERENCES account(ID_account)
);
GO

CREATE TABLE cart (
    ID_cart INT IDENTITY(1,1) PRIMARY KEY,
    client_ID INT NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (client_ID) REFERENCES account(ID_account)
);
GO

CREATE TABLE product (
    ID_product INT IDENTITY(1,1) PRIMARY KEY,
    category_ID INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    stock_qty INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    is_active BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (category_ID) REFERENCES category(ID_category)
);
GO

CREATE TABLE product_image (
    ID_image INT IDENTITY(1,1) PRIMARY KEY,
    product_ID INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    FOREIGN KEY (product_ID) REFERENCES product(ID_product)
);
GO

CREATE TABLE review (
    ID_review INT IDENTITY(1,1) PRIMARY KEY,
    product_ID INT NOT NULL,
    client_ID INT NOT NULL,
    rating INT NOT NULL,
    comment NVARCHAR(MAX),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (product_ID) REFERENCES product(ID_product),
    FOREIGN KEY (client_ID) REFERENCES account(ID_account)
);
GO

CREATE TABLE cart_item (
    ID_cartitem INT IDENTITY(1,1) PRIMARY KEY,
    cart_ID INT NOT NULL,
    product_ID INT NOT NULL,
    qty INT NOT NULL,
    FOREIGN KEY (cart_ID) REFERENCES cart(ID_cart),
    FOREIGN KEY (product_ID) REFERENCES product(ID_product)
);
GO

CREATE TABLE [order] (
    ID_order INT IDENTITY(1,1) PRIMARY KEY,
    client_ID INT NOT NULL,
    delivery_ID INT NOT NULL,
    address_ID INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    status_ID INT NOT NULL,
    FOREIGN KEY (client_ID) REFERENCES account(ID_account),
    FOREIGN KEY (delivery_ID) REFERENCES delivery_method(ID_delevery),
    FOREIGN KEY (address_ID) REFERENCES client_address(ID_address),
    FOREIGN KEY (status_ID) REFERENCES order_status(ID_status)
);
GO

CREATE TABLE order_item (
    ID_orderitem INT IDENTITY(1,1) PRIMARY KEY,
    order_ID INT NOT NULL,
    product_ID INT NOT NULL,
    qty INT NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_ID) REFERENCES [order](ID_order),
    FOREIGN KEY (product_ID) REFERENCES product(ID_product)
);
GO

CREATE TABLE order_status_history (
    ID_history INT IDENTITY(1,1) PRIMARY KEY,
    order_ID INT NOT NULL,
    status_ID INT NOT NULL,
    changed_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (order_ID) REFERENCES [order](ID_order),
    FOREIGN KEY (status_ID) REFERENCES order_status(ID_status)
);
GO

CREATE TABLE favorite (
    ID_favorite INT IDENTITY(1,1) PRIMARY KEY,
    client_ID INT NOT NULL,
    product_ID INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (client_ID) REFERENCES account(ID_account),
    FOREIGN KEY (product_ID) REFERENCES product(ID_product)
);
GO

INSERT INTO role (role_name) VALUES
('buyer'),
('seller');
GO


INSERT INTO order_status (name) VALUES
('Оформлен'),
('Принят'),
('Отправлен'),
('Доставлен'),
('Отменён');
GO


INSERT INTO delivery_method (name) VALUES
('Курьер'),
('Самовывоз'),
('Почта России');
GO

INSERT INTO category (name, parent_category_ID) VALUES
('Удилища', NULL),
('Катушки', NULL),
('Леска и шнуры', NULL),
('Приманки', NULL),
('Крючки', NULL),
('Поплавки', NULL),
('Грузила', NULL),
('Аксессуары', NULL),
('Спиннинги', 1),
('Фидерные удилища', 1),
('Безынерционные катушки', 2),
('Воблеры', 4),
('Блесны', 4),
('Силиконовые приманки', 4);
GO


INSERT INTO account (role_ID, email, password_hasg, full_name, shop_address) VALUES
(2, 'seller@vobler.ru', 'hash_seller_123', 'ИП Смирнов Сергей Андреевич', 'г. Казань, ул. Рыболовная, д. 12'),
(1, 'ivanov@mail.ru', 'hash_buyer_001', 'Иванов Иван Иванович', NULL),
(1, 'petrova@mail.ru', 'hash_buyer_002', 'Петрова Анна Сергеевна', NULL),
(1, 'sidorov@mail.ru', 'hash_buyer_003', 'Сидоров Алексей Павлович', NULL);
GO


INSERT INTO seller_profile (account_ID, shop_name, shop_description, shop_phone, shop_address) VALUES
(1, 'Воблер', 'Магазин рыболовных товаров: удилища, катушки, приманки, леска и аксессуары для рыбалки.', '89001234567', 'г. Казань, ул. Рыболовная, д. 12');
GO


INSERT INTO client_address (client_ID, address_line, comment) VALUES
(2, 'г. Казань, ул. Чистопольская, д. 25, кв. 14', 'Дом'),
(3, 'г. Набережные Челны, пр. Мира, д. 18, кв. 56', 'Дом'),
(4, 'г. Альметьевск, ул. Ленина, д. 44', 'Частный дом');
GO


INSERT INTO product (category_ID, title, description, price, stock_qty) VALUES
(9,  'Спиннинг MaxFish River Pro 2.4 м', 'Лёгкий спиннинг для ловли на воблеры и блёсны.', 4590.00, 15),
(11, 'Катушка Storm Reel 3000', 'Безынерционная катушка для спиннинговой ловли.', 3890.00, 20),
(12, 'Воблер Minnow Strike 90SP', 'Воблер-суспендер для ловли щуки и окуня.', 750.00, 40),
(13, 'Блесна Silver Pike 14 г', 'Колеблющаяся блесна для щуки.', 420.00, 35),
(3,  'Плетёный шнур StrongLine 0.12 мм', 'Прочный плетёный шнур для спиннинга.', 990.00, 50),
(5,  'Набор офсетных крючков Hook Master №2/0', 'Набор крючков для силиконовых приманок.', 310.00, 60),
(14, 'Силиконовая приманка Easy Shad 3.5"', 'Мягкая приманка для судака и щуки.', 290.00, 80),
(10, 'Фидерное удилище Feeder Expert 3.6 м', 'Удилище для донной ловли.', 5250.00, 10),
(8,  'Рыболовный ящик Box Pro', 'Ящик для хранения снастей и приманок.', 2750.00, 12),
(6,  'Поплавок Classic 4 г', 'Поплавок для поплавочной ловли.', 120.00, 100);
GO


INSERT INTO product_image (product_ID, image_url, sort_order) VALUES
(1, 'images/spinning_maxfish_river_pro.jpg', 1),
(2, 'images/reel_storm_3000.jpg', 1),
(3, 'images/wobbler_minnow_strike_90sp.jpg', 1),
(4, 'images/spoon_silver_pike_14g.jpg', 1),
(5, 'images/line_strongline_012.jpg', 1),
(6, 'images/hooks_hook_master_20.jpg', 1),
(7, 'images/easy_shad_35.jpg', 1),
(8, 'images/feeder_expert_36.jpg', 1),
(9, 'images/box_pro.jpg', 1),
(10, 'images/float_classic_4g.jpg', 1);
GO


INSERT INTO review (product_ID, client_ID, rating, comment) VALUES
(1, 2, 5, 'Отличный спиннинг, лёгкий и удобный.'),
(3, 2, 5, 'Воблер рабочий, щука на него берёт хорошо.'),
(2, 3, 4, 'Катушка хорошая, ход плавный.'),
(5, 4, 5, 'Шнур крепкий, соответствует описанию.');
GO


INSERT INTO cart (client_ID) VALUES
(2),
(3),
(4);
GO


INSERT INTO cart_item (cart_ID, product_ID, qty) VALUES
(1, 1, 1),
(1, 3, 2),
(1, 5, 1),
(2, 2, 1),
(2, 6, 3),
(3, 8, 1),
(3, 10, 2);
GO


INSERT INTO [order] (client_ID, delivery_ID, address_ID, total_amount, status_ID) VALUES
(2, 1, 1, 7080.00, 2),
(3, 3, 2, 4820.00, 3),
(4, 2, 3, 5490.00, 1);
GO


INSERT INTO order_item (order_ID, product_ID, qty, price_at_purchase) VALUES
(1, 1, 1, 4590.00),
(1, 3, 2, 750.00),
(1, 5, 1, 990.00),

(2, 2, 1, 3890.00),
(2, 6, 3, 310.00),

(3, 8, 1, 5250.00),
(3, 10, 2, 120.00);
GO

INSERT INTO order_status_history (order_ID, status_ID) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(2, 3),
(3, 1);
GO

INSERT INTO notification (account_ID, title, message) VALUES
(2, 'Заказ принят', 'Ваш заказ №1 принят продавцом и передан в обработку.'),
(3, 'Заказ отправлен', 'Ваш заказ №2 отправлен и скоро будет доставлен.'),
(4, 'Заказ оформлен', 'Ваш заказ №3 успешно создан.'),
(1, 'Новый заказ', 'Поступил новый заказ №3 от покупателя.');
GO

ALTER TABLE seller_profile
ALTER COLUMN shop_phone VARCHAR(20);select * from account;
go

select * from notification;
go

select * from [order];
go

select * from cart;
go

select * from cart_item;
go

select * from review;
go

select * from product;
go

select * from client_address;
go

select * from category;
go

select * from account;
go

ALTER TABLE Account
ADD Phone NVARCHAR(30) NULL;

SELECT * FROM __EFMigrationsHistory;
ALTER TABLE product
ADD ImageUrl NVARCHAR(255) NULL;

ALTER TABLE product
DROP COLUMN ImageUrl;
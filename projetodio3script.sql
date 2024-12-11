-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Tabela Cliente
CREATE TABLE client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    Address VARCHAR(30),
    CONSTRAINT unique_cpf_client UNIQUE (CPF)
);

-- Tabela Produto
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Movéis') NOT NULL,
    avaliação FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- Tabela Pagamento
CREATE TABLE payments (
    idClient INT,
    id_payment INT AUTO_INCREMENT,
    typePayment ENUM('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable FLOAT,
    PRIMARY KEY (idClient, id_payment),
    CONSTRAINT fk_payments_client FOREIGN KEY (idClient) REFERENCES client(idClient)
);

-- Tabela Pedido
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES client(idClient)
);

-- Tabela Estoque
CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    idProduct INT,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0,
    CONSTRAINT fk_product_storage FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- Tabela Fornecedor
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact VARCHAR(15) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Tabela Vendedor
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(14),
    CPF CHAR(11),
    location VARCHAR(255),
    contact VARCHAR(15) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- Tabela Produto-Vendedor
CREATE TABLE productSeller (
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idSeller, idProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idSeller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- Tabela Relação de Produto/Pedido
CREATE TABLE productOrder (
    idProduct INT,
    idOrder INT,
    poQuantity INT,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idProduct, idOrder),
    CONSTRAINT fk_product_order_product FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_product_order_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- Tabela Entrega
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    deliveryStatus ENUM('Pendente', 'Em transporte', 'Entregue') DEFAULT 'Pendente',
    trackingCode VARCHAR(50),
    idOrder INT,
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- Inserindo dados na tabela Cliente
INSERT INTO client (Fname, Minit, Lname, CPF, Address)
VALUES
('João', 'A', 'Silva', '12345678901', 'Rua A, 100'),
('Maria', 'B', 'Oliveira', '98765432100', 'Rua B, 200');

-- Inserindo dados na tabela Produto
INSERT INTO product (Pname, classification_kids, category, avaliação, size)
VALUES
('Celular', FALSE, 'Eletronico', 4.5, 'Médio'),
('Camiseta', FALSE, 'Vestimenta', 4.0, 'M');

-- Inserindo dados na tabela Pedido
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
VALUES
(1, 'Confirmado', 'Pedido de Celular', 15.0, TRUE);

-- Inserindo dados na tabela Estoque
INSERT INTO productStorage (idProduct, storageLocation, quantity)
VALUES
(1, 'Depósito Central', 50),
(2, 'Depósito Central', 100);

-- Inserindo dados na tabela Entrega
INSERT INTO delivery (deliveryStatus, trackingCode, idOrder)
VALUES
('Em transporte', 'TRK123456', 1);

-- Recuperação simples com SELECT Statement
SELECT Fname, Lname, Address FROM client;

-- Filtros com WHERE Statement
SELECT Pname, category, avaliação FROM product
WHERE category = 'Eletronico';

-- Expressões para gerar atributos derivados
SELECT Pname, avaliação, 
       (avaliação * 20) AS avaliacao_porcentagem
FROM product;

-- Ordenação dos dados com ORDER BY
SELECT Fname, Lname, CPF FROM client
ORDER BY Fname ASC;

-- Condições de filtros aos grupos – HAVING Statement
SELECT category, COUNT(*) AS total_produtos
FROM product
GROUP BY category
HAVING COUNT(*) > 1;

-- Junções entre tabelas
SELECT o.idOrder, c.Fname, p.Pname, d.deliveryStatus
FROM orders o
JOIN client c ON o.idOrderClient = c.idClient
JOIN productOrder po ON o.idOrder = po.idOrder
JOIN product p ON po.idProduct = p.idProduct
JOIN delivery d ON o.idOrder = d.idOrder;
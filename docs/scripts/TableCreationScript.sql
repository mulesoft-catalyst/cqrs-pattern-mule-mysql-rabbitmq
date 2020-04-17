CREATE TABLE customer
(     customer_id INT NOT NULL AUTO_INCREMENT
    , first_name  VARCHAR(500)
    , last_name   VARCHAR(500)
    , age         INTEGER
    , street      VARCHAR(500)
    , city        VARCHAR(500)
    , state       VARCHAR(500)
    , postal_code VARCHAR(500)
    , email       VARCHAR(500)
    , PRIMARY KEY (customer_id)
);

CREATE TABLE order_header
(     order_header_id INT NOT NULL AUTO_INCREMENT
    , currency         VARCHAR(500)
    , subtotal         DECIMAL(10,2)
    , discount_amount  DECIMAL(10,2)
    , taxAmount        DECIMAL(10,2)
    , grandTotal       DECIMAL(10,2)
    , order_number     VARCHAR(500)
    , shipping_amount  DECIMAL(10,2)
    , customer_id      INTEGER
    , PRIMARY KEY (order_header_id)
);


CREATE TABLE order_lines
(     order_line_id INT NOT NULL AUTO_INCREMENT
    , sku              VARCHAR(500)
    , name             VARCHAR(500)
    , description      VARCHAR(500)
    , category         VARCHAR(500)
    , unit_price       DECIMAL(10,2)
    , sale_price       DECIMAL(10,2)
    , quantity         INTEGER
    , total_price      DECIMAL(10,2)
    , order_header_id  INTEGER
    , PRIMARY KEY (order_line_id)
);

CREATE DATABASE bigz_orders;
CREATE TABLE depot
( depotid CHAR(2) NOT NULL,
depotsize VARCHAR(10) NOT NULL,
depotzip CHAR(5) NOT NULL, 
PRIMARY KEY (depotid));

CREATE TABLE supplier
(supplierid CHAR(2) NOT NULL,
suppliername VARCHAR(25) NOT NULL,
PRIMARY KEY (supplierid));

CREATE TABLE orderclerk
(ocid CHAR(3) NOT NULL,
ocname VARCHAR(25) NOT NULL,
PRIMARY KEY (ocid));

CREATE TABLE customer
(customerid CHAR(2) NOT NULL, 
customername VARCHAR(50) NOT NULL,
customertype VARCHAR(20) NOT NULL,
customerzip CHAR(5) NOT NULL,
PRIMARY KEY (customerid));

CREATE TABLE product
(productid CHAR(2) NOT NULL,
productname VARCHAR(50) NOT NULL,
producttype VARCHAR(25) NOT NULL,
supplierid CHAR(2) NOT NULL, 
PRIMARY KEY (productid),
FOREIGN KEY (supplierid) REFERENCES supplier(supplierid));

CREATE TABLE orders
(orderid CHAR(2) NOT NULL,
orderdate VARCHAR(25) NOT NULL,
ordertime VARCHAR(15) NOT NULL,
customerid CHAR(2) NOT NULL,
depotid CHAR(2) NOT NULL,
ocid CHAR(3) NOT NULL,
PRIMARY KEY (orderid),
FOREIGN KEY (customerid) REFERENCES customer(customerid),
FOREIGN KEY (depotid) REFERENCES depot(depotid),
FOREIGN KEY (ocid) REFERENCES orderclerk(ocid));

#SELECT DATE_FORMAT(orderdate, "%e-%b-%Y") FROM orders;
#SELECT DATE_FORMAT(ordertime, "%r") FROM orders;
#because we are given the values I was not sure if using the formatting tools was neccessary as I can enter them exactly as they need to be

CREATE TABLE orderedvia
(productid CHAR(2) NOT NULL,
orderid CHAR(2) NOT NULL,
quantity CHAR(4) NOT NULL,
FOREIGN KEY (productid) REFERENCES product(productid),
FOREIGN KEY (orderid) REFERENCES orders(orderid));

INSERT INTO depot VALUES ('D1', 'Small', '60611');
INSERT INTO depot VALUES ('D2', 'Large', '60660');
INSERT INTO depot VALUES ('D3', 'Large', '60611');

INSERT INTO supplier VALUES ('ST', 'Super Tires');
INSERT INTO supplier VALUES ('BE', 'Batteries Etc');

INSERT INTO orderclerk VALUES ('OC1', 'Antonio');
INSERT INTO orderclerk VALUES ('OC2', 'Wesley');
INSERT INTO orderclerk VALUES ('OC3', 'Lilly');

INSERT INTO customer VALUES ('C1', 'Auto Doc', 'Repair Shop', '60137');
INSERT INTO customer VALUES ('C2', 'Bo''s Car Repair', 'Repair Shop', '60140');
INSERT INTO customer VALUES ('C3', 'JJ Auto Parts', 'Retailer', '60605');

INSERT INTO product VALUES ('P1', 'BigGripper', 'Tire', 'ST');
INSERT INTO product VALUES ('P2', 'TractionWiz', 'Tire', 'ST');
INSERT INTO product VALUES ('P3', 'SureStart', 'Battery', 'BE');

INSERT INTO orders VALUES ('O1', 'C1', 'D1', 'OC1', '2020-01-01', '9:00:00 AM');
INSERT INTO orders VALUES ('O2', 'C2', 'D1', 'OC2', '2020-01-02', '9:00:00 AM');
INSERT INTO orders VALUES ('O3', 'C3', 'D2', 'OC3', '2020-01-02', '9:30:00 AM');
INSERT INTO orders VALUES ('O4', 'C1', 'D2', 'OC1', '2020-01-03', '9:00:00 AM');
INSERT INTO orders VALUES ('O5', 'C2', 'D3', 'OC2', '2020-01-03', '9:15:00 AM');
INSERT INTO orders VALUES ('O6', 'C3', 'D3', 'OC3', '2020-01-03', '9:30:00 AM');

INSERT INTO orderedvia VALUES ('P1', 'O1', '4');
INSERT INTO orderedvia VALUES ('P2', 'O1', '8');
INSERT INTO orderedvia VALUES ('P1', 'O2', '12');
INSERT INTO orderedvia VALUES ('P2', 'O3', '4');
INSERT INTO orderedvia VALUES ('P3', 'O4', '7');
INSERT INTO orderedvia VALUES ('P3', 'O5', '5');
INSERT INTO orderedvia VALUES ('P2', 'O6', '8');
INSERT INTO orderedvia VALUES ('P1', 'O6', '4');

CREATE DATABASE bigz_hr;
CREATE TABLE employeedata
(employeeid CHAR(3) NOT NULL,
employeename VARCHAR(20) NOT NULL,
jobtitle VARCHAR(20) NOT NULL,
edulevel VARCHAR(20) NOT NULL,
yearhired CHAR(4) NOT NULL,
PRIMARY KEY (employeeid));

INSERT INTO employeedata VALUES ('OC1', 'Antonio', 'Order Clerk', 'High School', '2010');
INSERT INTO employeedata VALUES ('OC2', 'Wesley', 'Order Clerk', 'College', '2016');
INSERT INTO employeedata VALUES ('OC3', 'Lilly', 'Order Clerk', 'College', '2016');
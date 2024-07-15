CREATE DATABASE bigzDM;

CREATE TABLE ProductDim
(productkey INT(10) AUTO_INCREMENT,
productid CHAR(2) NOT NULL, 
productname VARCHAR(50) NOT NULL,
producttype VARCHAR(25) NOT NULL,
suppliername VARCHAR(25) NOT NULL,
PRIMARY KEY (productkey));

CREATE TABLE OrderClerkDim
(OCkey INT(10) AUTO_INCREMENT,
ocid CHAR(3) NOT NULL,
ocname VARCHAR(20) NOT NULL,
jobtitle VARCHAR(20) NOT NULL,
edulevel VARCHAR(20) NOT NULL,
yearhired CHAR(4) NOT NULL,
PRIMARY KEY (OCkey));

CREATE TABLE DepotDim
(depotkey INT(10) AUTO_INCREMENT,
depotid CHAR(2) NOT NULL,
depotsize VARCHAR(10) NOT NULL,
depotzip CHAR(5) NOT NULL, 
PRIMARY KEY (depotkey));

CREATE TABLE CustomerDim
(customerkey INT(10) AUTO_INCREMENT,
customerid CHAR(2) NOT NULL, 
customername VARCHAR(50) NOT NULL,
customertype VARCHAR(20) NOT NULL,
customerzip CHAR(5) NOT NULL,
PRIMARY KEY (customerkey));

CREATE TABLE CalendarDim
( 	CalendarKey INT(8) AUTO_INCREMENT,
	fulldate	DATE,
    dayofweek	VARCHAR(15) as (dayname(fulldate)),
    dayofthemonth INT as (dayofmonth(fulldate)),
    mth VARCHAR(10) as (monthname(fulldate)),
    qtr char(2) as (quarter(fulldate)),
    yr	int as (year(fulldate)),
    PRIMARY KEY (CalendarKey));

 
CREATE TABLE OrderFact
(CalendarKey INT,
productkey INT,
customerkey INT,
depotkey INT,
OCkey INT,
orderid VARCHAR(10), 
otime TIME,
orderqty VARCHAR(4),
PRIMARY KEY (productkey, orderid),
FOREIGN KEY (CalendarKey) REFERENCES CalendarDim(CalendarKey),
FOREIGN KEY (productkey) REFERENCES ProductDim(productkey),
FOREIGN KEY (customerkey) REFERENCES CustomerDim(customerkey),
FOREIGN KEY (depotkey) REFERENCES DepotDim(depotkey),
FOREIGN KEY (OCkey) REFERENCES OrderClerkDim(OCkey));

INSERT INTO bigzdm.ProductDim(productid, productname, producttype, suppliername)
SELECT p.productid, p.productname, p.producttype, s.suppliername
FROM product p, supplier s
WHERE s.supplierid = p.supplierid;

INSERT INTO bigzdm.CustomerDim(customerid, customername, customertype, customerzip)
SELECT c.customerid, c.customername, c.customertype, c.customerzip
FROM customer c;

INSERT INTO bigzdm.DepotDim(depotid, depotsize, depotzip)
SELECT d.depotid, d.depotsize, d.depotzip
FROM depot d;

INSERT INTO bigzdm.OrderClerkDim(ocid, ocname, jobtitle, edulevel, yearhired)
SELECT k.ocid, k.ocname, hr.jobtitle, hr.edulevel, hr.yearhired
FROM orderclerk k, bigz_hr.employeedata hr
WHERE k.ocid=hr.employeeid;

INSERT INTO CalendarDim (fulldate) VALUES ('20200101');
INSERT INTO CalendarDim (fulldate) VALUES ('20200102');
INSERT INTO CalendarDim (fulldate) VALUES ('20200103');

CREATE TABLE orderstaging
(
productid CHAR(2) NOT NULL,
orderid CHAR(2) NOT NULL, 
quantity CHAR(4) NOT NULL, 
customerid CHAR(2) NOT NULL, 
depotid CHAR(2) NOT NULL, 
ocid CHAR(3) NOT NULL, 
orderdate VARCHAR(25) NOT NULL, 
ordertime VARCHAR(15) NOT NULL, 
PRIMARY KEY (orderid));

INSERT INTO bigzdm.orderstaging(productid, orderid, quantity, customerid, depotid, ocid, orderdate, ordertime)
SELECT v.productid, o.orderid, v.quantity, o.customerid, o.depotid, o.ocid, o.orderdate, o.ordertime
FROM orderedvia v, orders o
WHERE o.orderid = v.orderid;

INSERT INTO OrderFact
SELECT cl.CalendarKey, pd.productkey, cd.customerkey, d.depotkey, oc.OCkey,  st.orderid, st.ordertime, st.quantity
FROM CalendarDim cl, ProductDim pd, CustomerDim cd, DepotDim d, OrderClerkDim oc, orderstaging st
WHERE st.productid = pd.productid AND st.customerid = cd.customerid AND st.depotid = d.depotid AND st.ocid = oc.ocid AND st.orderdate = cl.fulldate;


#CREATE TABLE OrderFact
#(CalendarKey INT, CalendarDim
#productkey INT, ProductDim
#customerkey INT, CustomerDim
#depotkey INT, DepotDim
#OCkey INT, OrderClerkDim
#orderid VARCHAR(10), orderstaging
#otime TIME, orderstaging
#orderqty VARCHAR(4), orderstaging

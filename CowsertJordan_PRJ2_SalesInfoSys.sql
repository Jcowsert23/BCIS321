#DELIVERABLE #1
CREATE SCHEMA PRJ2SALESINFOSYS;
CREATE TABLE Territory
(	TerritoryID		char(5)		NOT NULL,
	TerritoryName		varchar(10)	NOT NULL,
    PRIMARY KEY (TerritoryID) );
CREATE TABLE Sales_Rep
(	SalesRepID		char(5) NOT NULL,
    RepName			varchar(50) NOT NULL, 
    TerritoryID		char(5) NOT NULL, 
    PRIMARY KEY (SalesRepID),
    FOREIGN KEY (TerritoryID) REFERENCES Territory(TerritoryID) ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TABLE Sales_Tranx
(	STranxID		INT AUTO_INCREMENT PRIMARY KEY ,
	Qty		varchar(5)	NOT NULL,
    SalesSysDateTime	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SalesRepID 	char(5) NOT NULL,

    FOREIGN KEY (SalesRepID) REFERENCES Sales_Rep(SalesRepID) ON DELETE CASCADE ON UPDATE CASCADE);
#1.1.1 The on delete cascade on update cascade will change all instances of the salesrepid. If the ID is changed in the sales_tranx table it will also be changed in the sales_rep table. 
#1.1.2 I think I would prefer the on delete cascade/on update cascade constraint. I keeps all of the data across the tables consistent and requires fewer steps to modify information. 

#DELIVERABLE #2

INSERT INTO Territory VALUES ('E', 'East');
INSERT INTO Territory VALUES ('WE', 'West');
INSERT INTO Territory VALUES ('S', 'South');
INSERT INTO Territory VALUES ('N', 'North');
INSERT INTO Territory VALUES ('C', 'Central');

INSERT INTO sales_rep VALUES ('1', 'Joe', 'E');
INSERT INTO sales_rep VALUES ('2', 'Sue', 'E');
INSERT INTO sales_rep VALUES ('3', 'Meg', 'C');
INSERT INTO sales_rep VALUES ('4', 'Bob', 'S');
INSERT INTO sales_rep VALUES ('5', 'Joe', 'N');
INSERT INTO sales_rep VALUES ('6', 'Pat', 'N');
INSERT INTO sales_rep VALUES ('7', 'Lee', 'N');
INSERT INTO sales_rep VALUES ('8', 'Joe', 'E');




INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('10', '1');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('14', '3');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('12', '2');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('23', '1');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('20', '5');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('22', '5');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('10', '6');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('12', '7');
DO SLEEP(30);
INSERT INTO sales_tranx(Qty, SalesRepID) VALUES ('5', '5');

#DELIVERABLE #3

SELECT sum(qty), salesrepID from Sales_tranx group by salesrepID having sum(qty)<1;
Select RepName from Sales_Rep where SalesRepID IN(select salesrepid from sales_tranx group by salesrepid having sum(qty)<1);
create or replace view inactive_reps As select RepName from Sales_Rep where salesrepID IN(select salesrepID from Sales_tranx group by salesrepid having sum(qty)<1);

#I am struggling with query writing so I'm going to go back through the lessons again and practice.
#These were giving me problems. 


#DELIVERABLE #4
delimiter |

CREATE TRIGGER before_rep_insert_trigger BEFORE INSERT ON sales_rep
FOR EACH ROW
BEGIN
	DECLARE territorycount int default 0 ;
	SELECT Count(*) INTO territorycount
	FROM sales_rep
	WHERE TerritoryID = NEW.TerritoryID ; 
	IF territorycount >= 3 THEN
		SET NEW.TerritoryID = NULL	;
    END IF ;
END |

delimiter ;

INSERT INTO sales_rep VALUES ('9', 'Jordan', 'E');
 #This would create a 4th sales rep in territory 'E' so there was an error code because the TerritoryID was NULL. 
 
 delimiter |
 CREATE TRIGGER before_rep_update_trigger BEFORE UPDATE ON sales_rep
 FOR EACH ROW
 BEGIN
	DECLARE territorycount int default 0 ;
    SELECT Count(*) INTO territorycount
    FROM sales_rep
    WHERE TerritoryID = NEW.TerritoryID ;
    IF territorycount >= 3 THEN
    SET NEW.TerritoryID = NULL ;
    END IF;
END |

delimiter ;

UPDATE sales_rep SET TerritoryID= 'N' WHERE SalesRepID= '4';
#there are already three reps in territory N so updating sales rep with ID 4 from their original territory S to N activates the new trigger and creates a NULL value. 
/*
Mohammed Mohsin Dyer
#V00930385

Taimur Kashif Khan Niazi
#V00913853
 */


/*
This assignment introduces an example concerning World War II capital ships.
It involves the following relations:

Classes(class, type, country, numGuns, bore, displacement)
Ships(name, class, launched)  --launched is for year launched
Battles(name, date_fought)
Outcomes(ship, battle, result)

Ships are built in "classes" from the same design, and the class is usually
named for the first ship of that class.

Relation Classes records the name of the class,
the type (bb for battleship or bc for battlecruiser),
the country that built the ship, the number of main guns,
the bore (diameter of the gun barrel, in inches)
of the main guns, and the displacement (weight, in tons).

Relation Ships records the name of the ship, the name of its class,
and the year in which the ship was launched.

Relation Battles gives the name and date of battles involving these ships.

Relation Outcomes gives the result (sunk, damaged, or ok)
for each ship in each battle.
*/


/*
Exercise 1. (1 point)

1.	Create simple SQL statements to create the above relations
    (no constraints for initial creations).
2.	Insert the following data.

For Classes:
('Bismarck','bb','Germany',8,15,42000);
('Kongo','bc','Japan',8,14,32000);
('North Carolina','bb','USA',9,16,37000);
('Renown','bc','Gt. Britain',6,15,32000);
('Revenge','bb','Gt. Britain',8,15,29000);
('Tennessee','bb','USA',12,14,32000);
('Yamato','bb','Japan',9,18,65000);

For Ships
('California','Tennessee',1921);
('Haruna','Kongo',1915);
('Hiei','Kongo',1914);
('Iowa','Iowa',1943);
('Kirishima','Kongo',1914);
('Kongo','Kongo',1913);
('Missouri','Iowa',1944);
('Musashi','Yamato',1942);
('New Jersey','Iowa',1943);
('North Carolina','North Carolina',1941);
('Ramilles','Revenge',1917);
('Renown','Renown',1916);
('Repulse','Renown',1916);
('Resolution','Revenge',1916);
('Revenge','Revenge',1916);
('Royal Oak','Revenge',1916);
('Royal Sovereign','Revenge',1916);
('Tennessee','Tennessee',1920);
('Washington','North Carolina',1941);
('Wisconsin','Iowa',1944);
('Yamato','Yamato',1941);

For Battles
('North Atlantic','27-May-1941');
('Guadalcanal','15-Nov-1942');
('North Cape','26-Dec-1943');
('Surigao Strait','25-Oct-1944');

For Outcomes
('Bismarck','North Atlantic', 'sunk');
('California','Surigao Strait', 'ok');
('Duke of York','North Cape', 'ok');
('Fuso','Surigao Strait', 'sunk');
('Hood','North Atlantic', 'sunk');
('King George V','North Atlantic', 'ok');
('Kirishima','Guadalcanal', 'sunk');
('Prince of Wales','North Atlantic', 'damaged');
('Rodney','North Atlantic', 'ok');
('Scharnhorst','North Cape', 'sunk');
('South Dakota','Guadalcanal', 'ok');
('West Virginia','Surigao Strait', 'ok');
('Yamashiro','Surigao Strait', 'sunk');
*/



create table Classes(
     class varchar(30),
     type char(2),
     country varchar(15),
     numGuns int,
     bore int,
     displacement int
 );

create table Ships(
     name varchar(30),
     class varchar(30),
     launched int
 );

create table Battles(
     name varchar(20),
     date_fought date
 );

create table Outcomes(
     ship varchar(20),
     battle varchar(20),
     result varchar(10)
 );

insert into classes (class, type, country, numGuns, bore, displacement)
values
('Bismarck','bb','Germany',8,15,42000),
('Kongo','bc','Japan',8,14,32000),
('North Carolina','bb','USA',9,16,37000),
('Renown','bc','Gt. Britain',6,15,32000),
('Revenge','bb','Gt. Britain',8,15,29000),
('Tennessee','bb','USA',12,14,32000),
('Yamato','bb','Japan',9,18,65000);

insert into ships (name, class, launched)
values
('California','Tennessee',1921),
('Haruna','Kongo',1915),
('Hiei','Kongo',1914),
('Iowa','Iowa',1943),
('Kirishima','Kongo',1914),
('Kongo','Kongo',1913),
('Missouri','Iowa',1944),
('Musashi','Yamato',1942),
('New Jersey','Iowa',1943),
('North Carolina','North Carolina',1941),
('Ramilles','Revenge',1917),
('Renown','Renown',1916),
('Repulse','Renown',1916),
('Resolution','Revenge',1916),
('Revenge','Revenge',1916),
('Royal Oak','Revenge',1916),
('Royal Sovereign','Revenge',1916),
('Tennessee','Tennessee',1920),
('Washington','North Carolina',1941),
('Wisconsin','Iowa',1944),
('Yamato','Yamato',1941);

insert into battles (name, date_fought)
values
('North Atlantic','27-May-1941'),
('Guadalcanal','15-Nov-1942'),
('North Cape','26-Dec-1943'),
('Surigao Strait','25-Oct-1944');

insert into outcomes (ship, battle, result)
values
('Bismarck','North Atlantic', 'sunk'),
('California','Surigao Strait', 'ok'),
('Duke of York','North Cape', 'ok'),
('Fuso','Surigao Strait', 'sunk'),
('Hood','North Atlantic', 'sunk'),
('King George V','North Atlantic', 'ok'),
('Kirishima','Guadalcanal', 'sunk'),
('Prince of Wales','North Atlantic', 'damaged'),
('Rodney','North Atlantic', 'ok'),
('Scharnhorst','North Cape', 'sunk'),
('South Dakota','Guadalcanal', 'ok'),
('West Virginia','Surigao Strait', 'ok'),
('Yamashiro','Surigao Strait', 'sunk');



-- Exercise 2. (6 points)
-- Write SQL queries for the following requirements.

-- 1.	(2 pts) List the name, displacement, and number of guns of the ships engaged in the battle of Guadalcanal.
/*
Expected result:
ship,displacement,numguns
Kirishima,32000,8
South Dakota,NULL,NULL
*/

select ship, displacement, numGuns
from  outcomes left join ships on outcomes.ship = ships.name left join classes on classes.class = ships.class
where battle = 'Guadalcanal';


-- 2.	(2 pts) Find the names of the ships whose number of guns was the largest for those ships of the same bore.


with x as (select max(numguns) as numguns, bore from classes group by bore)
select ships.name
from x join classes using (numguns, bore) join ships using (class);


--3. (2 pts) Find for each class with at least three ships the number of ships of that class sunk in battle.
/*
class,sunk_ships
Revenge,0
Kongo,1
Iowa,0
*/


with X as (select class, name from ships where class in (select class from ships group by class having count(*)>3)),
     Y as (select ship, result from outcomes where result = 'sunk')
select class, count(result) as sunk_ships from X left join Y on X.name = Y.ship group by X.class;



-- Exercise 3. (4 points)

-- Write the following modifications.

-- 1.	(2 points) Two of the three battleships of the Italian Vittorio Veneto class –
-- Vittorio Veneto and Italia – were launched in 1940;
-- the third ship of that class, Roma, was launched in 1942.
-- Each had 15-inch guns and a displacement of 41,000 tons.
-- Insert these facts into the database.


insert into classes(class, type, country, bore, displacement) 
values ('Italian Vittorio Veneto', 'bb', 'Italy', 15, 41000);

insert into ships (name, class, launched)
values
('Vittorio Veneto', 'Italian Vittorio Veneto', 1940),
('Italia', 'Italian Vittorio Veneto', 1940),
('Roma', 'Italian Vittorio Veneto', 1942);



-- 2.	(1 point) Delete all classes with fewer than three ships.


delete from classes where class in (select class from ships group by class having count(name) < 3);


-- 3.	(1 point) Modify the Classes relation so that gun bores are measured in centimeters
-- (one inch = 2.5 cm) and displacements are measured in metric tons (one metric ton = 1.1 ton).


update classes
set bore = bore*2.5, displacement = displacement/1.1;




-- Exercise 4.  (9 points)
-- Add the following constraints using views with check option.

--1. (3 points) No ship can be in battle before it is launched.

-- Write your sql statement here.

create or replace view OutcomesView as
select ship, battle, result 
from Outcomes
where not exists(
select * from Ships, Battles
where Ships.launched > extract(year from Battles.date_fought)::int and Outcomes.ship=Ships.name and Outcomes.battle=Battles.name
)
with check option;

-- Now we can try some insertion on this view.
INSERT INTO OutcomesView (ship, battle, result)
VALUES('Musashi', 'North Atlantic','ok');
-- This insertion, as expected, should fail since Musashi is launched in 1942,
-- while the North Atlantic battle took place on 27-MAY-41.


-- 2. (3 points) No ship can be launched before
-- the ship that bears the name of the first ship’s class.

-- Write your sql statement here.

create or replace view ShipsV as
select name, class, launched
from ships A
where not exists(
select * from ships B
where B.launched>A.launched and B.class=A.class and B.class=B.name
)
with check option;

-- Now we can try some insertion on this view.
INSERT INTO ShipsV(name, class, launched)
VALUES ('AAA','Kongo',1912);
-- This insertion, as expected, should fail since ship Kongo (first ship of class Kongo) is launched in 1913.


--3. (3 points) No ship fought in a battle that was at a later date than another battle in which that ship was sunk.

-- Write your sql statements here.

create or replace view OutcomesV as
select ship, battle, result
from Outcomes A
where not exists(
select * from Outcomes B
where (select date_fought from Battles where A.battle=Battles.name)>(select date_fought from Battles where B.battle=Battles.name) 
and A.ship=B.ship and B.result='sunk'
)
with check option;

-- Now we can try some insertion on this view.
INSERT INTO OutcomesV(ship, battle, result)
VALUES('Bismarck', 'Guadalcanal', 'ok');
-- This insertion, as expected, should fail since 'Bismarck' was sunk in
-- the battle of North Atlantic, in 1941, whereas the battle of Guadalcanal happened in 1942.
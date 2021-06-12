/*
Pizza Database

Mohammed Mohsin Dyer
#V00930385

Taimur Kashif Khan Niazi
#V00913853
*/

/*Q1.*/
select * from person where age < 18;

/*Q2.*/
select pizzeria, pizza, price from serves natural join eats where name = 'Amy' and price < 10;

/*Q3.*/
select pizzeria, name, age from frequents natural join person where age < 18;

/*Q4.*/
select pizzeria from frequents join person on person.name = frequents.name and person.age <18
INTERSECT select pizzeria from frequents join person on person.name = frequents.name and person.age >30;

/*Q5.*/
WITH A AS (
	SELECT pizzeria, person.name, person.age 
	FROM person JOIN frequents ON person.name=frequents.name 
	WHERE age < 18
	), 
B AS (
	SELECT pizzeria, person.name, person.age 
	FROM person JOIN frequents ON person.name=frequents.name 
	WHERE age > 30
	) 
SELECT A.pizzeria, A.name AS person1, A.age AS age1, B.name AS person2, B.age AS age2 
FROM A JOIN B ON A.pizzeria=B.pizzeria;

/*Q6.*/
select name, count(pizza) AS countpizza from eats group by name having count(pizza) >= 2 order by countPizza desc;

/*Q7.*/
select pizza, avg(price) AS avgprice from serves group by pizza order by avgprice desc;
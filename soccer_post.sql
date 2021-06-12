/*The questions in this assignment are about doing soccer analytics using SQL.
The data is in tables England, France, Germany, and Italy.
These tables contain more than 100 years of soccer game statistics.
Follow the steps below to create your tables and familizarize yourself with the data.
Then write SQL statements to answer the questions.
The first time you access the data you might experience a small delay while DBeaver
loads the metadata for the tables accessed.

Submit this file after adding your queries.
Replace "Your query here" text with your query for each question.
Submit one spreadsheet file with your visualizations for questions 2, 7, 9, 10, 12
(one sheet per question named by question number, e.g. Q2, Q7, etc).
*/

/*Create the tables.*/

create table england as select * from bob.england;
create table france as select * from bob.france;
create table germany as select * from bob.germany;
create table italy as select * from bob.italy;

/*Familiarize yourself with the tables.*/
SELECT * FROM england;
SELECT * FROM germany;
SELECT * FROM france;
SELECT * FROM italy;

/*Q1 (1 pt)
Find all the games in England between seasons 1920 and 1999 such that the total goals are at least 13.
Order by total goals descending.*/

/*SELECT * FROM england WHERE season >= 1920 AND season <= 1999 AND totgoal >= 13 ORDER BY totgoal DESC;*/

/*Sample result
1935-12-26,1935,Tranmere Rovers,Oldham Athletic,13,4,3,17,9,H
1958-10-11,1958,Tottenham Hotspur,Everton,10,4,1,14,6,H
...*/


/*Q2 (2 pt)
For each total goal result, find how many games had that result.
Use the england table and consider only the seasons since 1980.
Order by total goal.*/

/*SELECT totgoal, count(totgoal) AS countgoal FROM england WHERE season >= 1980 GROUP BY totgoal ORDER BY totgoal;*/

/*Sample result
0,6085
1,14001
...*/

/*Visualize the results using a barchart.*/


/*Q3 (2 pt)
Find for each team in England in tier 1 the total number of games played since 1980.
Report only teams with at least 300 games.

Hint. Find the number of games each team has played as "home".
Find the number of games each team has played as "visitor".
Then union the two and take the sum of the number of games.
*/

/*WITH A AS (
	SELECT home, count(home) AS counthome 
	FROM england 
	WHERE tier = 1 AND season >= 1980 
	GROUP BY home 
	HAVING count(home) >= 300 
	UNION 
	SELECT visitor, count(visitor) AS countvisitor 
	FROM england 
	WHERE tier = 1 AND season >= 1980 
	GROUP BY visitor HAVING count(visitor) >= 300
	) 
SELECT home AS team, sum(counthome) AS sumgames 
FROM A 
GROUP BY home;*/

/*Sample result
Everton,1451
Liverpool,1451
...*/


/*Q4 (1 pt)
For each pair team1, team2 in England, in tier 1,
find the number of home-wins since 1980 of team1 versus team2.
Order the results by the number of home-wins in descending order.

Hint. After selecting the tuples needed (... WHERE tier=1 AND ...) do a GROUP BY home, visitor.
*/

/*SELECT home AS team1, visitor AS team2, count(result) AS homewins 
FROM england 
WHERE tier=1 AND season >= 1980 AND result='H' 
GROUP BY home, visitor 
ORDER BY homewins DESC;*/

/*Sample result
Manchester United,Tottenham Hotspur,27
Arsenal,Everton,26
...*/


/*Q5 (1 pt)
For each pair team1, team2 in England in tier 1
find the number of away-wins since 1980 of team1 versus team2.
Order the results by the number of away-wins in descending order.*/

/*select visitor as team1, home as team2, count(result) from england where result = 'A' and tier = 1
and season >= 1980 group by team1, team2 order by count desc;*/

/*Sample result
Manchester United,Aston Villa,18
Manchester United,Everton,17
...*/


/*Q6 (2 pt)
For each pair team1, team2 in England in tier 1 report the number of home-wins and away-wins
since 1980 of team1 versus team2.
Order the results by the number of away-wins in descending order.

Hint. Join the results of the two previous queries. To do that you can use those
queries as subqueries. Remove their ORDER BY clause when making them subqueries.
Be careful on the join conditions.
*/

/*with X as (
	select home as team1, visitor as team2, count(result) as homewins 
	from england 
	where result = 'H' and tier = 1 and season >= 1980 
	group by team1, team2
	), 
Y as (
	select visitor as team1, home as team2, count(result) as awaywins 
	from england 
	where result = 'A' and tier = 1 and season >= 1980 
	group by team1, team2
	)
select team1, team2, homewins, awaywins 
from X join Y 
using (team1, team2) 
order by awaywins desc;*/

/*Sample result
Manchester United,Aston Villa,26,18
Arsenal,Aston Villa,20,17
...*/

--Create a view, called Wins, with the query for the previous question.


/*Q7 (2 pt)
For each pair ('Arsenal', team2), report the number of home-wins and away-wins
of Arsenal versus team2 and the number of home-wins and away-wins of team2 versus Arsenal
(all since 1980).
Order the results by the second number of away-wins in descending order.
Use view W1.*/

/*CREATE VIEW Wins AS with X as (
	select home as team1, visitor as team2, count(result) as homewins 
	from england 
	where result = 'H' and tier = 1 and season >= 1980 
	group by team1, team2
	), 
Y as (
	select visitor as team1, home as team2, count(result) as awaywins 
	from england 
	where result = 'A' and tier = 1 and season >= 1980 
	group by team1, team2
	)
select team1, team2, homewins, awaywins 
from X join Y 
using (team1, team2) 
order by awaywins desc;



WITH A AS (
	SELECT team1, team2, homewins AS homeAwins, awaywins AS awayAwins
	FROM wins
	WHERE team1='Arsenal'
	),
B AS (
	SELECT team2, team1, homewins AS homeBwins, awaywins AS awayBwins
	FROM wins
	WHERE team2='Arsenal'
	)
SELECT B.team2, B.team1, homeAwins, awayAwins, homeBwins, awayBwins
FROM A, B where A.team2 = B.team1
ORDER BY awayBwins DESC;*/

/*Sample result
Arsenal,Liverpool,14,8,20,11
Arsenal,Manchester United,16,5,19,11
...*/

/*Drop view Wins.*/
DROP VIEW Wins;

/*Build two bar-charts, one visualizing the two home-wins columns, and the other visualizing the two away-wins columns.*/


/*Q8 (2 pt)
Winning at home is easier than winning as visitor.
Nevertheless, some teams have won more games as a visitor than when at home.
Find the team in Germany that has more away-wins than home-wins in total.
Print the team name, number of home-wins, and number of away-wins.*/

/*WITH A AS (
	SELECT home, count(*) AS homewins 
	FROM germany 
	WHERE hgoal>vgoal 
	GROUP BY home
	), 
B AS (
	SELECT visitor, count(*) AS awaywins 
	FROM germany 
	WHERE vgoal>hgoal 
	GROUP BY visitor
	) 
SELECT A.home AS team, homewins, awaywins 
FROM A JOIN B ON A.home=B.visitor 
WHERE A.homewins<B.awaywins;*/

/*Sample result
Wacker Burghausen	...	...*/


/*Q9 (3 pt)
One of the beliefs many people have about Italian soccer teams is that they play much more defense than offense.
Catenaccio or The Chain is a tactical system in football with a strong emphasis on defence.
In Italian, catenaccio means "door-bolt", which implies a highly organised and effective backline defence
focused on nullifying opponents' attacks and preventing goal-scoring opportunities.
In this question we would like to see whether the number of goals in Italy is on average smaller than in England.

Find the average total goals per season in England and Italy since the 1970 season.
The results should be (season, england_avg, italy_avg) triples, ordered by season.

Hint.
Subquery 1: Find the average total goals per season in England.
Subquery 2: Find the average total goals per season in Italy
   (there is no totgoal in table Italy. Take hgoal+vgoal).
Join the two subqueries on season.
*/

/*with X as (select season, avg(totgoal) as england_avg from england where season >= 1970
group by season), Y as (select season, avg(hgoal+vgoal) as italy_avg from italy where
season >= 1970 group by season) select season, england_avg, italy_avg from X join Y using (season);*/

--Build a line chart visualizing the results. What do you observe?

/*Sample result
1970,2.5290927021696252,2.1041666666666667
1971,2.5922090729783037,2.0125
...*/


/*Q10 (3 pt)
Find the number of games in France and England in tier 1 for each goal difference.
Return (goaldif, france_games, eng_games) triples, ordered by the goal difference.
Normalize the number of games returned dividing by the total number of games for the country in tier 1,
e.g. 1.0*COUNT(*)/(select count(*) from france where tier=1)  */

/*with X as (select goaldif, 1.0*count(goaldif)/(select count(*) from france where tier=1)  as france_games
from france where tier = 1 group by goaldif), Y as (select goaldif, 1.0*count(goaldif)/(select count(*)
from england where tier=1) as england_games from england where tier = 1 group by goaldif) select goaldif,
france_games, england_games from X join Y using (goaldif) order by goaldif;*/

/*Sample result
-8,0.00011369234850494562,0.000062637018477920450987
-7,0.00011369234850494562,0.00010439503079653408
...*/

/*Visualize the results using a barchart.*/


/*Q11 (2 pt)
Find all the seasons when England had higher average total goals than France.
Consider only tier 1 for both countries.
Return (season,england_avg,france_avg) triples.
Order by season.*/

/*with X as (select season, avg(totgoal) as england_avg from england where tier = 1 group by season), Y as (
select season, avg(totgoal) as france_avg from france where tier = 1 group by season) select season,
england_avg, france_avg from X join Y using (season) where england_avg>france_avg order by season;*/

/*Sample result
1936,3.3658008658008658,3.3041666666666667
1952,3.2640692640692641,3.1437908496732026
...*/

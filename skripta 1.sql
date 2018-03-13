﻿USE [vjezba2]
GO
/*
everything here is an interpretation of T-SQL excercises from www.w3resource.com

TRANSACT SQL SIMPLE EXCERCISES
ID	NAME			AGE	ADDRESS						SALARY	KOD
1	Pero			25	Vrbovsko                 	5550.00	NULL
2	Mile			50	Vrbovsko                 	4500.00	NULL
3	Vasilije Mitu	35	Split                    	5000.00	3%d  
4	Mirko			50	Dražice                  	5000.00	NULL

table 2
																	POBRATIM
1	Jole			25	Slana                    	7500.00	NULL	4
2	Pesti			50	Rtina                    	5000.00	NULL	3
3	Lovre			35	Kukovici                 	6500.00	4%d  	2
4	Ljudina			50	Smokvica                 	6000.00	NULL	1
*/

DROP TABLE IF EXISTS CUSTOMERS;

-- PROVJERA AKO POSTOJI TABLICA. AKO NE ONDA KREIRAJ
IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[CUSTOMERS]') AND type in (N'U'))
BEGIN
CREATE TABLE CUSTOMERS( 
   ID		INT              NOT NULL, 
   NAME		VARCHAR (20)     NOT NULL, 
   AGE		INT              NOT NULL, 
   ADDRESS  CHAR (25) , 
   SALARY   DECIMAL (18, 2),  
   KOD      CHAR (5),  
   PRIMARY KEY (ID));

   exec sp_columns CUSTOMERS

   END

   DELETE FROM [CUSTOMERS]

   INSERT INTO [CUSTOMERS](ID, NAME, AGE, ADDRESS, SALARY)
   VALUES (1,'Pero',25, 'Vrbovsko', 5550);

   INSERT INTO [CUSTOMERS](ID, NAME, AGE, ADDRESS, SALARY)
   VALUES (2,'Mile',50, 'Vrbovsko', 4500);

   INSERT INTO [CUSTOMERS](ID, NAME, AGE, ADDRESS, SALARY, KOD)
   VALUES (3,'Vasilije Mitu',35,'Split', 5000, '3%d');

   INSERT INTO [CUSTOMERS](ID, NAME, AGE, ADDRESS, SALARY)
   VALUES (4,'Mirko',50, 'Dražice', 5000);

  SELECT * FROM [CUSTOMERS]

  SELECT 'Samo select i pod jednostruke navodnike za ispis i točka zarez na kraju';
  
  -- ISPIS NASUMIČNIH BROJEVA PO KOLONAMA
  SELECT 5,10,15;

  SELECT 10+15;

  SELECT 10 + 15 - 5 * 2;

  SELECT NAME, SALARY
  FROM CUSTOMERS;

  SELECT SALARY, NAME
  FROM CUSTOMERS;

  SELECT SALARY, NAME
  FROM CUSTOMERS
  WHERE SALARY = 5000;
  
  SELECT NAME, SALARY
  FROM CUSTOMERS
  WHERE SALARY = 5000 OR
  NAME = 'Vasilije';

  SELECT NAME, SALARY
  FROM CUSTOMERS
  WHERE NAME LIKE '%MITU';

  SELECT NAME, SALARY
  FROM CUSTOMERS
  WHERE NAME NOT IN ('Mirko');

  -- UNION, INTERSECT I EXCEPT MORAJU IMATI ISTI BROJ STUPACA!
  SELECT NAME, SALARY, ADDRESS
  FROM CUSTOMERS
  WHERE NAME NOT IN ('Mirko', 'Mile')
  UNION
  SELECT NAME, SALARY, ADDRESS
  FROM CUSTOMERS
  WHERE NAME NOT IN ('Vasilije');

  SELECT * FROM CUSTOMERS
  ORDER BY ID DESC;

SELECT *, (CASE
WHEN NAME = 'Mile' THEN 'TO JE BIO MILE'
WHEN NAME = 'Mirko' THEN 'Mirko je bio'
END) AS NAME2 FROM CUSTOMERS;

SELECT AVG(SALARY) FROM CUSTOMERS
  WHERE ADDRESS = 'Vrbovsko';

  SELECT NAME AS 'Tko je bio', SALARY AS 'Zaradio' FROM CUSTOMERS
  ORDER BY SALARY DESC;

  SELECT NAME, SALARY
     FROM CUSTOMERS 
    WHERE SALARY >= 5000
 ORDER BY SALARY DESC, NAME;

 SELECT 'Najmanju plaću ima';
 SELECT NAME, SALARY
   FROM CUSTOMERS
   WHERE SALARY = 
    (SELECT MIN(SALARY) FROM CUSTOMERS);

	SELECT DISTINCT SALARY FROM CUSTOMERS;

	-- LOGIČKI OPERATORI

SELECT * FROM CUSTOMERS
WHERE NAME = 'Mile' OR SALARY = 5000;

SELECT * FROM CUSTOMERS
WHERE NAME != 'Mirko' AND SALARY != 4500;

-- A MOŽE I

SELECT * FROM CUSTOMERS
WHERE NOT (NAME = 'Mirko' OR SALARY = 4500);

SELECT NAME, SALARY
FROM CUSTOMERS
WHERE SALARY > 4500 AND SALARY < 5500;

-- KAD SE ISPISUJE NOVA OZNAKA KOLONE IDU DVOSTRUKI NAVODNICI
SELECT NAME, (SALARY)/1000 AS "MILJA"
FROM  CUSTOMERS
WHERE SALARY>4500;

SELECT *
FROM CUSTOMERS
WHERE SALARY IN(5000, 5550);

SELECT *
FROM CUSTOMERS
WHERE SALARY NOT IN(4000, 5550);

SELECT * 
FROM CUSTOMERS 
WHERE (NAME != 'Vasilije Mitu') 
AND SALARY IN(4500,5000,5550);

SELECT * 
FROM CUSTOMERS 
WHERE NAME BETWEEN 'M' and 'Q';

SELECT * 
FROM CUSTOMERS 
WHERE NAME NOT BETWEEN 'M' and 'Q';

SELECT *
FROM CUSTOMERS
WHERE NAME LIKE 'M%';

SELECT *
FROM CUSTOMERS
WHERE NAME LIKE 'M_R%';

/* WILDCARD ZNAKOVI
%	Any string of zero or more characters.	WHERE title LIKE '%computer%' finds all book titles with the word 'computer' anywhere in the book title.
_ (underscore)	Any single character.	WHERE au_fname LIKE '_ean' finds all four-letter first names that end with ean (Dean, Sean, and so on).
[ ]	Any single character within the specified range ([a-f]) or set ([abcdef]).	WHERE au_lname LIKE '[C-P]arsen' finds author last names ending with arsen and starting with any single character between C and P, for example Carsen, Larsen, Karsen, and so on. In range searches, the characters included in the range may vary depending on the sorting rules of the collation.
[^]	Any single character not within the specified range ([^a-f]) or set ([^abcdef]).
*/

/* SINTAKSA ZA PRETRAŽIVANJE NEKOG OD WILDCARDA UKLJUČUJE "ESCAPE" KLJUČNU RIJEČ
WHERE comment LIKE '%30!%%' ESCAPE '!'. If ESCAPE and the escape character are not specified, the Database Engine returns any rows with the string 30
NPR. WHERE col1 NOT LIKE '%/_%' ESCAPE '/';
*/
SELECT *
FROM CUSTOMERS
WHERE KOD LIKE '%/%%' ESCAPE '/';

-- ovaj not like sa escape-om mi ne radi nikako
SELECT *
FROM CUSTOMERS
WHERE KOD NOT LIKE '%/%%' ESCAPE '/';

SELECT *
FROM CUSTOMERS
WHERE KOD IS NOT NULL;

-- ARITMETIČKI OPERTORI

SELECT SUM (ID) 
FROM CUSTOMERS;

SELECT AVG (ID) 
FROM CUSTOMERS;

SELECT COUNT (DISTINCT ID) 
FROM CUSTOMERS;

SELECT COUNT (*)
FROM CUSTOMERS;

SELECT MIN (DISTINCT ID) 
FROM CUSTOMERS;

-- GROUP BY JE SLIČAN DISTINCTU ALI GRUPIRA IH
SELECT SALARY 
FROM CUSTOMERS
GROUP BY SALARY;

-- HAVING RADI SA GROUP BY, ALI NE RADI SA ORDER BY
SELECT ID,NAME,SALARY
FROM CUSTOMERS
GROUP BY NAME,ID, SALARY
HAVING SALARY BETWEEN 5000 AND 6000;

SELECT COUNT(*) 
FROM CUSTOMERS 
WHERE KOD IS NOT NULL;

SELECT AVG(SALARY) AS "Average PAY" 
   FROM CUSTOMERS;

SELECT AVG(SALARY) AS "Average PAY", 
ID AS "Company ID"
FROM CUSTOMERS
GROUP BY ID;

-- FORMATIRANJE ISPISA

SELECT name,'hiljadarki' AS 'MILJA',SALARY/1000 
FROM CUSTOMERS;

SELECT 'Ime',name,', dobije ', salary
FROM CUSTOMERS;

-- posloži po drugom stupcu
SELECT NAME AS 'Tko je bio', SALARY AS 'Zaradio' FROM CUSTOMERS
  ORDER BY 2 DESC;

-- KOMBINIRANJE TABLICA

IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[CUSTOMERS3]') AND type in (N'U'))
BEGIN
CREATE TABLE CUSTOMERS3( 
   ID		INT              NOT NULL, 
   NAME		VARCHAR (20)     NOT NULL, 
   AGE		INT              NOT NULL, 
   ADDRESS  CHAR (25) , 
   SALARY   DECIMAL (18, 2),  
   KOD      CHAR (5), 
   POBRATIM INT, 
   PRIMARY KEY (ID));

   exec sp_columns CUSTOMERS3

   END

   DELETE FROM [CUSTOMERS3]

   INSERT INTO [CUSTOMERS3](ID, NAME, AGE, ADDRESS, SALARY, POBRATIM)
   VALUES (1,'Jole',25, 'Slana', 7500, 4);

   INSERT INTO [CUSTOMERS3](ID, NAME, AGE, ADDRESS, SALARY, POBRATIM)
   VALUES (2,'Pesti',50, 'Rtina', 5000, 3);

   INSERT INTO [CUSTOMERS3](ID, NAME, AGE, ADDRESS, SALARY, KOD,POBRATIM)
   VALUES (3,'Lovre',35,'Kukovići', 6500, '4%d', 2);

   INSERT INTO [CUSTOMERS3](ID, NAME, AGE, ADDRESS, SALARY, POBRATIM)
   VALUES (4,'Ljudina',50, 'Smokvica', 6000, 1);

SELECT CUSTOMERS.name,
CUSTOMERS3.name, CUSTOMERS3.SALARY
FROM CUSTOMERS,CUSTOMERS3
WHERE CUSTOMERS.SALARY = CUSTOMERS3.SALARY;

SELECT CUSTOMERS.name,
CUSTOMERS3.name, CUSTOMERS3.SALARY
FROM CUSTOMERS,CUSTOMERS3
WHERE CUSTOMERS.SALARY <> CUSTOMERS3.SALARY;

-- jednostavnija nomenklatura za spajanje tablica
SELECT a.name,
b.name, b.SALARY
FROM CUSTOMERS a,CUSTOMERS3 b
WHERE a.SALARY = b.SALARY;

SELECT a.NAME AS "PRVI", 
a.ADDRESS, b.name AS "POBRATIM", b.ADDRESS
FROM CUSTOMERS a 
INNER JOIN CUSTOMERS3 b 
ON a.ID=b.POBRATIM;

SELECT a.NAME AS "PRVI", 
a.ADDRESS, b.name AS "POBRATIM", b.ADDRESS
FROM CUSTOMERS a 
INNER JOIN CUSTOMERS3 b 
ON a.ID=b.POBRATIM
WHERE a.SALARY > 5000;

-- NATURAL JOIN ISPISUJE SAMO JEDNOM STUPCE KOJI SE PONAVLJAJU

--uključeni svi redovi iz lijeve tablice neovisno ako imaju odgovarajuće vrijednosti u drugoj
SELECT a.NAME,a.ADDRESS,a.SALARY, 
b.name AS "DRUGI",b.ADDRESS
FROM CUSTOMERS a 
LEFT JOIN CUSTOMERS3 b 
ON a.ID=b.POBRATIM
order by a.SALARY;

SELECT a.NAME,a.ADDRESS,a.SALARY, 
b.name AS "DRUGI",b.ADDRESS
FROM CUSTOMERS a 
RIGHT JOIN CUSTOMERS3 b 
ON a.ID=b.POBRATIM
order by a.SALARY;

SELECT a.NAME,a.ADDRESS,a.SALARY, 
b.name AS "DRUGI",b.ADDRESS
FROM CUSTOMERS a 
FULL JOIN CUSTOMERS3 b 
ON a.ID=b.POBRATIM
order by a.SALARY;

--broj redova u prvoj tablici puta broj redova u drugoj
SELECT * 
FROM CUSTOMERS a 
CROSS JOIN CUSTOMERS3 b;

SELECT * 
FROM CUSTOMERS a 
CROSS JOIN CUSTOMERS3 b
where b.KOD IS NOT NULL;

-- INNER JOIN VRAĆA SVE STUPCE I SAMO ONE REDOVE GDJE IMA JEDNAKA VRIJEDNOST U JOIN STUPCU
SELECT *
FROM CUSTOMERS a 
INNER JOIN CUSTOMERS3 b 
ON a.ID=b.POBRATIM
order by a.SALARY;

-- SUBQUERIES

SELECT *
FROM CUSTOMERS
WHERE ID =
    (SELECT POBRATIM
     FROM CUSTOMERS3 
     WHERE SALARY>6500);

SELECT *
FROM CUSTOMERS
WHERE ID =
    (SELECT POBRATIM
     FROM CUSTOMERS3 
     WHERE SALARY>6500);

-- WHERE EXISTS BI TREBAO TESTIRATI IMA LI REDAKA U SUBQUERY-U, ALI NE ŠLJAKA

-- ANY je subquery koji ima jedinstvenu vrijednost
SELECT *
FROM CUSTOMERS 
WHERE NOT ID = ANY
   (SELECT POBRATIM
	FROM CUSTOMERS3
	WHERE NAME='Pesti');

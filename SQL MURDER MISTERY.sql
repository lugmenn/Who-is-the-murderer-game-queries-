-- SQL MURDER MISTERY
-- FINDING SPECIFIC CRIME AND LOCATION


SELECT *
FROM crime_scene_report
WHERE type='murder' AND city='SQL City';


-- THREE DATES RETURNED. MURDER OCCURRED ON JAN 15, 2018 (20180115)
-- INSPECTING RECORDS FROM OTHER TABLES
-- EXTRACTING DATA FROM WITNESSES

SELECT *
FROM person
WHERE address_street_name='Northwestern Dr' OR address_street_name='Franklin Ave';

SELECT *
FROM person
WHERE address_street_name='Northwestern Dr'
ORDER BY address_number;

-- NOTE: "last house on Nothrwestern Dr" is ambiguous. It could be either the highest or lowest number
-- INSPECTING THE WITNESSES INTERVIEW TESTIMONY

SELECT *
FROM interview
WHERE person_id IN('16371','14887','89906');

-- NO RESULTS FROM Kinsey Erickson, so she is discarded
-- The murderer is someone whose gym membership starts with "48Z" and car plate includes "H42W". Also, the murderer attended the gym on January 9th.

-- RETRIEVING DRIVERS INFO

SELECT *
FROM drivers_license
WHERE plate_number LIKE('%H42W%');

SELECT person.id, name, plate_number
FROM person JOIN drivers_license 
WHERE person.license_id=drivers_license.id AND plate_number LIKE('%H42W%');


-- RETRIEVING INFO FROM GYM MEMBERSHIPS WITH PEOPLE WHO ATTENDED ON JANUARY 9TH AND HAVE A GOLD MEMBERSHIP

SELECT * 
FROM get_fit_now_member me JOIN get_fit_now_check_in ci ON me.id=ci.membership_id
WHERE ci.check_in_date=20180109 AND membership_id LIKE('48Z%');


-- JOINING MEMBERS WITH SUSPECT'S CAR PLATE NUMBER

SELECT plates.name 
FROM get_fit_now_member me 
	JOIN get_fit_now_check_in ci 
	JOIN (SELECT person.id, name, plate_number
		FROM person JOIN drivers_license 
		WHERE person.license_id=drivers_license.id AND plate_number LIKE('%H42W%')) 
		AS plates
	ON me.id=ci.membership_id AND me.person_id=plates.id
WHERE ci.check_in_date=20180109 AND membership_id LIKE('48Z%');


SELECT plates. id, plates.name, plates.plate_number, me.id 
FROM get_fit_now_member me 
	JOIN get_fit_now_check_in ci 
	JOIN (SELECT person.id, name, plate_number
		FROM person JOIN drivers_license 
		WHERE person.license_id=drivers_license.id AND plate_number LIKE('%H42W%')) 
		AS plates
	ON me.id=ci.membership_id AND me.person_id=plates.id
WHERE ci.check_in_date=20180109 AND membership_id LIKE('48Z%');

-- SUSPECTS NAME: JEREMY BOWERS

-- id	     name	        plate_number	id
-- 67318	Jeremy Bowers	0H42W2	        48Z55


-- DID YOU FIND THE KILLER?

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

-- "Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime."

-- CHECKING OUT THE SUSPECT'S TESTIMONY

SELECT *
FROM interview
WHERE person_id=67318

-- FINDING WHO HIRED THE HITMAN

SELECT 
	person.id, name, height, hair_color, gender, car_make, car_model
FROM drivers_license JOIN person
	ON person.license_id=drivers_license.id
WHERE height BETWEEN 65 AND 67 
	AND hair_color="red" 
	AND (car_make='Tesla' AND car_model='Model S');


-- JOINING DATA WITH RECORDS SHOWING WHO ATTENDED THE SQL SYMPHONY EVENT 3 TIMES DURING DECEMBER 2017


SELECT suspects.name, fb.event_name, COUNT(*) AS times_attended
FROM facebook_event_checkin fb JOIN
	  (SELECT 
		  person.id, name, height, hair_color, gender, car_make, car_model
	  FROM drivers_license JOIN person
		  ON person.license_id=drivers_license.id
	  WHERE height BETWEEN 65 AND 67 
		  AND hair_color="red" 
		  AND (car_make='Tesla' AND car_model='Model S')
      ) AS suspects
ON suspects.id=fb.person_id
WHERE event_name='SQL Symphony Concert' AND date LIKE('201712%')
GROUP BY suspects.name
HAVING times_attended=3;

-- name	            event_name	            times_attended
-- Miranda Priestly	SQL Symphony Concert	3

-- DEMONSTRATING WHO IS THE MASTER MIND BEHIND THE MURDER

INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;

-- "Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!"
-- THE END
        


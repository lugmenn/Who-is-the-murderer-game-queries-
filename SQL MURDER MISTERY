##SQL MURDER MISTERY


-- FINDING SPECIFIC CRIME AND LOCATION


SELECT *
FROM crime_scene_report
WHERE type='murder' AND city='SQL City';


-- THREE DATES RETURNED. MURDER OCCURRED ON JAN 15, 2018 (20180115)

-- RECORD FROM THAT DATE SHOWS THE FOLLOWING DESCRIPTION: 	'Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".'

--INSPECTING THE OTHER TABLES RECORDS
--EXTRACTING DATA FROM WITNESSES


SELECT *
FROM person
WHERE address_street_name='Northwestern Dr' OR address_street_name='Franklin Ave';

SELECT *
FROM person
WHERE address_street_name='Northwestern Dr'
ORDER BY address_number;

-- NOTE: "last house on Nothrwestern Dr" is ambiguous. It could be either the highest or lowest number

ID      NAME            LICENCE_ID  ADDRESS_NUMBER   ADDRESS_STREET_NAME  SSN
16371	Annabel Miller	490173	    103	             Franklin Ave         318771143
14887	Morty Schapiro	118009	    4919	         Northwestern Dr	  111564949
89906	Kinsey Erickson	510019	    309	             Northwestern Dr	  635287661


-- INSPECTING THE WITNESSES INTERVIEW TESTIMONY

SELECT *
FROM interview
WHERE person_id IN('16371','14887','89906');

-- NO RESULTS FROM Kinsey Erickson, so she is discarded


person_id   transcript
14887	    I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag                   started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
16371       I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the                 9th.

-- SO, the murder is someone whose gym membership starts with "48Z" and car plate includes "H42W". Also, the murder attended the gym on January 9th.

-- RETRIEVING DRIVERS INFO

SELECT *
FROM drivers_license
WHERE plate_number LIKE('%H42W%');

SELECT person.id, name, plate_number
FROM person JOIN drivers_license 
WHERE person.license_id=drivers_license.id AND plate_number LIKE('%H42W%');

id	    name	        plate_number
51739	Tushar Chandra	4H42WR
67318	Jeremy Bowers	0H42W2
78193	Maxine Whitely	H42W0X

-- RETRIEVING INFO FROM GYM MEMBERSHIPS AND PEOPLE WHO ATTENDED ON JANUARY 9TH AND HAVE GOLD MEMBERSHIP

SELECT * 
FROM get_fit_now_member me JOIN get_fit_now_check_in ci ON me.id=ci.membership_id
WHERE ci.check_in_date=20180109;

SELECT * 
FROM get_fit_now_member me JOIN get_fit_now_check_in ci ON me.id=ci.membership_id
WHERE ci.check_in_date=20180109 AND membership_id LIKE('48Z%');


-- JOINING MEMBERS WITH SUSPECTS CAR PLATE NUMBER

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

id	     name	        plate_number	id
67318	Jeremy Bowers	0H42W2	        48Z55


-- DID YOU FIND THE KILLER?

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

-- Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.


-- CHECKING OUT THE SUSPECT'S TESTIMONY

SELECT *
FROM interview
WHERE person_id=67318

person_id	transcript
67318	    I was hired by a woman with a lot of money. I don't know her name but I know she's around               5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that                 she attended the SQL Symphony Concert 3 times in December 2017. 

-- FINDING WHO HIRED THE HITMAN

SELECT 
	person.id, name, height, hair_color, gender, car_make, car_model
FROM drivers_license JOIN person
	ON person.license_id=drivers_license.id
WHERE height BETWEEN 65 AND 67 
	AND hair_color="red" 
	AND (car_make='Tesla' AND car_model='Model S');

id	    name	         height	 hair_color	gender	car_make   car_model
78881	Red Korb	     65	     red	    female	Tesla	   Model S
90700	Regina George	 66	     red	    female	Tesla	   Model S
99716	Miranda Priestly 66	     red	    female	Tesla	   Model S


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

name	            event_name	            times_attended
Miranda Priestly	SQL Symphony Concert	3

-- DEMONSTRATING WHO IS THE MASTER MIND BEHIND THE MURDER

INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;

-- Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
        


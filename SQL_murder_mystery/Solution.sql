--Initial start of crime occurred at SQL City on JAN.15 2018

select *
from crime_scene_report
where city = 'SQL City'
and date = 20180115

--clue: Security footage shows that there were 2 witnesses. 
--The first witness lives at the last house on "Northwestern Dr". 


select *
from person
where address_street_name = 'Northwestern Dr'
order by address_number DESC
limit 1;

-- Clue: 14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949


--The second witness, named Annabel, lives somewhere on "Franklin Ave".             
select *
from person
where address_street_name = 'Franklin Ave'
and name like ('%Annabel%')
--Ans: 16371	Annabel Miller	490173	103	Franklin Ave	318771143


select *
from interview
where person_id IN (14887,16371);

 
-- Clue: 14887, gold member: starting '48Z', car with number included H42W
--I saw the murder happen, and I recognized the killer from my gym 
--when I was working out last week on January 9th.

select *
from get_fit_now_check_in
where check_in_date LIKE '20180109'

-- multiple entries in the output

select *
from get_fit_now_member
where membership_status = 'gold'
and id like '48Z%'

-- Clue: 
-- 48Z7A	28819	Joe Germuska	20160305	gold
-- 48Z55	67318	Jeremy Bowers	20160101	gold

select *
from drivers_license
where plate_number like '%H42W%'

-- Multiple outputs

-- Getting data all together
select *
from drivers_license as dl
inner join person as p on dl.id = p.license_id
inner join get_fit_now_member as gt_mem on p.id = gt_mem.person_id
inner join get_fit_now_check_in as gt_ckin on gt_mem.id = gt_ckin.membership_id
where plate_number like '%H42W%'
and membership_status = 'gold'
and gt_mem.id like '48Z%'
and check_in_date = 20180109;


select *
from interview
where person_id = 67318

-- Clue: 
-- Women hired for this murder
-- height = 5'5(65") or 5'7"(67")
-- Drives Tesla Model S
-- Attended SQL Symphony concert 3 times in Dec 2017
-- Hair color = Red


-- Final query

with fb_evnt_count as 
(
  select 
	  person_id,
	  count(*) as visits
  from facebook_event_checkin
  where date between 20171201 and 20171231
  and event_name = 'SQL Symphony Concert'
  group by person_id
  having count(*) >= 3
)
select p.*, fb.*
from drivers_license as dl
inner join person as p on dl.id = p.license_id
inner join fb_evnt_count as fb on fb.person_id = p.id
where hair_color = 'red'
and height >= 65
and height <= 67
and car_make = 'Tesla'
and car_model ='Model S' 
and gender = 'female';

-- Congratulations, I solved the Murder Mystery
-- The murderer of this case is 'Miranda Priestly'

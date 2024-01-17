-- Creating a database
create database absent;

-- Selecting the database
use absent;

-- Changing the column names (removing spaces)
alter table absenteeism_at_work
change column `Reason for absence` `reason_for_absence` int;

alter table absenteeism_at_work
change column `Month of absence` `month_of_absence` int;

alter table absenteeism_at_work
change column `Day of the week` `day_of_the_week` int;

alter table absenteeism_at_work
change column `Transportation expense` `transportation_expense` int;

alter table absenteeism_at_work
change column `Distance from Residence to Work` `distance_from_residence_to_work` int;

alter table absenteeism_at_work
change column `Service time` `service_time` int;

alter table absenteeism_at_work
change column `work_load_average/day` `work_load_average_day` text;

alter table absenteeism_at_work
change column `Hit target` `hit_target` int;

alter table absenteeism_at_work
change column `Disciplinary failure` `disciplinary_failure` int;

alter table absenteeism_at_work
change column `Social drinker` `social_drinker` int;

alter table absenteeism_at_work
change column `Social smoker` `social_smoker` int;

alter table absenteeism_at_work
change column `Body mass index` `body_mass_index` int;

alter table absenteeism_at_work
change column `Absenteeism time in hours` `absenteeism _time_in_hours` int;




-- Creating a join table with all the columns 
select * from
absenteeism_at_work a
left join compensation c
on a.id = c.id
left join reasons r on
a.reason_for_absence = r.Number;

-- Finding the healthiest employees for the bonus
create view v_healthy as
select * from absenteeism_at_work
where social_drinker = 0  and social_smoker = 0
	  and body_mass_index <25 and 
      absenteeism_time_in_hours < (select avg(absenteeism_time_in_hours) from absenteeism_at_work);
      
select * from v_healthy;


-- Creating the final joined table that I'll be importing in the power bi.
select a.id, r.Reason, month_of_absence, body_mass_index,
	   case when body_mass_index < 18.5 then 'Underweight'
			when body_mass_index between 18.5 and 24.9 then 'Healthy'
            when body_mass_index between 25 and 30 then 'Overweight'
            when body_mass_index > 30 then 'Obese'
	   else 'Unkown' end as BMI_category,
	   case when a.month_of_absence in (12,1,2) then 'Winter'
			when a.month_of_absence in (3,4,5) then 'Spring'
            when a.month_of_absence in (6,7,8) then 'Summer'
            when a.month_of_absence in (9,10,11) then 'Fall'
	   else 'Unkown' end as Season_name,
       case when a.Age < 30 then 'Young Adult'
		    when a.Age between 30 and 50 then 'Adult'
            when a.Age > 50 then 'Senior'
	   else 'Unkown' end as Age_bucket,
       Seasons, Age, day_of_the_week, transportation_expense, Education, Son,
       social_drinker, social_smoker, Pet, disciplinary_failure,
       work_load_average_day, absenteeism_time_in_hours
from
absenteeism_at_work a
left join compensation c
on a.id = c.id
left join reasons r on
a.reason_for_absence = r.Number;










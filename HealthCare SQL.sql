use health;

select * from patients;

select * from services_weekly;

select week,service,cast(patients_refused as decimal(10,2)) / patients_request as refusal_rate,patient_satisfaction,rank() over(partition by week order by (cast(patients_refused as decimal(10,2))/ patients_request)DESC) as refusal_rank
from services_weekly
where patients_request>0
order by week,refusal_rank;

SELECT
    service,
    CASE
        WHEN age <= 18 THEN 'Child'
        WHEN age > 18 AND age <= 65 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,
    AVG(DATEDIFF(departure_date, arrival_date)) AS avg_length_of_stay_days,
    COUNT(patient_id) AS total_patients
FROM
    patients
GROUP BY
    service,
    age_group
ORDER BY
    service,
    avg_length_of_stay_days DESC;
    
select * from staff_schedule;

 select sw.week,ss.service,
		Avg(sw.staff_morale) as avg_staff_morale,
        Avg(sw.patient_satisfaction) as avg_patient_satisfaction,
        sum(case when ss.role='doctor' then ss.present else 0 end) as total_doctors_present,
        sum(case when ss.role='nurse' then ss.present else 0 end) as total_nurse_present
from services_weekly sw join staff_schedule ss on sw.week=ss.week
group by sw.week,ss.service
order by ss.service,sw.week;

select s.week,
		s.month,
        s.patients_request,
        s.patients_admitted,
        s.patients_refused
from services_weekly s
where s.service='emergency'
		and s.patients_request>(
							select avg(patients_request)
                            from services_weekly
                            where service='emergency'
                            and month =s.month)
order by s.month, s.patients_request desc;

select * from staff_schedule;

(select staff_name,role,	
		sum(present) as total_weeks_present,
        'Top Performers' as performance_group
from staff_schedule
group by staff_id,staff_name,role
order by total_weeks_present Desc
limit 5)

union all
(select staff_name, role,
		sum(present) as total_weeks_present,
        'Bottom Performers' as performance_group
from staff_schedule
group by staff_id,staff_name,role
order by total_weeks_present Asc
limit 5)

order by total_weeks_present desc;
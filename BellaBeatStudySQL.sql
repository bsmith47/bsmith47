/** Show Total Distance Traveled (Cumulative)  **/

SELECT SUM(TotalDistance) AS TotalDistance
FROM bellabeat..daily_activity

SELECT *
FROM bellabeat..daily_activity
/**   5160.31999460049    **/
/**Cleaning Daily_activity**/

/** Convert Date from date / time to just date  as times were 00:00:00**/

--ALTER TABLE daily_activity
--Add ActivityDateConverted Date;

--Update daily_activity
--SET ActivityDateConverted = CONVERT(Date,ActivityDate)


SELECT 
	Id,ActivityDateConverted,TotalSteps,TotalDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance,
	SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories
FROM 
	bellabeat..daily_activity


/*****      ANALYISING   ****/
---Calculating number of users and averages and daily averages

--1) Tracking their physical activities

SELECT 
	COUNT(DISTINCT Id) AS users_tracking_activity,
	AVG(TotalSteps) AS average_steps,
	AVG(TotalDistance) AS average_distance,
	AVG(Calories) AS average_calories
FROM 
	bellabeat.dbo.daily_activity

--2) Tracking heart rate

SELECT 
	COUNT(DISTINCT Id) AS users_tracking_heartrate,
	AVG(Value) AS average_heart_rate,
	MIN(Value) AS minimum_heart_rate,
	MAX(Value) AS maximum_heart_rate
FROM	
	bellabeat.dbo.heartrate_seconds

--3) Tracking Sleep

SELECT
	COUNT(DISTINCT Id) AS users_tracking_sleep,
	AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
	MIN(TotalMinutesAsleep)/60.0 AS minimum_hours_asleep,
	MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
	AVG(TotalTimeInBed)/60.0 as average_hours_in_bed
FROM
	bellabeat.dbo.sleep_day

--4) Tracking weight

SELECT
	COUNT(DISTINCT Id) AS users_tracking_weight,
	AVG(WeightPounds) AS average_weight,
	MIN(WeightPounds) AS minimum_weight,
	MAX(WeightPounds) AS maximum_weight
FROM
	bellabeat.dbo.weight_log_info


--5)Calculate the number of days each user tracked physical activity

SELECT
	DISTINCT Id,
	COUNT(ActivityDate) OVER (PARTITION BY Id) AS days_activity_recorded
FROM 
	bellabeat.dbo.daily_activity

ORDER BY
	days_activity_recorded DESC

--6)Calculate average minutes for each activity

SELECT
	ROUND(AVG(VeryActiveMinutes), 2) AS AverageVeryActiveMinutes,
	ROUND(AVG(FairlyActiveMinutes), 2) AS AverageFairlyActiveMinutes,
	ROUND(AVG(LightlyActiveMinutes)/60.0, 2) AS AverageLightlyActiveMinutes,
	ROUND(AVG(SedentaryMinutes)/60.0, 2) AS AverageSedentaryMinutes

FROM
	bellabeat.dbo.daily_activity


-- 7)Determine time when users were mostly active
-- Top result 18:00 w/average_intensity @ 21.92
SELECT
	DISTINCT(CAST(ActivityHour AS TIME)) AS activity_time,
	AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_intensity,
	AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_METs

FROM 
	bellabeat..hourly_activity AS hourly_activity

JOIN bellabeat..minute_mets_narrow AS METs
	ON hourly_activity.Id = METs.Id AND
	hourly_activity.ActivityHour = METs.ActivityMinute

ORDER BY
	average_intensity DESC
SELECT * FROM BRIGHT.TV.VIEWERSHIP;

SELECT * FROM BRIGHT.TV.USER_PROFILE;

-----viewing the highest and lowest time
SELECT MAX(duration_2)
FROM BRIGHT.TV.VIEWERSHIP;

SELECT MIN(duration_2)
FROM BRIGHT.TV.VIEWERSHIP;

-----viewing the highest and lowest age
SELECT MAX(AGE) 
FROM BRIGHT.TV.USER_PROFILE;

SELECT MIN(AGE) 
FROM BRIGHT.TV.USER_PROFILE;

----Changing the format of the timestamp to a date and selecting the date apart
SELECT TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI') AS corrected_recorddate, 
       TO_TIME(corrected_recorddate) AS time_part
       MAX(time_part)
FROM BRIGHT.TV.VIEWERSHIP
GROUP BY ALL;

----final query
SELECT A.CHANNEL2,
       A.DURATION_2,
      COUNT(A.USERID) AS number_of_users,
      TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI') AS corrected_recorddate,
      TO_TIME(corrected_recorddate) AS time_part,
      DAYNAME(corrected_recorddate) AS day,
      MONTHNAME(corrected_recorddate) AS month,
      DAYOFMONTH(corrected_recorddate) AS day_of_month,
      B.NAME,
      B.SURNAME,
      B.GENDER,
      B.RACE,
      B.PROVINCE,
CASE 
   WHEN duration_2 BETWEEN '00:00:00' AND '00:14:59' THEN '01. 00:00:00-00:14:59: Low'
   WHEN duration_2 BETWEEN '00:15:00' AND '00:29:59' THEN '02. 00:15:00-00:29:59: Mid'
ELSE '03. =>00:30:00: High'
END AS time_Spent,
CASE 
    WHEN time_part BETWEEN '06:00:00' AND '11:59:59' THEN '01. 06:00:00-11:59:59: Morning'
    WHEN time_part BETWEEN '12:00:00' AND '17:59:59' THEN '02. 12:00:00-17:59:59: Afternoon'
    WHEN time_part BETWEEN '18:00:00' AND '23:59:59' THEN '03. 18:00:00-23:59:59: Night'
ELSE '04. >=24:00:00: Late Night'
END AS time_bucket,
CASE
    WHEN AGE BETWEEN 0 AND 12 THEN '01. 0-12: KIDS'
    WHEN AGE BETWEEN 13 AND 19 THEN '02. 13-19: TEEN'
    WHEN AGE BETWEEN 20 AND 35 THEN '03. 20-35: YOUNG ADULT'
ELSE '04. >=36: ADULT'
END AS age_group,

FROM BRIGHT.TV.VIEWERSHIP AS A
JOIN BRIGHT.TV.USER_PROFILE AS B
ON A.userid = B.userid
GROUP BY ALL;

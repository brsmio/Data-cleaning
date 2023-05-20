--Checkin Ages
select
min(age) as Min_Age,
MAX(age) as Max_Age,
round(AVG(age),2) as Avg_Age
from obesity_class

--Checking Heights
select
min(Height) as Min_Height,
MAX(Height) as Max_Height,
round(AVG(Height),2) as Avg_Height
from obesity_class

--Adding height label
alter table obesity_class
add Height_Level varchar(20)

update obesity_class
set Height_Level = case
when Height >=195 then 'Very Tall'
when Height >=180 then 'Tall'
when Height >=170 then 'Mid Height'
when Height >=150 then 'Short'
else 'Very Short'
end
from obesity_class 

--Checking for any duplicates
with dp as(
select o.*,
ROW_NUMBER() over(partition by
[ID],
[Age],
[Gender],
[Height],
[Weight],
[BMI],
[Weight_Label],
[Height_Level]
order by ID) as rn
from obesity_class o
)
select *from dp where rn > 1

--Converting height to metres
update obesity_class
set Height = (height/100) from obesity_class

--Calculating BMI
With BMI as(
select weight/SQUARE(height) as BMI from obesity_class
)
select ROUND(BMI,2) FROM BMI

--Adding BMI values 
alter table obesity_class
add Body_Mass_Index float
update obesity_class
set Body_Mass_Index = weight/SQUARE(height) from obesity_class

--Deleting the unnecessary BMI column
alter table obesity_class
drop column BMI 

--Rounding BMI values
update obesity_class
set Body_Mass_Index = ROUND(Body_Mass_Index,2)from obesity_class

--Conditioning the BMI values
select o.*,
case 
when Body_Mass_Index <18.5 then 'Underweight'
when Body_Mass_Index between 18.5 and 24.99 then 'Healthy Weight'
when Body_Mass_Index between 25 and 29.99 then 'Overweight'
when Body_Mass_Index >=30 then 'Obese'
end as BMI_Result
from obesity_class o

alter table obesity_class
add BMI_Result varchar(50)

update obesity_class
set BMI_Result = case 
when Body_Mass_Index <18.5 then 'Underweight'
when Body_Mass_Index between 18.5 and 24.99 then 'Healthy Weight'
when Body_Mass_Index between 25 and 29.99 then 'Overweight'
when Body_Mass_Index >=30 then 'Obese'
end
from obesity_class 

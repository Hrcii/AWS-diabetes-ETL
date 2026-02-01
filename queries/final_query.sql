with cte as (
select predict.hyper_id,
predict.point_id,
data.y_true,
predict.y_pred
from predict
join data on data.point_id = predict.point_id
where data.is_train = false
),

cte_1 as (
select hyper_id,
point_id,
y_true,
y_pred,
sum(power(y_pred - y_true, 2)) over (partition by hyper_id) as sse,
avg(y_true) over (partition by hyper_id) as y_mean
from cte
),

cte_2 as (
select distinct hyper_id,
sum(power(y_true - y_mean, 2)) over (partition by hyper_id) as var,
sse
from cte_1
)

select hyperparams.gamma,
hyperparams.epsilon,
hyperparams.c,
1 - cte_2.sse / cte_2.var as r2
from cte_2
join hyperparams on hyperparams.hyper_id = cte_2.hyper_id
order by r2 desc;
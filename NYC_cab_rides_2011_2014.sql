# Run in BigQuery using standard SQL against this publicly available dataset.

select
  DATE(pickup_datetime) as dt,
  SUM(CASE WHEN tip_amount = 0 THEN 1 ELSE 0 END) as card_no_tip,
  SUM(CASE WHEN tip_amount >0 THEN 1 ELSE 0 END) as card_with_tip
from
  `nyc-tlc.yellow.trips`
WHERE 1=1
  AND DATE(pickup_datetime) BETWEEN '2011-01-01' and '2015-01-01'
  AND EXTRACT(HOUR FROM (DATETIME(pickup_datetime, "America/New_York"))) BETWEEN 0 and 3
  --AND EXTRACT(HOUR FROM (DATETIME(pickup_datetime, "America/New_York"))) BETWEEN 9 and 12
  AND pickup_longitude BETWEEN -74.010472 AND -73.971076
  AND pickup_latitude BETWEEN 40.719170 AND 40.741610
  AND rate_code in ('1','6') # standard and group rates
  AND fare_amount > 0.0
  AND payment_type='CRD' # only credit card fares show non-cash tips.
GROUP BY dt
;

CREATE EXTERNAL TABLE IF NOT EXISTS `database-1`.`data` (
  `point_id` int,
  `is_train` boolean,
  `age` float,
  `sex` float,
  `bmi` float,
  `bp` float,
  `s1` float,
  `s2` float,
  `s3` float,
  `s4` float,
  `s5` float,
  `s6` float,
  `y_true` float
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  'ignore.malformed.json' = 'FALSE',
  'dots.in.keys' = 'FALSE',
  'case.insensitive' = 'TRUE',
  'mapping' = 'TRUE'
)
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://s3-diabetes-bucket/diabetes_data/'
TBLPROPERTIES ('classification' = 'json');
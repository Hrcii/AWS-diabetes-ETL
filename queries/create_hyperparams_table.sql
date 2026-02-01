CREATE EXTERNAL TABLE IF NOT EXISTS `database-1`.`hyperparams` (
  `hyper_id` int,
  `gamma` float,
  `c` float,
  `epsilon` float
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  'ignore.malformed.json' = 'FALSE',
  'dots.in.keys' = 'FALSE',
  'case.insensitive' = 'TRUE',
  'mapping' = 'TRUE'
)
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://s3-diabetes-bucket/hyper/'
TBLPROPERTIES ('classification' = 'json');
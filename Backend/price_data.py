import pandas as pd 
from datetime import datetime

timestr = datetime.now().strftime('%d/%m/%Y').split('/')
time_var = f"{timestr[-1]}-{timestr[-2]}"

PREMISE_DATA_URL = 'https://storage.data.gov.my/pricecatcher/lookup_premise.parquet'
ITEM_DATA_URL = 'https://storage.data.gov.my/pricecatcher/lookup_item.parquet'
PRICE_DATA_URL = f'https://storage.data.gov.my/pricecatcher/pricecatcher_{time_var}.parquet'


premise_df = pd.read_parquet(PREMISE_DATA_URL)
if 'date' in premise_df.columns: premise_df['date'] = pd.to_datetime(premise_df['date'])

price_df = pd.read_parquet(PRICE_DATA_URL)
if 'date' in price_df.columns: price_df['date'] = pd.to_datetime(price_df['date'])

item_df = pd.read_parquet(ITEM_DATA_URL)
if 'date' in item_df.columns: item_df['date'] = pd.to_datetime(item_df['date'])

joint_df = pd.merge(item_df, price_df, how='inner', on='item_code')
joint_df = pd.merge(joint_df, premise_df, how='inner', on='premise_code')

recent_df = joint_df[joint_df['date'] == joint_df['date'].max()]
result_df = recent_df.loc[:, ['item_code', 'item','unit','price','premise_code']].drop_duplicates()


# import psycopg2

# # Connect to PostgreSQL
# conn = psycopg2.connect(
#     host="localhost",
#     database="kitahackDB",
#     user="postgres",
#     password="dataZen963",
#     port=8888  # change if different
# )

# cursor = conn.cursor()


# # Create table
# create_table_query = """
# CREATE TABLE IF NOT EXISTS price_data (
#     premise_code integer,
#     premise TEXT NOT NULL, 
#     address TEXT NOT NULL, 
#     premise_type TEXT NOT NULL,
#     state TEXT NOT NULL,
#     district TEXT NOT NULL,
#     item_code integer NOT NULL,
#     item TEXT NOT NULL, 
#     unit TEXT NOT NULL, 
#     item_group TEXT NOT NULL, 
#     item_category TEXT NOT NULL,
#     price REAL NOT NULL,
#     info_date DATE NOT NULL
# );
# """

# cursor.execute(create_table_query)
# conn.commit() 

# print(datetime.now().strftime('%d/%m/%Y'))
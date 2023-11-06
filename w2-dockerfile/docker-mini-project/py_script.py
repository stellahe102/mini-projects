import pandas as pd
import os
import glob

input_path=os.environ['INPUT_DIR']
output_path=os.environ['OUTPUT_DIR']

csv_path=glob.glob(os.path.join(input_path, '*.csv'))
output_filename='all_year.csv'
df_list=list()

for i in csv_path:
    df=pd.read_csv(i, index_col=None, header=0)
    df_list.append(df)
df_concat=pd.concat(df_list, axis=0, ignore_index=True)
df_concat.to_csv(output_path+"/"+output_filename)
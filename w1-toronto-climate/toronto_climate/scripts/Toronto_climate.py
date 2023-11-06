import pandas as pd
import glob
import os

input_path = '/home/ubuntu/Miniproject/week1/input'
output_path = '/home/ubuntu/Miniproject/week1/output'
final_file_name = 'all_years.csv'
individual_file_path = glob.glob(os.path.join(input_path, '*.csv'))

file_list=list()
for i in individual_file_path:
    df = pd.read_csv(i, index_col=None, header=0)
    file_list.append(df)
final_df = pd.concat(file_list, axis=0, ignore_index=True)
final_df.to_csv(output_path+"/"+final_file_name)
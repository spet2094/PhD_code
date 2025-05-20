# generic packages
import os
from os.path import isfile, join
import glob
import subprocess
import re

#dataframe packages
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# plot packages
import matplotlib as mpl
import matplotlib.pyplot as plt
import pylab as plt
import seaborn as sns
sns.set(style="darkgrid")

#maps
import geopandas as gpd
import plotly.express as px
import json


occ_input_path= "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/06_Data and Modelling/thesis_data/model_output/d_occupation_case_counts/"
occ_output_path= "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/06_Data and Modelling/thesis_data/model_output/d_occupation_case_counts/plots/"

prefixes = [
    ('output_workplaceBubblesSophie_', 'bubblesNorm'),
    ('output_perfectMixingSophie_', 'perfMix'),
    ('output_schoolToHomeSophie_', 'schoolToHome'),
    ('output_schoolToComSophie_', 'schoolToCom'),
    ('output_comWorkToHomeSophie_', 'comWorkersToHome'),
    ('output_workToHomeSophie_', 'workToHome'),
    ('output_allToHomeSophie_', 'allToHome'),
    ('output_BubblesLd_', 'bubblesLd'),
    ('output_BubblesLd_', 'bubblesLdv2'),
    ('output_BubblesLd1a_', 'bubblesLd_1a'),
    ('output_BubblesLd1b_', 'bubblesLd_1b'),
    ('output_BubblesLd2a_', 'bubblesLd_2a'),
    ('output_BubblesLd2b_', 'bubblesLd_2b'),
    ('output_BubblesLd3a_', 'bubblesLd_3a'),
    ('output_BubblesLd3b_', 'bubblesLd_3b')
]
# Define the folder path
folder_path = occ_input_path

# Loop through each file_prefix and id_prefix pair
for file_prefix, id_prefix in prefixes:

# Use glob to find all files with the specified prefix
    file_pattern = f"{folder_path}/{file_prefix}*.txt"
    file_list = glob.glob(file_pattern)


# Initialize an empty list to store individual DataFrames
    df_list = []


# Loop through the list of files and read each one into a DataFrame
    for file in file_list:
        df = pd.read_csv(file, delimiter='\t')# Adjust delimiter as per your file format
    # Extract the run number from the filename
        run_number = os.path.basename(file).split('_')[2]
        df['run']=int(run_number)
        df_list.append(df)

# Concatenate all DataFrames in the list into a single DataFrame
    final_df = pd.concat(df_list, ignore_index=True)
# Convert the 'run_number' column to numeric (int64)
    final_df['run'] = pd.to_numeric(final_df['run'])
# Display the resulting DataFrame
    final_df.head()

    # just keep the number with covid  
    r_data=final_df[final_df['metric']== 'number_with_covid']
    r_data_pop = final_df[final_df['metric']=='number_in_occ']

#r_data.set_index('day', inplace=True)
    r_data.to_csv(occ_output_path+f'{id_prefix}_cases_occ.csv')
    r_data_pop.to_csv(occ_output_path+f'{id_prefix}_tots_occ.csv')

    r_data.head()
    r_data_pop.head()

    # make the plots without melting occs into one column  

    sns.set_palette(sns.color_palette("husl",20))  # You can replace "husl" with another palette name like "pastel", "deep", etc.
    # Plotting the data
    plt.figure(figsize=(10, 6))

    sns.lineplot(data=r_data, x="day", y="AG_ESTATES", ci='sd', label="agriculture workers") 
    sns.lineplot(data=r_data, x="day", y="RELIGIOUS", ci='sd', label='religious') 
    sns.lineplot(data=r_data, x="day", y="STUDENTS_TEACHERS", ci='sd', label='education') 
    sns.lineplot(data=r_data, x="day", y="MANU_MINING_TRADES", ci='sd', label='manufacturing or mining workers')
    sns.lineplot(data=r_data, x="day", y="SERVICE_RETAIL", ci='sd', label='service worker') 
    sns.lineplot(data=r_data, x="day", y="INFORMAL_PETTY_TRADE", ci='sd', label='informal worker') 
    sns.lineplot(data=r_data, x="day", y="UNEMPLOYED_NOT_AG", ci='sd', label='unemployed') 
    sns.lineplot(data=r_data, x="day", y="SUBSISTENCE_AG", ci='sd',label='subsistence agriculture') 
    sns.lineplot(data=r_data, x="day", y="POLICE_ARMY", ci='sd', label='police or army')
    sns.lineplot(data=r_data, x="day", y="OFFICE_WORKERS", ci='sd', label='office worker')
    sns.lineplot(data=r_data, x="day", y="TRANSPORT_SECTOR", ci='sd', label='transport worker')
    sns.lineplot(data=r_data, x="day", y="HEALTHCARE_SOCIAL_WORK", ci='sd', label='health or social worker')
    sns.lineplot(data=r_data, x="day", y="INACTIVE", ci='sd', label='inactive')

    # Adding titles and labels
    plt.title(f'{id_prefix} Cases Over Time by Occupation', size=18)
    plt.xlabel('Time')
    plt.ylabel('Number of Cases')
    plt.legend(title='Occupations')
    plt.xlim(0,99)
    plt.ylim(0,12000)
    plt.grid(True)

    # export the plot 
    plt.savefig(occ_output_path+f'{id_prefix}_occ_cases_over_time.png', dpi=300)

        # create list of just the proportions of people with covid in each occupation 
    r_data_t = r_data.transpose().reset_index()
    new_header = r_data_t.iloc[0]
    r_data_t=r_data_t.drop(r_data_t.index[0:2])
    r_data_t.columns=new_header
    r_data_t.set_index('day', inplace=True)
    # rename index col to reflect the occupation
    r_data_t.rename_axis(index ={'day':'occupation'}, inplace=True)

    # combine the two datasets and make each the proportion of the population for each day 

    comb_prop_occ=pd.merge(r_data, r_data_pop, on =['day','run'], how='outer', suffixes=('_c', '_tot'), indicator=True)
    merge_counts = comb_prop_occ['_merge'].value_counts()
    print(merge_counts)

    comb_prop_occ= comb_prop_occ.drop(columns=['Unnamed: 16_tot', '_merge', 'metric_c'])
    comb_prop_occ.to_csv(occ_output_path+f'{id_prefix}_prop_test_occ.csv')
    ## looks fine 1000 obs means 10 runs, so good. 
    comb_prop_occ.head()

    # Identify columns with _c and _tot suffixes
    c_columns = [col for col in comb_prop_occ.columns if col.endswith('_c')]
    tot_columns = [col for col in comb_prop_occ.columns if col.endswith('_tot')]

    # Create new columns by dividing _c columns by corresponding _tot columns
    for c_col in c_columns:
        tot_col = c_col.replace('_c', '_tot')
        if tot_col in comb_prop_occ.columns:
            new_col = c_col.replace('_c', '_perc')
            comb_prop_occ[new_col] = (comb_prop_occ[c_col] /  (comb_prop_occ[tot_col] * 100)) *100000  #this is cases per 100 days per 100,000 people

    # Drop the original _c and _tot columns
    columns_to_drop = c_columns + tot_columns
    comb_prop_occ = comb_prop_occ.drop(columns=columns_to_drop)

    comb_prop_occ.head()


    sns.set_palette(sns.color_palette("husl",20))  # You can replace "husl" with another palette name like "pastel", "deep", etc.
    # Plotting the data
    plt.figure(figsize=(10, 6))

    sns.lineplot(data=comb_prop_occ, x="day", y="AG_ESTATES_perc", label="agriculture workers") 
    sns.lineplot(data=comb_prop_occ, x="day", y="RELIGIOUS_perc",  label='religious') 
    sns.lineplot(data=comb_prop_occ, x="day", y="STUDENTS_TEACHERS_perc",label='education') 
    sns.lineplot(data=comb_prop_occ, x="day", y="MANU_MINING_TRADES_perc", label='manufacturing or mining workers')
    sns.lineplot(data=comb_prop_occ, x="day", y="SERVICE_RETAIL_perc",  label='service worker') 
    sns.lineplot(data=comb_prop_occ, x="day", y="INFORMAL_PETTY_TRADE_perc", label='informal worker') 
    sns.lineplot(data=comb_prop_occ, x="day", y="UNEMPLOYED_NOT_AG_perc", label='unemployed') 
    sns.lineplot(data=comb_prop_occ, x="day", y="SUBSISTENCE_AG_perc", label='subsistence agriculture') 
    sns.lineplot(data=comb_prop_occ, x="day", y="POLICE_ARMY_perc", label='police or army')
    sns.lineplot(data=comb_prop_occ, x="day", y="OFFICE_WORKERS_perc", label='office worker')
    sns.lineplot(data=comb_prop_occ, x="day", y="TRANSPORT_SECTOR_perc", label='transport worker')
    sns.lineplot(data=comb_prop_occ, x="day", y="HEALTHCARE_SOCIAL_WORK_perc",  label='health or social worker')
    sns.lineplot(data=comb_prop_occ, x="day", y="INACTIVE_perc", label='inactive')

    # Adding titles and labels
    plt.title(f'{id_prefix} Case Prevalence per 100,000 by Occupation', size=18)
    plt.xlabel('Time')
    plt.ylabel('Number of Cases')
    plt.legend(title='Occupations')
    plt.xlim(0,99)
    #plt.ylim(0,5)
    plt.grid(True)

    # export the plot 
    plt.savefig(occ_output_path+f'{id_prefix}_p_occ_cases_over_time.png', dpi=300)

    # make the plots without melting occs into one column  
    columns = ['AG_ESTATES', 'RELIGIOUS', 'STUDENTS_TEACHERS', 'MANU_MINING_TRADES','SERVICE_RETAIL', 'INFORMAL_PETTY_TRADE','UNEMPLOYED_NOT_AG','SUBSISTENCE_AG','POLICE_ARMY', 'OFFICE_WORKERS', 'TRANSPORT_SECTOR',
            'HEALTHCARE_SOCIAL_WORK', 'INACTIVE', 'OTHER']

    comb_prop_occ=comb_prop_occ.drop(columns=['run'])

    # first need to just use averages, because the CIs create too much error 
    # Loop over the columns and compute cumulative sums
    for col in columns:
        comb_prop_occ[f'{col}_perc'] = comb_prop_occ.groupby(['day'])[f'{col}_perc'].mean()

    comb_prop_occ.to_csv(occ_output_path+f'{id_prefix}_av_p_cases_by_occ.csv')
    comb_prop_occ.head()


    sns.set_palette(sns.color_palette('hsv',13))  # You can replace "husl" with another palette name like "pastel", "deep", etc.
    # Plotting the data
    plt.figure(figsize=(10, 6))

    sns.lineplot(data=comb_prop_occ, x="day", y="AG_ESTATES_perc", label="agriculture workers") 
    sns.lineplot(data=comb_prop_occ, x="day", y="RELIGIOUS_perc",  label='religious') 
    sns.lineplot(data=comb_prop_occ, x="day", y="STUDENTS_TEACHERS_perc",label='education') 
    sns.lineplot(data=comb_prop_occ, x="day", y="MANU_MINING_TRADES_perc", label='manufacturing or mining workers')
    sns.lineplot(data=comb_prop_occ, x="day", y="SERVICE_RETAIL_perc",  label='service worker') 
    sns.lineplot(data=comb_prop_occ, x="day", y="INFORMAL_PETTY_TRADE_perc", label='informal worker') 
    sns.lineplot(data=comb_prop_occ, x="day", y="UNEMPLOYED_NOT_AG_perc", label='unemployed') 
    sns.lineplot(data=comb_prop_occ, x="day", y="SUBSISTENCE_AG_perc", label='subsistence agriculture') 
    sns.lineplot(data=comb_prop_occ, x="day", y="POLICE_ARMY_perc", label='police or army')
    sns.lineplot(data=comb_prop_occ, x="day", y="OFFICE_WORKERS_perc", label='office worker')
    sns.lineplot(data=comb_prop_occ, x="day", y="TRANSPORT_SECTOR_perc", label='transport worker')
    sns.lineplot(data=comb_prop_occ, x="day", y="HEALTHCARE_SOCIAL_WORK_perc",  label='health or social worker')
    sns.lineplot(data=comb_prop_occ, x="day", y="INACTIVE_perc", label='inactive')

    # Adding titles and labels
    plt.title(f'{id_prefix} Case Prevalence per 100,000 by Occupation', size=18)
    plt.xlabel('Time')
    plt.ylabel('Number of Cases')
    plt.legend(title='Occupations')
    plt.xlim(0,99)
    plt.ylim(0,70)
    plt.grid(True)

    # export the plot 
    plt.savefig(occ_output_path+f'{id_prefix}_av_p_occ_cases.png', dpi=300)


    # Deaths by occupation
    # create another one which is number who died from covid  in each occ 

    r_data=final_df[final_df['metric']== 'number_died_from_covid']
    r_data.set_index('day', inplace=True)
    r_data.to_csv(occ_output_path+f'{id_prefix}_test.csv')
    r_data.head()

    columns = ['AG_ESTATES', 'RELIGIOUS', 'STUDENTS_TEACHERS', 'MANU_MINING_TRADES','SERVICE_RETAIL', 'INFORMAL_PETTY_TRADE','UNEMPLOYED_NOT_AG','SUBSISTENCE_AG','POLICE_ARMY', 'OFFICE_WORKERS', 'TRANSPORT_SECTOR',
            'HEALTHCARE_SOCIAL_WORK', 'INACTIVE']

    # so I want for within each run, that it will make the cumulative sum of the deaths per occupation, so that way I keep the confidence intervals

    # Sort the DataFrame by 'day'
    r_data = r_data.sort_values(by=['run','day'])

    # Loop over the columns and compute cumulative sums
    for column in columns:
        r_data[f'{column}_cum_sum'] = r_data.groupby(['run'])[column].cumsum()
        
    r_data.head()
    r_data.to_csv(occ_output_path+f'{id_prefix}_test_rdata.csv')

    # now reshape the data across occupations
    # Reset the index so 'day' becomes a column

    columns = ['AG_ESTATES_cum_sum', 'RELIGIOUS_cum_sum', 'STUDENTS_TEACHERS_cum_sum', 'MANU_MINING_TRADES_cum_sum','SERVICE_RETAIL_cum_sum', 'INFORMAL_PETTY_TRADE_cum_sum','UNEMPLOYED_NOT_AG_cum_sum','SUBSISTENCE_AG_cum_sum','POLICE_ARMY_cum_sum', 'OFFICE_WORKERS_cum_sum', 'TRANSPORT_SECTOR_cum_sum',
            'HEALTHCARE_SOCIAL_WORK_cum_sum', 'INACTIVE_cum_sum']

    r_data = r_data.reset_index()
    df_melted = pd.melt(r_data, id_vars=['day', 'run'], value_vars=columns, var_name='occupation', value_name='cum_deaths')

    # Remove the suffix '_cum_sum' from all values in the 'column_with_suffix'
    df_melted['occupation'] = df_melted['occupation'].str.replace('_cum_sum', '', regex=False)


    df_melted.to_csv(occ_output_path+f'{id_prefix}_test_cs.csv')
    df_melted.head()

    # Plotting the cumulative deaths by occupation
    plt.figure(figsize=(10, 6))

    sns.lineplot(data=df_melted, x="day", y="cum_deaths", hue="occupation", ci='sd') 

    # Adding titles and labels
    plt.title(f'{id_prefix} Cumulative Deaths Over Time by Occupation', size=18)
    plt.xlabel('Day')
    plt.ylabel('Number of Cumulative Deaths')
    plt.legend(title='Occupations')
    plt.xlim(0,90)
    plt.ylim(0,800)
    plt.grid(True)

    # export the plot 
    plt.savefig(occ_output_path+f'{id_prefix}_occ_deaths_over_time.png', dpi=300)
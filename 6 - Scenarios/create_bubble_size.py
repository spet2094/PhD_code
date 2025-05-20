import pandas as pd
import numpy as np

# ---------------------- locate data files and specify output filepath ------------------------------------
bubble_size_data_filepath = "/Users/robbiework/Library/CloudStorage/OneDrive-UniversityCollegeLondon/data/bubble_runs/" \
                            "to_inform_census_bubbles_comb_occ5_xposed.xlsx"
# bubble_size_data_filepath = ""
census_stata_filepath = "/Users/robbiework/Library/CloudStorage/OneDrive-UniversityCollegeLondon/data/bubble_runs/" \
                        "ipums_5p_2012_preprocessed.dta"
# census_stata_filepath = ""

output_file = "/Users/robbiework/PycharmProjects/spacialEpidemiologyAnalysis/census_generation/" \
              "ipums_5p_wp_bubbles_comb_teacher_students.csv"
# output_file = ""
# --------------------------------------------------------------------------------------------------------------------
# read in the census stata file
census = pd.read_stata(census_stata_filepath)
# create a dummy variable name for the workplace id
census['workplace_id'] = ['none'] * len(census)
# create occupation column in format used by model
census['economic_status'] = census['occ5']
# create school goer id in format used for model
census['school_goers'] = ['1' if i == 'In school' else '0' for i in census.empstatd]
# create district id column in format used by model
census['district_id'] = ['d_' + str(i) for i in census['new_district_id']]
# need to case age to integers, create column to do so
census = census.dropna(subset=['age'])
census['age_int'] = census['age'].astype(int)
# Sort of sex strings
# census['sex'] = [str(i).split(' ')[1] for i in census.sex]
#
# for age_code in census.age.unique():
#     try:
#         census.loc[census['age'] == age_code, 'age_int'] = [int(age_code)] * \
#                                                            len(census.loc[census['age'] == age_code, 'age_int'])
#     except ValueError:
#         if age_code == '1 year':
#             census.loc[census['age'] == age_code, 'age_int'] = [1] * \
#                                                                len(census.loc[census['age'] == age_code, 'age_int'])
#         if age_code == 'Less than 1 year':
#             census.loc[census['age'] == age_code, 'age_int'] = [0] * \
#                                                                len(census.loc[census['age'] == age_code, 'age_int'])
#         if age_code == '2 years':
#             census.loc[census['age'] == age_code, 'age_int'] = [2] * \
#                                                                len(census.loc[census['age'] == age_code, 'age_int'])
# get a list of columns we want
columns_we_want = ['age_int', 'sex', 'serial', 'workplace_id', 'district_id', 'economic_status', 'school_goers']
# remove entries with na values in these columns
census = census.dropna(subset=columns_we_want)
# create a person id column
census['person_id'] = range(0, len(census))
# only take the following columns into the output file
columns_we_want = ['person_id', 'age_int', 'sex', 'serial', 'workplace_id', 'district_id', 'economic_status',
                   'school_goers']
census = census[columns_we_want]
# rename some columns so they fit with the model framework
census = census.rename(columns={'serial': 'household_id', 'age_int': 'age'})
# load in the bubble size data
bubble_size = pd.read_excel(bubble_size_data_filepath, sheet_name='Sheet2')
bubble_size = bubble_size.set_index('work_bubble')

# get a list of occupations that appear in the census
# census['economic_status'] = [str(i).split(' ')[1] for i in census.economic_status]
occs = census.economic_status.unique()

# get a list of locations that appear in the census
locations = census.district_id.unique()
# loop over the locations and occupations that appear in the census
for loc in locations:
    print(loc)
    for occ in occs:
        print(occ)
        if occ == 'inactive':
            pass
        elif occ == 'unemployed_not_ag':
            pass
        elif occ == 'transport_sector':
            pass
        elif occ == 'religious':
            pass
        elif occ == 'informal_petty_trade':
            pass
        else:
            print('Generating bubbles...')
            # filter the census file to get the people in location 'loc' that have occupation 'occ', store this as a new
            # dataframe
            people_in_loc_with_occ = census.loc[(census['economic_status'] == occ) & (census['district_id'] == loc)]
            # get the initial number of people who meet the above criteria
            number_of_people_not_in_bubble = len(people_in_loc_with_occ)
            # create a number to assign to the bubble numbers (note this is reset when we look at different
            # location/occupation combos
            group_id_generator = 1
            # use a while loop to create the workplace bubbles, this loop keeps going until the randomly generated
            # bubble size is greater than the remaining number of people without an assigned bubble
            while number_of_people_not_in_bubble > 0:
                bubble_size_for_this = np.random.choice(bubble_size.columns, p=np.divide(bubble_size.loc[occ].values,
                                                        sum(bubble_size.loc[occ].values)))
                bubble_size_for_this = int(bubble_size_for_this)

                # bubble sizes are self-reported so a bubble size of 0 means they have no co-workers, and have a bubble size
                # of one (just themselves) adjust the generated bubble size below
                bubble_size_for_this += 1
                # if the generated bubble size is greater than the remaining people exit the loop and move on
                if bubble_size_for_this > len(people_in_loc_with_occ):
                    break
                # sample from the people in a location based on the bubble size created above
                people_in_bubble = people_in_loc_with_occ.sample(n=bubble_size_for_this)
                # create the workplace bubble for these people
                census.loc[people_in_bubble.index, 'workplace_id'] = str(loc) + "_" + occ + "_" + str(group_id_generator)
                # update the group_id number so that the next group will have a different workplace id
                group_id_generator += 1
                # calculate the number of people who don't have a workplace bubble again
                number_of_people_not_in_bubble = number_of_people_not_in_bubble - len(people_in_bubble)
                # remove the people we have just assigned a workplace bubble to from the pool of people we are going to
                # assign bubbles to
                people_in_loc_with_occ = census.loc[(census['economic_status'] == occ) & (census['district_id'] == loc) &
                                                    (census['workplace_id'] == 'none')]
            # randomly assign the remaining people into existing bubbles
            straddlers = census.loc[(census['economic_status'] == occ) & (census['district_id'] == loc) &
                                    (census['workplace_id'] == 'none')]
            other_group_ids = census.loc[(census['economic_status'] == occ) & (census['district_id'] == loc) &
                                         (census['workplace_id'] != 'none'), 'workplace_id'].unique()
            for straddler in straddlers.index:
                try:
                    census.loc[straddler, 'workplace_id'] = np.random.choice(other_group_ids)
                except ValueError:
                    census.loc[straddlers.index, 'workplace_id'] = str(loc) + "_" + occ + "_" + str(group_id_generator)
                    # print("No existing bubbles to place these people into, reached this part of the code as the bubble size"
                    #       " initially selected for " + occ + " in " + loc + " was too large. Creating a new bubble for all "
                    #       "these people")
                    break

census.to_csv(output_file)

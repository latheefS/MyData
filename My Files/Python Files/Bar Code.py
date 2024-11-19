import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


# Prompt the user for the CSV file path
csv_file_path = input("Enter the CSV file path: ")

# Ensure the file path ends with ".csv"
if not csv_file_path.lower().endswith(".csv"):
    csv_file_path += ".csv"

def mark_others(row):
    if row['result'] != 'Passed' and row['result'] != 'Failed' and row['result'] != 'N/A':
        row['result'] = 'Others'
    return row

# Read the CSV file into a pandas DataFrame
try:
    df = pd.read_csv(csv_file_path)
    df['result'] = df['result'].fillna('N/A')
    df = df.apply(mark_others, axis=1)
except FileNotFoundError:
    print(f"File '{csv_file_path}' not found. Please check the path and try again.")
    exit()


# Step 1: Read the CSV file
#csv_file_path = 'C:/Users/LatheefS/Desktop/AT Python Files/x_ve1_maximise_test_results.csv'
#df = pd.read_csv(csv_file_path)
#df.fillna('NA', inplace = True)
df['result']=df['result'].fillna('N/A')
def mark_others(row):
    if row['result'] != 'Passed' and row['result'] != 'Failed' and row['result'] != 'N/A':
        row['result'] = 'Others'
    return row

df = df.apply(mark_others,axis=1)

print(df.to_string())

# Step 2: Generate Pie Chart
# Assuming your 'Result' column contains distinct values (e.g., 'Passed', 'Failed', etc.)
result_counts = df['result'].value_counts()

# Define custom colors for each value
colors = {
    'Passed': '#7bdcb5',
    'Failed': '#f78da7',
    'Others': '#fcb900',
    # Add more colors for other values if needed
}

# Create the donut pie chart
plt.figure(figsize=(8, 6))

# Calculate the total count
total_count = result_counts.sum()

# Plot the center text (total count)
plt.text(0, 0, f"{total_count}", fontsize=12, ha='center', va='center')

# Create the pie chart
wedges, _, _ = plt.pie(result_counts, labels=result_counts.index,
                       colors=[colors.get(val, '#abb8c3') for val in result_counts.index],
                       autopct='', pctdistance=0.85,wedgeprops={'edgecolor': 'w'})

# Add individual counts on each wedge
for wedge, count in zip(wedges, result_counts):
    angle = (wedge.theta2 - wedge.theta1) / 2.0 + wedge.theta1
    x = 0.85 * np.cos(np.deg2rad(angle))
    y = 0.85 * np.sin(np.deg2rad(angle))
    plt.text(x, y, str(count), ha='center', va='center')

# Draw a white circle at the center to create the donut effect
centre_circle = plt.Circle((0, 0), 0.50, fc='white')
fig = plt.gcf()
fig.gca().add_artist(centre_circle)

# Add title and legend
plt.title(r"$\bf{Release\ Overview}$", color='brown')
plt.legend(result_counts.index, loc='upper right', prop={'weight': 'bold'})


# Display the plot
plt.axis('equal')  # Equal aspect ratio ensures a circular pie chart
plt.show()


# Step 3: Generate Bar Chart
unique_results = list(set(list(df['result'])))
color_map = {}
for val in unique_results:
    if val == 'Passed':
        color_map[val] = "#7bdcb5"
    elif val == 'Failed':
        color_map[val] = "#f78da7"
    elif val == 'Others':
        color_map[val] = "#fcb900"
    else:
        color_map[val] = "#abb8c3"

bargraph=sns.countplot(x='test_area',hue='result',data=df,palette=color_map)
sns.set(rc={'figure.figsize':(10,10)})
for i in bargraph.containers:
    bargraph.bar_label(i, )

# Customize plot properties
plt.title("Results By Test Area", color='brown', fontsize=14, weight='bold')
plt.xlabel("Test Area")
plt.ylabel("No.of Tests")
plt.legend(loc='upper right', prop={'weight': 'bold'})

# Show the plot
plt.show()

#Generate list of tests
test_list_df=df[["test_id","test_name","test_area"]]
print(test_list_df.to_string())

#Generate list of tests passed
test_passed_df=df[df["result"]=='Passed']
test_passed_df=test_passed_df[["test_id","test_name","test_area","test_duration","result"]]
print(test_passed_df.to_string())

#Generate list of tests failed
test_failed_df=df[df["result"]=='Failed']
test_failed_df=test_failed_df[["test_id","test_name","test_area","failed_step","reasons","error_message","result"]]
print(test_failed_df.to_string())
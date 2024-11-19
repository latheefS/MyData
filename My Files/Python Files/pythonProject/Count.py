import pandas as pd

csv_file_path = r"C:\Users\LatheefS\Desktop\PythonAI\input\x_ve1_maximise_test_results.csv"
df = pd.read_csv(csv_file_path)

# 1
print("\n1.Total Number of Tests:")
print(" * Total Tests Conducted:", df.shape[0])

# 2
p_v = df['result'].value_counts()
print("\n2.Number of Tests Passed and Failed:")
print(" * Passed:", p_v.values.tolist()[0])
print(" * Failed:", p_v.values.tolist()[1])

# 3
group = df.groupby('test_area')
test_results = group['result'].value_counts()
columns = test_results.index.tolist()
counts = test_results.values.tolist()
names = []
results = []
for c in columns:
    names.append(c[0])
    results.append(c[1])
dff = pd.DataFrame({'test_area': names, 'results': results, 'counts': counts})
print("\n3.Pass Rate and Fail Rate by Module (Test Area):")
print(dff.to_string(index=False))

# 4
test_area_counts = df['test_area'].value_counts().to_dict()
result_counts = df.groupby(['test_area', 'result']).size().unstack(fill_value=0)
print("\n4. Breakdown by Test Area:")
for test_area, total_tests in test_area_counts.items():
    passed = result_counts.loc[test_area, 'Passed'] if 'Passed' in result_counts.columns else 0
    failed = result_counts.loc[test_area, 'Failed'] if 'Failed' in result_counts.columns else 0
    print(f"{test_area}:{total_tests} tests ({passed} Passed, {failed} Failed)")

# 5
test_areas = ['AP', 'AR', 'GL', 'PO']
results = {}
for area in test_areas:
    area_data = df[df['test_area'] == area]
    pass_count = area_data[area_data['result'] == 'Passed'].shape[0]
    total_count = area_data.shape[0]
    pass_rate = pass_count / total_count if total_count > 0 else 0
    fail_rate = 1 - pass_rate
    results[area] = {'Pass Rate': pass_rate, 'Fail Rate': fail_rate}

print("\n5. Insights by Test Area:")
for area, rates in results.items():
    print(f"{area}: Pass Rate: {rates['Pass Rate']:.2%}, Fail Rate: {rates['Fail Rate']:.2%}")


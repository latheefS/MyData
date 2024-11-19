import math
#import docx
from spire.doc import *
from spire.doc.common import *
import pandas as pd

# Read csv file
csv_file_path = 'C:/Users/LatheefS/Desktop/AT Python Files/x_ve1_maximise_test_results.csv'
df = pd.read_csv(csv_file_path)
df = df.fillna('N/A')
# Generate list of tests failed
test_failed_df = df[df["result"] == 'Failed']
test_failed_df = test_failed_df[["test_id", "test_name", "failed_step", "reasons", "error_message"]]
# Create a Document object
doc = Document()

# Add a section
section = doc.AddSection()

# Create a table
table = section.AddTable(True)

# Specify table data
header_data=list(test_failed_df.columns)
row_data=list(test_failed_df.itertuples(index=False, name=None))

# Set the row number and column number of table
table.ResetCells(len(row_data) + 1, len(header_data))

# Set the width of table
#table.PreferredWidth = PreferredWidth(WidthType.Percentage, int(100))
table.PreferredWidth = PreferredWidth(WidthType.Percentage, int(80))

# Get header row
headerRow = table.Rows[0]
headerRow.IsHeader = True
headerRow.Height = 23
headerRow.RowFormat.BackColor = Color.get_LightGray()

# Fill the header row with data and set the text formatting
i = 0
while i < len(header_data):
    '''
    if header_data[i] == 'reason':
        headerRow.Cells[i].SetCellWidth(15, CellWidthType.Percentage);'''
    headerRow.Cells[i].CellFormat.VerticalAlignment = VerticalAlignment.Middle
    paragraph = headerRow.Cells[i].AddParagraph()
    paragraph.Format.HorizontalAlignment = HorizontalAlignment.Center
    txtRange = paragraph.AppendText(header_data[i])
    txtRange.CharacterFormat.Bold = True
    txtRange.CharacterFormat.FontSize = 10
    i += 1
print("Fill the header row with data and set the text formatting done")
#'''
# Fill the rest rows with data and set the text formatting
r = 0
while r < len(row_data):
    dataRow = table.Rows[r + 1]

    #dataRow.Height = 40
    #dataRow.HeightType = TableRowHeightType.Exactly
    c = 0
    print("outer while done")
    while c < len(row_data[r]):
        print("inner while done")
        dataRow.Cells[c].CellFormat.VerticalAlignment = VerticalAlignment.Top
        paragraph = dataRow.Cells[c].AddParagraph()
        #paragraph.Format.HorizontalAlignment = HorizontalAlignment.Center
        paragraph.Format.HorizontalAlignment = HorizontalAlignment.Left
        print("before txtRange")
        txtRange =  paragraph.AppendText(row_data[r][c])
        print("after txtRange")
        txtRange.CharacterFormat.FontSize = 9
        c += 1
    r += 1
print("Fill the rest rows with data and set the text formatting done")
'''
# Alternate row color
for j in range(1, table.Rows.Count):
    if math.fmod(j, 2) == 0:
        row2 = table.Rows[j]
        for f in range(row2.Cells.Count):
            row2.Cells[f].CellFormat.BackColor = Color.get_LightBlue()'''
#'''
# Set the border of table
table.TableFormat.Borders.BorderType = BorderStyle.Single
table.TableFormat.Borders.LineWidth = 1.0
table.TableFormat.Borders.Color = Color.get_Black()

# Save the document
doc.SaveToFile("Table3.docx", FileFormat.Docx2013)
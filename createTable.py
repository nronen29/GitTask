import openpyxl
from openpyxl.worksheet.table import Table, TableStyleInfo

# Create a new workbook and select the active sheet
wb = openpyxl.Workbook()
ws = wb.active

# Data for the table (5x5 table)
data = [
    ['Header1', 'Header2', 'Header3', 'Header4', 'Header5'],
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [11, 12, 13, 14, 15],
    [16, 17, 18, 19, 20]
]

# Add data to the worksheet
for row in data:
    ws.append(row)

# Define the table range (from cell A1 to E5)
table = Table(displayName="Table1", ref="A1:E5")

# Apply table style
style = TableStyleInfo(showFirstColumn=False, showLastColumn=False,
                       showRowStripes=True, showColumnStripes=True)
table.tableStyleInfo = style

# Add the table to the worksheet
ws.add_table(table)

# Save the workbook
wb.save("5x5_table.xlsx")

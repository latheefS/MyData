import docx
from docx import Document

start_bold = "\033[1m"
end_bold = "\033[0m"

doc = docx.Document()

IntroPara = "This document details the results of the <Version> Quarterly Update Testing. As per Oracle’s timetable for quarterly releases for wave <number>, the upgrade took place on non-production environments on the <day(dd/mm/yy)>, and into the production environment on the <day(dd/mm/yy)>."

# Words you want to highlight
words_to_highlight = ["<Version>", "<number>", "<day(dd/mm/yy)>"]

# Loop through the words and apply bold formatting
for word in words_to_highlight:
    IntroPara = IntroPara.replace(word, f"{start_bold}{word}{end_bold}")

IntPara = IntroPara

print(IntPara)
doc.add_paragraph(IntPara)
doc.save('Report.docx')
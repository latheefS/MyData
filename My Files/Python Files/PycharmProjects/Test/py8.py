# Define the ANSI escape sequences for bold and italic text
start_bold = "\033[1m"
end_bold = "\033[0m"
start_italic = "\033[3m"
end_italic = "\033[0m"

# Your three paragraphs assigned to variables
paragraph1 = "This document details the results of the <Version> Quarterly Update Testing.  As per Oracle’s timetable for quarterly releases for wave <number>, the upgrade took place on non-production environments on the <day(dd/mm/yy)>, and into the production environment on the <day (dd/mm/yy)>."
paragraph2 = "This document details the results of the <Version> Quarterly Update Testing.  As per Oracle’s timetable for quarterly releases for wave <number>, the upgrade took place on non-production environments on the <day(dd/mm/yy)>, and into the production environment on the <day (dd/mm/yy)>."
paragraph3 = "This document details the results of the <Version> Quarterly Update Testing.  As per Oracle’s timetable for quarterly releases for wave <number>, the upgrade took place on non-production environments on the <day(dd/mm/yy)>, and into the production environment on the <day (dd/mm/yy)>."

# Words you want to highlight
words_to_highlight = {
    "<Version>": (start_bold, end_bold),
    "contains": (start_bold + start_italic, end_italic + end_bold),
    "terms": (start_bold + start_italic, end_italic + end_bold),
    "second": (start_bold + start_italic, end_italic + end_bold),
    "we": (start_bold, end_bold),
    "words": (start_bold, end_bold),
    "third": (start_bold, end_bold)
}

# Loop through words and apply formatting
for word, (start_format, end_format) in words_to_highlight.items():
    paragraph1 = paragraph1.replace(word, f"{start_format}{word}{end_format}")
    paragraph2 = paragraph2.replace(word, f"{start_format}{word}{end_format}")
    paragraph3 = paragraph3.replace(word, f"{start_format}{word}{end_format}")

# Print the modified paragraphs
print(f"Paragraph 1: {paragraph1}")
print(f"Paragraph 2: {paragraph2}")
print(f"Paragraph 3: {paragraph3}")

# Define the ANSI escape sequences for formatting
start_bold = "\033[1m"
end_bold = "\033[0m"
start_italic = "\033[3m"
end_italic = "\033[0m"
start_underline = "\033[4m"
end_underline = "\033[0m"

# Your provided paragraphs
paragraph1 = "This is the first paragraph with specific words."
paragraph2 = "The second paragraph contains other specific terms and second."
paragraph3 = "In the third paragraph, we highlight additional words and third."

# Words to highlight and their corresponding formatting
highlight_words = {
    "first": (start_bold + start_italic, end_italic + end_bold),
    "with": (start_bold + start_italic, end_italic + end_bold),
    "words": (start_bold + start_italic, end_italic + end_bold),
    "second": (start_bold, end_bold),
    "contains": (start_bold, end_bold),
    "specific": (start_bold, end_bold),
    "and": (start_bold, end_bold),
    "third": (start_underline, end_underline),
    "we": (start_underline, end_underline),
    "additional": (start_underline, end_underline)
}

# Function to apply formatting to words in a paragraph
def format_paragraph(paragraph, words_to_format):
    for word, (start_format, end_format) in words_to_format.items():
        paragraph = paragraph.replace(word, f"{start_format}{word}{end_format}")
    return paragraph

# Apply formatting to each paragraph
formatted_paragraph1 = format_paragraph(paragraph1, highlight_words)
formatted_paragraph2 = format_paragraph(paragraph2, highlight_words)
formatted_paragraph3 = format_paragraph(paragraph3, highlight_words)

# Print the modified paragraphs
print(f"Formatted Paragraph 1: {formatted_paragraph1}")
print(f"Formatted Paragraph 2: {formatted_paragraph2}")
print(f"Formatted Paragraph 3: {formatted_paragraph3}")

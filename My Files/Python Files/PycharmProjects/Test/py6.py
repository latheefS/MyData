# Define the ANSI escape sequences for bold text
start_bold = "\033[1m"
end_bold = "\033[0m"

# Your three paragraphs assigned to variables
paragraph1 = "This is the first paragraph with specific words."
paragraph2 = "The second paragraph contains other specific terms."
paragraph3 = "In the third paragraph, we highlight additional words."

# Words you want to highlight
words_to_highlight = ["specific", "other", "additional"]

# Loop through paragraphs and apply bold formatting
for word in words_to_highlight:
    paragraph1 = paragraph1.replace(word, f"{start_bold}{word}{end_bold}")
    paragraph2 = paragraph2.replace(word, f"{start_bold}{word}{end_bold}")
    paragraph3 = paragraph3.replace(word, f"{start_bold}{word}{end_bold}")

# Print the modified paragraphs
print(f"Paragraph 1: {paragraph1}")
print(f"Paragraph 2: {paragraph2}")
print(f"Paragraph 3: {paragraph3}")

# Define the ANSI escape sequences for bold text
start_bold = "\033[1m"
end_bold = "\033[0m"

# Your three paragraphs
paragraphs = [
    "This is the first paragraph with specific words.",
    "The second paragraph contains other specific terms.",
    "In the third paragraph, we highlight additional words."
]

# Words you want to highlight
words_to_highlight = ["specific", "other", "additional"]

# Loop through paragraphs and apply bold formatting
for i, paragraph in enumerate(paragraphs):
    for word in words_to_highlight:
        paragraphs[i] = paragraph.replace(word, f"{start_bold}{word}{end_bold}")

# Print the modified paragraphs
for i, modified_paragraph in enumerate(paragraphs):
    print(f"Paragraph {i + 1}: {modified_paragraph}")
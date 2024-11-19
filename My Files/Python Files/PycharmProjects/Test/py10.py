# Define the ANSI escape sequences for bold text
start_bold = "\033[1m"
end_bold = "\033[0m"

# Your three paragraphs assigned to variables
paragraph1 = "This is the first paragraph with specific words."
paragraph2 = "The second paragraph contains other specific terms and second."
paragraph3 = "In the third paragraph, we highlight additional words and third."

# Words you want to highlight
words_to_highlight = {
    "specific": paragraph1,
    "contains": paragraph2,
    "terms": paragraph2,
    "second": paragraph2,
    "we": paragraph3,
    "words": paragraph3,
    "third": paragraph3
}

# Loop through words and apply bold formatting
for word, paragraph in words_to_highlight.items():
    words_to_highlight[word] = paragraph.replace(word, f"{start_bold}{word}{end_bold}")

# Print the modified paragraphs
print(f"Paragraph 1: {words_to_highlight['specific']}")
print(f"Paragraph 2: {words_to_highlight['contains']}")
print(f"Paragraph 3: {words_to_highlight['third']}")
# Define the ANSI escape sequences for bold text
start_bold = "\033[1m"
end_bold = "\033[0m"

# Your paragraph
paragraph = "This is an example paragraph with specific words."

# Words you want to highlight
words_to_highlight = ["example", "specific"]

# Loop through the words and apply bold formatting
for word in words_to_highlight:
    paragraph = paragraph.replace(word, f"{start_bold}{word}{end_bold}")

# Print the modified paragraph
print(paragraph)

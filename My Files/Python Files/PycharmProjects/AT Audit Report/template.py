from docx import Document
from docxtpl import DocxTemplate

# Load your Word template
template_path = "my_word_template.docx"
doc = DocxTemplate(template_path)

# Define your data (assuming you have a DataFrame named 'df')
data = {
    'company_name': 'World Company',
    # Add other data fields as needed
}

# Render the template with the data
doc.render(data)

# Save the populated Word document
output_path = "generated_doc.docx"
doc.save(output_path)

print(f"Word document saved at {output_path}")
import requests
import pandas as pd
from bs4 import BeautifulSoup
import openpyxl


def validate_url(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Check for any HTTP errors
        return True
    except requests.RequestException:
        return False


def save_to_excel(lines, keyword, filename):
    df = pd.DataFrame(lines, columns=["Extracted Lines"])
    sheet_name = f"Keyword_{keyword}_Count_{len(lines)}"
    df.to_excel(filename, sheet_name=sheet_name, index=False)


def main(sheet_name=None):
    user_url = input("Enter a URL: ")
    user_keyword = input("Enter a keyword to search: ")

    if not validate_url(user_url):
        print("Invalid URL. Please enter a valid URL.")
        return

    try:
        response = requests.get(user_url)
        soup = BeautifulSoup(response.content, "html.parser")
        page_text = soup.get_text()

        # Extract lines containing the keyword
        lines_with_keyword = [line.strip() for line in page_text.splitlines() if user_keyword.lower() in line.lower()]

        print(f"Keyword '{user_keyword}' appears {len(lines_with_keyword)} times on the page.")

        # Save to an Excel file
        output_filename = "extracted_lines.xlsx"
        save_to_excel(lines_with_keyword, user_keyword, output_filename)
        print(f"Extracted lines saved to {output_filename} (Sheet name: {sheet_name})")

    except requests.RequestException:
        print("Error fetching content from the URL. Please try again later.")


if __name__ == "__main__":
    main()

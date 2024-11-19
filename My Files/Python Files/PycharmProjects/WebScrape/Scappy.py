from datetime import datetime
import pandas as pd
import requests
from bs4 import BeautifulSoup


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
    dt = str((datetime.today()).strftime("%m%d%Y_%H%M%S"))
    filename = filename + '_' + dt + '.xlsx'
    df.to_excel(filename, sheet_name=sheet_name, index=False)
    print(f"Extracted lines saved to {filename} (Sheet name: {sheet_name})")


def main():
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
        output_filename = user_keyword+"_extracted_lines"
        save_to_excel(lines_with_keyword, user_keyword, output_filename)

    except requests.RequestException:
        print("Error fetching content from the URL. Please try again later.")


if __name__ == "__main__":
    main()

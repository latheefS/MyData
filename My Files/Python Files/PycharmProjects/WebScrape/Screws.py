import requests
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime
import traceback


def get_word_count_and_line(word,text):
    word_count = text.lower().count(word)
    lines = text.split('\n')
    word_lines = [line for line in lines if word in line.lower()]
    return word_count,word_lines

try:
    url = input('Enter the url to search:')
    user_word = input('Enter the word to search:')
    word = user_word.lower()
    response=requests.get(url)
    if response.ok:
        soup = BeautifulSoup(response.content, 'html.parser')
        page_text = soup.text
        #body=soup.find('body')
        #body_text = body.text
        req_count,req_lines=get_word_count_and_line(word,page_text)
        print(f"keyword:{word} count:{req_count}")
        sheet_name = f"Keyword_{user_word}_Count_{req_count}"
        df = pd.DataFrame(req_lines,columns=['Extracted_lines'])
        dt = str((datetime.today()).strftime("%m%d%Y_%H%M%S"))
        filename = f'{user_word}_extracted_lines_'+dt+'.xlsx'
        df.to_excel(filename,sheet_name=sheet_name, index=False)
    else :
        print('unable to access the url')
except:
    print(traceback.format_exc())
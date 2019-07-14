from bs4 import BeautifulSoup
from selenium import webdriver
import json

with open('dapp.json', 'r') as f:
	data = json.load(f)
	

def OpenBrowser(link):
	options = webdriver.ChromeOptions()
	options.add_argument("headless")
	browser = webdriver.Chrome('/Users/lmcmz/Downloads/chromedriver', chrome_options=options)
	browser.set_window_size(2400,1000)
	browser.get(link)
	soup = BeautifulSoup(browser.page_source, 'lxml')
	content = soup.find("div", class_="DappDetailBodyContentCtas")
	link = content.find("a")['href']
	browser.close()
	return link

dapps_json = []
for dapp in data:
	link = "https://www.stateofthedapps.com" + dapp["link"]
	new_link = OpenBrowser(link)
	new_link = new_link.replace("?utm_source=StateOfTheDApps","")
	dapp["link"] = new_link
	print(new_link)
	dapps_json.append(dapp)
	
with open('dapp.json', 'w') as fp:
	json.dump(dapps_json, fp, indent=4)
	
#soup = BeautifulSoup(browser.page_source, 'lxml')


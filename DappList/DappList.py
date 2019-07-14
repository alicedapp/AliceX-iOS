from bs4 import BeautifulSoup
from selenium import webdriver
import json

options = webdriver.ChromeOptions()
options.add_argument("headless")
browser = webdriver.Chrome('/Users/lmcmz/Downloads/chromedriver', chrome_options=options)
browser.set_window_size(2400,1000)
browser.get('https://www.stateofthedapps.com/rankings/platform/ethereum')
soup = BeautifulSoup(browser.page_source, 'lxml')

#dapp_list = soup.find_all(")
#print(soup)

dapp_list = soup.find_all("div", class_="table-row")
dapp_list.pop(0)

dapps_json = []

for dapp in dapp_list:
	link = dapp.find("a", class_="icon-link")['href']
	img = dapp.find("img", class_="icon-image")['src']
	name = dapp.find("h4", class_="name").text
	desc = dapp.find("p").text
	category = dapp.find("div", class_="RankingTableCategory").a.string
#	
	dapp_dict = {}
	dapp_dict['link'] = link
	dapp_dict['img'] = img
	dapp_dict['name'] = name
	dapp_dict['description'] = desc
	dapp_dict['category'] = category
	
	dapps_json.append(dapp_dict)
	
	print(name)
	

with open('dapp.json', 'w') as fp:
	json.dump(dapps_json, fp, indent=4)
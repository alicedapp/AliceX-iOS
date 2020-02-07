import json

with open("response.json", 'r') as f:
	data = json.load(f)
	
erc20List = data["payload"]["data"] # 169


finalList = []

for coin in erc20List:
	info = dict()
	info["address"] = coin["address"]
	info["decimals"] = coin["decimals"]
	info["name"] = coin["name"]
	info["symbol"] = coin["symbol"]
	finalList.append(info)
	
print(finalList)

with open('data.json', 'w', encoding='utf-8') as f:
	json.dump(finalList, f, ensure_ascii=False, indent=4)
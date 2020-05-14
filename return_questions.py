import json

f = open('all_qanda.json', 'r', encoding="utf-8_sig")
j = json.load(f)

questions = dict()
for w in j:
    questions.setdefault(w['id'],(w['question']))

return questions

# 回答
# print(j[0]['answer'])

import json
from flask import jsonify
import requests

# 送られてきたものを形態素解析 return:array
def generate_morphes(query):
    url = 'http://maapi.net/apis/mecapi'
    text = query
    params = {
        'sentence': text,
        'format': 'json'
    }
    r = requests.get(url, params=params)
    list = json.loads(r.text)

    words = []
    for data in list:
        pos = data['feature'].split(',')[0]
        if pos != '名詞':
            continue
        words.append(data['surface'])

    words = set(words)
    return words

# jsonの取得,成形
def return_question():
    f = open('all_qanda.json', 'r', encoding="utf-8_sig")
    j = json.load(f)

    questions = dict()
    for w in j:
        questions.setdefault(w['id'],(w['question']))

    return questions

# 質問からjsonのキーと値を取得
def return_result(words,questions):
    result = dict()
    keys = []

    for w in words:
        for q in questions.values():
            if w in q:
                keys = [k for k, v in questions.items() if v == q]
                for k in keys:
                    result.setdefault(k,q)
    return result

def return_answer(result):
    f = open('all_qanda.json', 'r', encoding="utf-8_sig")
    j = json.load(f)
    length = len(result.keys())
    message = "検索結果:" + str(length) + "件\n"

    if length == 0:
        message += '質問が見つかりませんでした、キーワードを変更してください'
    else:
        cnt = 1
        for key in result.keys():
            message += "Q" + str(cnt) + ':' + j[key]['question'] +"\nA:" + j[key]['answer'] +"\n\n"
            cnt = cnt + 1
    return message

def format_slack_message(message):
    return {
    'response_type': 'in_channel',
    'text': message,
    'attachments': []
    }

#メイン
def start_search(request):
    # validate request
    if request.method != 'POST':
        return 'Only POST requests are accepted', 405

    words = generate_morphes(request.form['text'])
    if not words:
        response = format_slack_message('質問が見つかりません、キーワードを変更してください')
        return jsonify(response)
    else:
        questions = return_question()
        result = return_result(words,questions)
        message = return_answer(result)
        response = format_slack_message(message)
        return jsonify(response)

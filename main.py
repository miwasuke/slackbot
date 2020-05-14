import json
from flask import jsonify
import MeCab


# ここで検索文字の分かち書き return:array
def generate_morphemes(query):
    me = MeCab.Tagger()
    question = me.parse(query)

    # 名詞のみ取り出す
    words = []
    morphemes = question.splitlines()
    for line in morphemes:
        if line == 'EOS':
            continue

        surface, pos = line.split()
        pos = pos.split(',')

        if pos[0] != '名詞':
            continue

        words.append(surface)
    return query


# 質問を検索 return:dict
def search_question():
    f = open('all_qanda.json', 'r', encoding="utf-8")
    j = json.load(f)
    return j

def format_slack_message(message):
    return {
    'response_type': 'in_channel',
    'text': message,
    'attachments': []
    }


# メイン
def start_search(request):
    # validate request
    if request.method != 'POST':
        return 'Only POST requests are accepted', 405

    message = generate_morphemes(request.form['text'])
    response = format_slack_message(message)

    return jsonify(response)

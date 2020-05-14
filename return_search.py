import MeCab

# 送られてきたqueryから名詞を取り出し検索文字のリストとして返す
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

words = set(words)
return words

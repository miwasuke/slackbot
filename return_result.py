words = ['リモート','テレワーク']

questions = {0: 'リモート', 1: 'Zoomが落ちました。', 2: '他のオンライン動画アプリ（例えばTeamsなど）を起動中、Zoomの音声だけミュートしたい場合はどうすれば良いですか。', 3: '会議をしながら皆で同時に作業をすることはできますか。', 4:'テレワークの'}

result = dict()
keys = []

for w in words:
    for q in questions.values():
        if w in q:
            keys = [k for k, v in questions.items() if v == q]
            for k in keys:
                result.setdefault(k,q)

#koko
print(result)

from metadata import metadata
from quran_script_indo_pak import fullQuranIndoPak as quranIndoPak
from quran_uthmani import quranUthmani
from quran_numbers import quran_numbers
# print(quran[0]['text_indopak'])
# f = open("test.txt", "a" ,encoding='utf-8')
# for x in fullQuranIndoPak:

#     f.write(str(x['text_indopak']) + '\n')

# f.close()

f = open("test.txt", "a", encoding='utf-8')

for index, x in enumerate(quranUthmani):
    # print(x['text'] + '\n')
    # for verse in quranIndoPak:
    f.write(str(
        {
            "index": x['index'],
            "surah": x['sura'],
            "ayah": x['aya'],
            'text': quranIndoPak[index]['text_indopak']
        },
    ) + ',' + '\n')

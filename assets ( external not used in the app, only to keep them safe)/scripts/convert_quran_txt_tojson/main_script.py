from metadata import metadata
from quran_uthmani_old import quranUthmaniOld as data

outputFile = open("output.json", mode="w+", encoding="utf-8")

# scriptfile = open("script.txt", mode="r+", encoding="utf-8")
uthmaniNewScriptFile = open("Uthmanic Hafs v17 Ayah by Ayah.txt",
                            mode="r+", encoding="utf-8")

indoPakNewScriptFile = open("Indopak.v.9.5-WITH-SPACERS-Madinah-Ayah by Ayah.txt",
                            mode="r+", encoding="utf-8")

tajweedTransliteration = open("Tajweed Transliteration v1 Alpha Ayah without Numbers.txt",
                              mode="r+", encoding="utf-8")

uthmaniV20Script = open("Uthmanic Hafs v20 Ayah by Ayah without Numbers.txt",
                        mode="r+", encoding="utf-8")


for index, arabicAya in enumerate(uthmaniV20Script):

    # print(data)
    outputFile.write(
        f'{{"index":{data[index]["index"]},\n "sura" : {data[index]["sura"]},\n"aya" : {data[index]["aya"]},\n"text": "{arabicAya.strip()}" }},\n')

    print(index)


print("finished")

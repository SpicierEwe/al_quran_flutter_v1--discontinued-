import os
from allah_names import allah_names_with_english_translation
from allah_names import allah_names_urdu_meaning
from asmaa import allah_name_more_info
from rasool_allah_names import rasool_allah_names_arabic, rasool_allah_names_english, rasool_allah_names_english_meaning

file = open('allahNamesResult.dart', 'a', encoding='utf-8')
file.write('final allahNames = [\n')
for index, e in enumerate(allah_names_with_english_translation):

    file.write(
        f'{{ "arabic_name": "{e[0]}", \n "english_name" :"{e[1]}" ,\n "english_meaning":"{e[2]}", \n "urdu_meaning" : "{allah_names_urdu_meaning[index]}",\n }},\n')
file.write('];\n')

# *************************************************************************************************************************
# *************************************************************************************************************************
# *************************************************************************************************************************
file = open('rassolallahNamesResult.dart', 'a', encoding='utf-8')


file.write('final rasoolAllahNames = [\n')

for index, e in enumerate(rasool_allah_names_arabic):
    file.write(
        f'{{"arabic_name":"{e}" ,\n "english_name":"{rasool_allah_names_english[index]}" , \n "english_meaning":"{rasool_allah_names_english_meaning[index]},", \n}},')

file.write('];\n')


print('arabic names = ' + str(len(rasool_allah_names_arabic)))
print('english names = ' + str(len(rasool_allah_names_english)))
print('english meanings = ' + str(len(rasool_allah_names_english_meaning)))

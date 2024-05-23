# import pyrebase
#
# # # file = open("C:\\Users\\SKYLINE\Desktop\\test.txt", mode='a')
# # import encodings
# #
# # #
# #
# # import json
# #
surah = [
    {"surah_name": "Al-Faatiha", "total_ayahs": 7, "surah_number": 1},
    {"surah_name": "Al-Baqara", "total_ayahs": 286, "surah_number": 2},
    {"surah_name": "Aal-i-Imraan", "total_ayahs": 200, "surah_number": 3},
    {"surah_name": "An-Nisaa", "total_ayahs": 176, "surah_number": 4},
    {"surah_name": "Al-Maaida", "total_ayahs": 120, "surah_number": 5},
    {"surah_name": "Al-An'aam", "total_ayahs": 165, "surah_number": 6},
    {"surah_name": "Al-A'raaf", "total_ayahs": 206, "surah_number": 7},
    {"surah_name": "Al-Anfaal", "total_ayahs": 75, "surah_number": 8},
    {"surah_name": "At-Tawba", "total_ayahs": 129, "surah_number": 9},
    {"surah_name": "Yunus", "total_ayahs": 109, "surah_number": 10},
    {"surah_name": "Hud", "total_ayahs": 123, "surah_number": 11},
    {"surah_name": "Yusuf", "total_ayahs": 111, "surah_number": 12},
    {"surah_name": "Ar-Ra'd", "total_ayahs": 43, "surah_number": 13},
    {"surah_name": "Ibrahim", "total_ayahs": 52, "surah_number": 14},
    {"surah_name": "Al-Hijr", "total_ayahs": 99, "surah_number": 15},
    {"surah_name": "An-Nahl", "total_ayahs": 128, "surah_number": 16},
    {"surah_name": "Al-Israa", "total_ayahs": 111, "surah_number": 17},
    {"surah_name": "Al-Kahf", "total_ayahs": 110, "surah_number": 18},
    {"surah_name": "Maryam", "total_ayahs": 98, "surah_number": 19},
    {"surah_name": "Taa-Haa", "total_ayahs": 135, "surah_number": 20},
    {"surah_name": "Al-Anbiyaa", "total_ayahs": 112, "surah_number": 21},
    {"surah_name": "Al-Hajj", "total_ayahs": 78, "surah_number": 22},
    {"surah_name": "Al-Muminoon", "total_ayahs": 118, "surah_number": 23},
    {"surah_name": "An-Noor", "total_ayahs": 64, "surah_number": 24},
    {"surah_name": "Al-Furqaan", "total_ayahs": 77, "surah_number": 25},
    {"surah_name": "Ash-Shu'araa", "total_ayahs": 227, "surah_number": 26},
    {"surah_name": "An-Naml", "total_ayahs": 93, "surah_number": 27},
    {"surah_name": "Al-Qasas", "total_ayahs": 88, "surah_number": 28},
    {"surah_name": "Al-Ankaboot", "total_ayahs": 69, "surah_number": 29},
    {"surah_name": "Ar-Room", "total_ayahs": 60, "surah_number": 30},
    {"surah_name": "Luqman", "total_ayahs": 34, "surah_number": 31},
    {"surah_name": "As-Sajda", "total_ayahs": 30, "surah_number": 32},
    {"surah_name": "Al-Ahzaab", "total_ayahs": 73, "surah_number": 33},
    {"surah_name": "Saba", "total_ayahs": 54, "surah_number": 34},
    {"surah_name": "Faatir", "total_ayahs": 45, "surah_number": 35},
    {"surah_name": "Yaseen", "total_ayahs": 83, "surah_number": 36},
    {"surah_name": "As-Saaffaat", "total_ayahs": 182, "surah_number": 37},
    {"surah_name": "Saad", "total_ayahs": 88, "surah_number": 38},
    {"surah_name": "Az-Zumar", "total_ayahs": 75, "surah_number": 39},
    {"surah_name": "Al-Ghaafir", "total_ayahs": 85, "surah_number": 40},
    {"surah_name": "Fussilat", "total_ayahs": 54, "surah_number": 41},
    {"surah_name": "Ash-Shura", "total_ayahs": 53, "surah_number": 42},
    {"surah_name": "Az-Zukhruf", "total_ayahs": 89, "surah_number": 43},
    {"surah_name": "Ad-Dukhaan", "total_ayahs": 59, "surah_number": 44},
    {"surah_name": "Al-Jaathiya", "total_ayahs": 37, "surah_number": 45},
    {"surah_name": "Al-Ahqaf", "total_ayahs": 35, "surah_number": 46},
    {"surah_name": "Muhammad", "total_ayahs": 38, "surah_number": 47},
    {"surah_name": "Al-Fath", "total_ayahs": 29, "surah_number": 48},
    {"surah_name": "Al-Hujuraat", "total_ayahs": 18, "surah_number": 49},
    {"surah_name": "Qaaf", "total_ayahs": 45, "surah_number": 50},
    {"surah_name": "Adh-Dhaariyat", "total_ayahs": 60, "surah_number": 51},
    {"surah_name": "At-Tur", "total_ayahs": 49, "surah_number": 52},
    {"surah_name": "An-Najm", "total_ayahs": 62, "surah_number": 53},
    {"surah_name": "Al-Qamar", "total_ayahs": 55, "surah_number": 54},
    {"surah_name": "Ar-Rahmaan", "total_ayahs": 78, "surah_number": 55},
    {"surah_name": "Al-Waaqia", "total_ayahs": 96, "surah_number": 56},
    {"surah_name": "Al-Hadid", "total_ayahs": 29, "surah_number": 57},
    {"surah_name": "Al-Mujaadila", "total_ayahs": 22, "surah_number": 58},
    {"surah_name": "Al-Hashr", "total_ayahs": 24, "surah_number": 59},
    {"surah_name": "Al-Mumtahana", "total_ayahs": 13, "surah_number": 60},
    {"surah_name": "As-Saff", "total_ayahs": 14, "surah_number": 61},
    {"surah_name": "Al-Jumu'a", "total_ayahs": 11, "surah_number": 62},
    {"surah_name": "Al-Munaafiqoon", "total_ayahs": 11, "surah_number": 63},
    {"surah_name": "At-Taghaabun", "total_ayahs": 18, "surah_number": 64},
    {"surah_name": "At-Talaaq", "total_ayahs": 12, "surah_number": 65},
    {"surah_name": "At-Tahrim", "total_ayahs": 12, "surah_number": 66},
    {"surah_name": "Al-Mulk", "total_ayahs": 30, "surah_number": 67},
    {"surah_name": "Al-Qalam", "total_ayahs": 52, "surah_number": 68},
    {"surah_name": "Al-Haaqqa", "total_ayahs": 52, "surah_number": 69},
    {"surah_name": "Al-Ma'aarij", "total_ayahs": 44, "surah_number": 70},
    {"surah_name": "Nooh", "total_ayahs": 28, "surah_number": 71},
    {"surah_name": "Al-Jinn", "total_ayahs": 28, "surah_number": 72},
    {"surah_name": "Al-Muzzammil", "total_ayahs": 20, "surah_number": 73},
    {"surah_name": "Al-Muddaththir", "total_ayahs": 56, "surah_number": 74},
    {"surah_name": "Al-Qiyaama", "total_ayahs": 40, "surah_number": 75},
    {"surah_name": "Al-Insaan", "total_ayahs": 31, "surah_number": 76},
    {"surah_name": "Al-Mursalaat", "total_ayahs": 50, "surah_number": 77},
    {"surah_name": "An-Naba", "total_ayahs": 40, "surah_number": 78},
    {"surah_name": "An-Naazi'aat", "total_ayahs": 46, "surah_number": 79},
    {"surah_name": "Abasa", "total_ayahs": 42, "surah_number": 80},
    {"surah_name": "At-Takwir", "total_ayahs": 29, "surah_number": 81},
    {"surah_name": "Al-Infitaar", "total_ayahs": 19, "surah_number": 82},
    {"surah_name": "Al-Mutaffifin", "total_ayahs": 36, "surah_number": 83},
    {"surah_name": "Al-Inshiqaaq", "total_ayahs": 25, "surah_number": 84},
    {"surah_name": "Al-Burooj", "total_ayahs": 22, "surah_number": 85},
    {"surah_name": "At-Taariq", "total_ayahs": 17, "surah_number": 86},
    {"surah_name": "Al-A'laa", "total_ayahs": 19, "surah_number": 87},
    {"surah_name": "Al-Ghaashiya", "total_ayahs": 26, "surah_number": 88},
    {"surah_name": "Al-Fajr", "total_ayahs": 30, "surah_number": 89},
    {"surah_name": "Al-Balad", "total_ayahs": 20, "surah_number": 90},
    {"surah_name": "Ash-Shams", "total_ayahs": 15, "surah_number": 91},
    {"surah_name": "Al-Lail", "total_ayahs": 21, "surah_number": 92},
    {"surah_name": "Ad-Dhuhaa", "total_ayahs": 11, "surah_number": 93},
    {"surah_name": "Ash-Sharh", "total_ayahs": 8, "surah_number": 94},
    {"surah_name": "At-Tin", "total_ayahs": 8, "surah_number": 95},
    {"surah_name": "Al-Alaq", "total_ayahs": 19, "surah_number": 96},
    {"surah_name": "Al-Qadr", "total_ayahs": 5, "surah_number": 97},
    {"surah_name": "Al-Bayyina", "total_ayahs": 8, "surah_number": 98},
    {"surah_name": "Az-Zalzala", "total_ayahs": 8, "surah_number": 99},
    {"surah_name": "Al-Aadiyaat", "total_ayahs": 11, "surah_number": 100},
    {"surah_name": "Al-Qaari'a", "total_ayahs": 11, "surah_number": 101},
    {"surah_name": "At-Takaathur", "total_ayahs": 8, "surah_number": 102},
    {"surah_name": "Al-Asr", "total_ayahs": 3, "surah_number": 103},
    {"surah_name": "Al-Humaza", "total_ayahs": 9, "surah_number": 104},
    {"surah_name": "Al-Fil", "total_ayahs": 5, "surah_number": 105},
    {"surah_name": "Quraish", "total_ayahs": 4, "surah_number": 106},
    {"surah_name": "Al-Maa'un", "total_ayahs": 7, "surah_number": 107},
    {"surah_name": "Al-Kawthar", "total_ayahs": 3, "surah_number": 108},
    {"surah_name": "Al-Kaafiroon", "total_ayahs": 6, "surah_number": 109},
    {"surah_name": "An-Nasr", "total_ayahs": 3, "surah_number": 110},
    {"surah_name": "Al-Masad", "total_ayahs": 5, "surah_number": 111},
    {"surah_name": "Al-Ikhlaas", "total_ayahs": 4, "surah_number": 112},
    {"surah_name": "Al-Falaq", "total_ayahs": 5, "surah_number": 113},
    {"surah_name": "An-Naas", "total_ayahs": 6, "surah_number": 114},
]


#
# #
# def tt():
#     file = open("C:\\Users\\SKYLINE\Desktop\\test.txt", mode='r+')
#     for i, x in enumerate(surah):
#         file.write(
#             f'{{"surah_name":"{x["surah_name"]}","total_ayahs":{x["total_ayah"]},"surah_number":{i + 1}}},\n')
#
#
# tt()

def myFile():
    for i, x in enumerate(surah):
        ##alafsy~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ##~~~~~~~~~~~~~~~~~~~~~~~~~~
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\Alafasy\\{x['surah_name']}.json", mode='w+')

        ##abdulBaset~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ##~~~~~~~~~~~~~~~~~~
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\AbdulBaset\\Mujawwad\\{x['surah_name']}.json", mode='w+')
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\AbdulBaset\\Murattal\\{x['surah_name']}.json", mode='w+')
        ##husary~~~~~~~~~~~~~~~~~~~~~~~
        ##~~~~~~~~~~~~~
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\Husary\\Mujawwad\\{x['surah_name']}.json", mode='w+')
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\Husary\\Murattal\\{x['surah_name']}.json", mode='w+')

        ##Jibreel~~~~~~~~~~~~~~~~~~~~~~~
        ##~~~~~~~~~~~~~
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\Jibreel\\{x['surah_name']}.json", mode='w+')

        ##Shuraym~~~~~~~~~~~~
        ##~~~~~~~~~~~~~~~~~~
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\Shuraym\\{x['surah_name']}.json", mode='w+')

        ##Sudais~~~~~~~~~~~~
        ##~~~~~~~~~~~~~~~~~~
        # file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\Sudais\\{x['surah_name']}.json", mode='w+')

        ##Tunaiji~~~~~~~~~~~~
        ##~~~~~~~~~~~~~~~~~~
        file = open(f"C:\\Users\\SKYLINE\Desktop\\links\\Tunaiji\\{x['surah_name']}.json", mode='w+')

        ii = f'{i + 1}'
        if len(ii) == 1:
            index = f'00{ii}'
        elif len(ii) == 2:
            index = f'0{ii}'
        else:
            index = f'{ii}'
        print(index)
        for ayah in range(1, x['total_ayahs'] + 1):
            ai = f'{ayah}'

            if len(ai) == 1:
                ayahIndex = f'00{ai}'
            elif len(ai) == 2:
                ayahIndex = f'0{ai}'
            else:
                ayahIndex = f'{ai}'
            if ayah == 1:
                file.write('[')
            print(ayahIndex)
            if ayah != x["total_ayahs"]:
                file.write(
                    ##alafsy~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    ##~~~~~~~~~~~~~~~~~~~~~~~~~~
                    # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Alafasy/mp3/{index}{ayahIndex}.mp3"}}\n,')

                ##abdulBaset~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/AbdulBaset/Mujawwad/mp3/{index}{ayahIndex}.mp3"}}\n,')
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/AbdulBaset/Murattal/mp3/{index}{ayahIndex}.mp3"}}\n,')

                # ##Husary~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Husary/Mujawwad/ogg/{index}{ayahIndex}.ogg"}}\n,')
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Husary/Murattal/ogg/{index}{ayahIndex}.ogg"}}\n,')

                # ##Jibreel~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Jibreel/mp3/{index}{ayahIndex}.mp3"}}\n,')

                ##Shuraym~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Shuraym/mp3/{index}{ayahIndex}.mp3"}}\n,')

                ##Sudais~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Sudais/mp3/{index}{ayahIndex}.mp3"}}\n,')

                ##Tunaiji~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~
                f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Tunaiji/mp3/{index}{ayahIndex}.mp3"}}\n,')

            if ayah == x["total_ayahs"]:
                file.write(
                    ##alafsy~~~~~~~~~~~~~~~~~~~~
                    ##~~~~~~~~
                    # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Alafasy/mp3/{index}{ayahIndex}.mp3"}}\n]')

                ##abdulBaset~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/AbdulBaset/Mujawwad/mp3/{index}{ayahIndex}.mp3"}}\n]')
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/AbdulBaset/Murattal/mp3/{index}{ayahIndex}.mp3"}}\n]')

                ##Husaryt~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Husary/Mujawwad/ogg/{index}{ayahIndex}.ogg"}}\n]')
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Husary/Murattal/ogg/{index}{ayahIndex}.ogg"}}\n]')

                ##Jibreel~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Jibreel/mp3/{index}{ayahIndex}.mp3"}}\n]')

                ##Shuraym~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Shuraym/mp3/{index}{ayahIndex}.mp3"}}\n]')

                ##Sudais~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~~~~~~
                # f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Sudais/mp3/{index}{ayahIndex}.mp3"}}\n]')

                ##Tunaiji~~~~~~~~~~~~~~~~~~~~
                ##~~~~~~~~~~~~~~~~~~~~~~~
                f'{{ \n"surah_number":{i + 1},"ayah_url":"https://download.quranicaudio.com/verses/Tunaiji/mp3/{index}{ayahIndex}.mp3"}}\n]')


myFile()

#

#
#
#

# # *****************************************************************************************firebase upload function is here
# firebaseConfig = {
#     'apiKey': "AIzaSyALsHjtgCPQpVog1WUtZtjULtM8RVCbqGo",
#     'authDomain': "al-qur-aan.firebaseapp.com",
#     'databaseURL': "https://al-qur-aan-default-rtdb.firebaseio.com",
#     'projectId': "al-qur-aan",
#     'storageBucket': "al-qur-aan.appspot.com",
#     'messagingSenderId': "502498008665",
#     'appId': "1:502498008665:web:c2a77069d8098ec13b9b48"
# }
#
# firebase = pyrebase.initialize_app(firebaseConfig)
# #
# storage = firebase.storage()
#
# for i, x in enumerate(surah):
#     ii = x['surah_number']
#     if ii < 10:
#         index = f'00{ii}'
#     if ii > 9 < 100:
#         index = f'0{ii}'
#     if ii > 99 < 1000:
#         index = f'{ii}'
#     print(index)
#     for ayah in range(1, x['total_ayahs'] + 1):
#         ai = ayah
#         if ai < 10:
#             ayahIndex = f'00{ai}'
#         if ai > 9 < 100:
#             ayahIndex = f'0{ai}'
#         if ai > 99 < 1000:
#             ayahIndex = f'{ai}'
#         print(f'{x["surah_name"]}{index}{ayahIndex}')
#
#         storage.child(f'alafasy_64_bit/{x["surah_name"]}/{index}{ayahIndex}.mp3').put(
#             f"C:\\Users\\SKYLINE\\Desktop\\alafasy\\{index}{ayahIndex}.mp3")
#
# print('upload finished')

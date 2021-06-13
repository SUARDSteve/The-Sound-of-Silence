#!/usr/local/bin/python# -*- coding: utf-8 -*-import tensorflow as tfimport librosaimport numpy as np# Définition des différentes classes de la base de donnéesclasses = np.array(["Coup par coups", "Explosion", "Gros calibre", "Petit calibre", "Chenille", "Bateau", "Camion", "Groupe éléctrogène", "Moto", "Quad", "Voiture", "Cris", "Discussion calme", "Enfant", "Femme", "Homme"])        # Chargement du fichier audio qui a été enregistré au format .WAVy, sr = librosa.core.load("/home/pi/The_Sound_of_Silence_pi/recording/record.wav", res_type="kaiser_fast")        # Extraction des features du signal audiops = librosa.feature.melspectrogram(y, sr=sr)ps = ps[:,:128]ps = ps.reshape(128, 128, 1)         # Chargement du réseau de neuronnes entrainé sur le PC. Il a été au préalable déplacé dans le fichier /home/pi/The_Sound_of_Silence_pi/model du Raspberry Pimodel_train = tf.keras.models.load_model("/home/pi/The_Sound_of_Silence_pi/model_simplifier")# Réalisation de la prédiction   prediction = model_train.predict(np.array(ps, ndmin=4))prediction_triee = np.argsort(prediction)[:-6:-1]                prediction_finale = []        for i in range(1,4):    prediction_finale.append(classes[prediction_triee[0,-i]] + " : " + str(round(prediction[0,prediction_triee[0,-i]]*100,2)) + "% de précision")# Enregistrement sous format .txt des résultats    with open("/home/pi/The_Sound_of_Silence_pi/prediction/prediction.txt", 'w') as f:    for item in prediction_finale:        f.write("%s\n" % item)
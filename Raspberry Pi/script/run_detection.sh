#!/bin/bash

SEUIL_ATTEINT=0

# Fonction qui arrête le programme et  nettoie le terminal une fois cela fini
nettoyage_ecran() {
	echo ""
	echo "Merci d'avoir utilisé la détection The Sound of Silence"
	echo "À Bientôt !"
	exit
}

# Gestion d'éventuelle exception
trap clean_up SIGHUP SIGINT SIGTERM

# Fonction qui réalise l'enregistrement audio (son de 5 secondes sur le device 1,0 et enregistré au format .WAV
recording(){
	echo "Début de l'enregistrement..."
	arecord -D plughw:1,0 -d 5 -f cd /home/pi/The_Sound_of_Silence_pi/recording/test.wav -c 1
}

# Fonction qui réalise la prédiction en lançant le script python et affiche les résultats sur le terminal
predict() {
	echo "Prédiction..."
	python3 /home/pi/The_Sound_of_Silence_pi/script/detection.py
	PREDICTION=$(cat /home/pi/The_Sound_of_Silence_pi/prediction/prediction.txt)
	echo "Prediction is :"
	echo -n "$PREDICTION"
}

# Fonction qui réalise l'acquisition constante du niveau de bruit et qui détecte si le seuil est dépassé
# La valeur du seuil est ici de 50, mais cela peut varier de s'il l'on souhaite une détection plus ou moins sensible
seuil() {
        if (soundmeter --trigger +50 1 --action exec-stop --exec trigger.sh); then
                SEUIL_ATTEINT=1 
        fi
}

# Procédure principale
echo "Bienvenue sur The Sound of Silence"
echo ""
while true; do
        seuil
        if  [ $SEUIL_ATTEINT = 1 ]; then
                recording
                predict
                SEUIL_ATTEINT=0
        else
                echo "Rien à signaler !"
        fi
done
clean_up

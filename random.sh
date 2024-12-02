#!/bin/bash

compte_a_rebours() {
    echo "Début du tirage au sort"
    sleep 1

    # Boucle pour afficher le compte à rebours de 5 à 1
    for i in {5..1}; do
        echo "$i"
        sleep 1
    done
}

fichier=participant

# Vérification de l'existence du fichier
if [ ! -f "$fichier" ]; then
    echo "Le fichier '$fichier' n'existe pas."
    exit 1
fi

# Calcul du nombre de lignes dans le fichier
max=$(wc -l < "$fichier")

# Vérification que le fichier contient plus d'une ligne
if (( max < 2 )); then
    echo "Le fichier contient moins de 2 participants, impossible de faire le tirage au sort."
    exit 2
fi

if (( max == 2 )); then
    echo "C'est l'heure du duel"
    participant1=$(awk "NR==1" $fichier)
    participant2=$(awk "NR==2" $fichier)

    # Définir un tableau avec les prénoms des joueurs
    tableau=("$participant1" "$participant2")

    # Initialiser les scores des joueurs
    score_1=0
    score_2=0

    # Fonction pour afficher le score
    afficher_scores() {
        echo "============"
        echo "Scores:"
        echo "$participant1: $score_1"
        echo "$participant2: $score_2"
        echo "============"
    }

    # Boucle du jeu
    while [[ $score_1 -lt 3 && $score_2 -lt 3 ]]; do
        # Choisir un joueur au hasard
        index_aleatoire=$((RANDOM % 2))  # 0 pour joueur 1, 1 pour joueur 2
        joueur="${tableau[$index_aleatoire]}"
        compte_a_rebours
        # Ajouter 1 point au joueur choisi
        if [[ "$joueur" == "$participant1" ]]; then
            ((score_1++))
        else
            ((score_2++))
        fi

        # Afficher les scores après chaque tour
        afficher_scores

        # Vérifier si un joueur a gagné
        if [[ $score_1 -ge 3 ]]; then
            echo "$participant1 va présenter !"
            break
        elif [[ $score_2 -ge 3 ]]; then
            echo "$participant2 va présenter !"
            break
        fi

        # Attendre un peu avant de recommencer
        sleep 5
    done
else
    # Tirage aléatoire
    random_number=$((RANDOM % max + 1))
    resultat=$(awk "NR==$random_number" $fichier)
    compte_a_rebours
    echo "La personne sélectionnée est :"
    echo "============"
    echo "$resultat"
    echo "============"

    # Supprimer la ligne et mettre à jour le fichier
    awk -v num=$random_number 'NR != num' "$fichier" > temp.txt && mv temp.txt "$fichier"
    
    if (( max == 3 ))
    then
        echo "le prochain tirage au sort sera un DUEL"
    fi
fi

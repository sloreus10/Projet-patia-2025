#!/bin/bash

set -e

# Chemins des fichiers et répertoires
DOMAIN_FILE="src/main/resources/domain.pddl"
PDDL_PROBLEMS_DIR="src/main/resources/pddl_problems"
PLANS_STRING_DIR="src/main/resources/plansString"
CONFIG_DIR="config"
TARGET_JAR="target/sokoban-1.0-SNAPSHOT-jar-with-dependencies.jar"

# Fonction pour compiler et packager le projet
compile_project() {
    echo "Compiling the project..."
    mvn clean
    mvn compile
    mvn package
    if [ $? -ne 0 ]; then
        echo "Error: Compilation failed."
        exit 1
    fi
    echo "Compilation successful."
}

# Fonction pour convertir JSON en PDDL
convertJsonToPDDL() {
    local jsonFile=$1
    local pddlFile="$PDDL_PROBLEMS_DIR/$(basename "$1" .json).pddl"

    # Vérifier si le fichier JSON existe
    if [ ! -f "$jsonFile" ]; then
        echo "Error: File $jsonFile does not exist."
        return 1
    fi

    # Appeler le programme Java pour convertir JSON en PDDL
    echo "Converting JSON to PDDL..."
    java -server -Xms2048m -Xmx2048m --add-opens java.base/java.lang=ALL-UNNAMED -cp "$TARGET_JAR" sokoban.ParserJsonToPDDL "$jsonFile" "$pddlFile"

    if [ -f "$pddlFile" ]; then
        echo "PDDL file generated: $pddlFile"
        return 0
    else
        echo "Error: Problem converting JSON to PDDL."
        return 1
    fi
}

# Fonction pour résoudre avec HSP
solveHSP() {
    local problemFile="$PDDL_PROBLEMS_DIR/$(basename "$1" .json).pddl"
    local planFile="$PLANS_STRING_DIR/$(basename "$1" .json).txt"

    # Vérifier si le fichier problème PDDL existe
    if [ ! -f "$problemFile" ]; then
        echo "Error: Problem file $problemFile does not exist."
        return 1
    fi

    show_heuristic

    read -p "Choose heuristic [0 - 8]: " h

    case $h in
        0) heuristic='AJUSTED_SUM' ;;
        1) heuristic='AJUSTED_SUM2' ;;
        2) heuristic='AJUSTED_SUM2M' ;;
        3) heuristic='COMBO' ;;
        4) heuristic='MAX' ;;
        5) heuristic='FAST_FORWARD' ;;
        6) heuristic='SET_LEVEL' ;;
        7) heuristic='SUM' ;;
        8) heuristic='SUM_MUTEX' ;;
        *) echo "Error: Invalid heuristic choice." && sleep 1 && return ;;
    esac

    read -p "Enter timeout in seconds [default 600]: " timeOut
    timeOut=${timeOut:-600}

    echo "Solving with HSP..."
    java -server -Xms2048m -Xmx2048m --add-opens java.base/java.lang=ALL-UNNAMED -cp "$TARGET_JAR" fr.uga.pddl4j.planners.statespace.HSP "$DOMAIN_FILE" "$problemFile" -t "$timeOut" -e "$heuristic" > temp_plan.txt

    # Afficher le plan brut
    echo "Raw plan generated: "
    cat temp_plan.txt

    # Convertir le plan en chaîne et écrire dans un fichier
    java -server -Xms2048m -Xmx2048m --add-opens java.base/java.lang=ALL-UNNAMED -cp "$TARGET_JAR" sokoban.ParserPlanToString temp_plan.txt > "$planFile"

    # Afficher le plan
    echo "Plan as movements: "
    cat "$planFile"

    # Nettoyer le fichier de plan temporaire
    rm temp_plan.txt

    # Exécuter Sokoban avec le plan généré
    java -server -Xms2048m -Xmx2048m --add-opens java.base/java.lang=ALL-UNNAMED -cp "$TARGET_JAR" sokoban.SokobanMain "$1" "$planFile"
}

# Fonction pour résoudre avec FF
solveFF() {
    local problemFile="$PDDL_PROBLEMS_DIR/$(basename "$1" .json).pddl"
    local planFile="$PLANS_STRING_DIR/$(basename "$1" .json).txt"

    # Vérifier si le fichier problème PDDL existe
    if [ ! -f "$problemFile" ]; then
        echo "Error: Problem file $problemFile does not exist."
        return 1
    fi

    read -p "Enter timeout in seconds [default 600]: " timeOut
    timeOut=${timeOut:-600}

    echo "Solving with FF..."
    echo "Running FF with the following parameters: Domain=$DOMAIN_FILE, Problem=$problemFile, Timeout=$timeOut"
    java -server -Xms2048m -Xmx2048m --add-opens java.base/java.lang=ALL-UNNAMED -cp "$TARGET_JAR" fr.uga.pddl4j.planners.statespace.FF "$DOMAIN_FILE" "$problemFile" -t "$timeOut" > ff_output.log 2>&1

    # Vérifier si FF a réussi
    if [ $? -ne 0 ]; then
        echo "Error: FF solver encountered an issue."
        cat ff_output.log
        return 1
    fi

    # Afficher le plan brut
    echo "Raw plan generated: "
    cat ff_output.log

    # Convertir le plan en chaîne et écrire dans un fichier
    java -server -Xms2048m -Xmx2048m --add-opens java.base/java.lang=ALL-UNNAMED -cp "$TARGET_JAR" sokoban.ParserPlanToString ff_output.log > "$planFile"

    # Afficher le plan
    echo "Plan as movements: "
    cat "$planFile"

    # Nettoyer le fichier de plan temporaire
    rm ff_output.log

    # Exécuter Sokoban avec le plan généré
    java -server -Xms2048m -Xmx2048m --add-opens java.base/java.lang=ALL-UNNAMED -cp "$TARGET_JAR" sokoban.SokobanMain "$1" "$planFile"
}

# Fonction pour afficher les options d'heuristique
show_heuristic() {
    echo "0. AJUSTED_SUM"
    echo "1. AJUSTED_SUM2"
    echo "2. AJUSTED_SUM2M"
    echo "3. COMBO"
    echo "4. MAX"
    echo "5. FAST_FORWARD"
    echo "6. SET_LEVEL"
    echo "7. SUM"
    echo "8. SUM_MUTEX"
}

# Fonction pour afficher le menu principal
show_main_menu() {
    echo "| 1. Enter JSON file"
    echo "| 2. Exit"
    echo " ----------"
}

# Fonction pour afficher le menu du planificateur
show_planner_menu() {
    echo "| 1. Solve with HSP"
    echo "| 2. Solve with FF"
    echo "| 3. Back to main menu"
    echo " ----------"
}

# Fonction pour lire les options de l'utilisateur pour le menu principal
read_main_options() {
    read -p "Enter choice [1 - 2] : " choice
    case $choice in
        1) read -p "Enter the name of the JSON file to test from the config folder: " exercice
           local jsonFile="$CONFIG_DIR/$exercice"
           if convertJsonToPDDL "$jsonFile"; then
               show_planner_menu
               read_planner_options "$exercice"
           else
               show_main_menu
               read_main_options
           fi ;;
        2) exit 0 ;;
        *) echo "Error: Invalid choice." && sleep 1
    esac
}

# Fonction pour lire les options de l'utilisateur pour le menu du planificateur
read_planner_options() {
    local exercice=$1
    read -p "Enter choice [1 - 3] : " choice
    case $choice in
        1) solveHSP "$exercice" ;;
        2) solveFF "$exercice" ;;
        3) show_main_menu && read_main_options ;;
        *) echo "Error: Invalid choice." && sleep 1
    esac
}

# Logique principale
compile_project

echo "****************************************"
echo "PDDL4J"
echo "****************************************"
echo "Please see full documentation at: http://pddl4j.imag.fr"
echo ""
echo "Choose an option:"
echo ""

while true
do
    show_main_menu
    read_main_options
done

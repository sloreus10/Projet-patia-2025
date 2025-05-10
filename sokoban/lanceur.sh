#!/bin/bash

# Function to compile and package the project
compile_project() {
    mvn clean
    mvn compile
    mvn package
}

# Function to convert JSON to PDDL
convertJsonToPDDL() {
    jsonFile=$1
    pddlFile="src/main/resources/pddl_problems/$(basename "$1" .json).pddl"

    # Check if the JSON file exists
    if [ ! -f "$jsonFile" ]; then
        echo "File $jsonFile does not exist."
        return 1
    fi

    # Call your Java program or script to convert JSON to PDDL
    java -cp "target/sokoban-1.0-SNAPSHOT-jar-with-dependencies.jar" sokoban.ParserJsonToPDDL $jsonFile $pddlFile

    if [ -f "$pddlFile" ]; then
        echo "PDDL file generated: $pddlFile"
        return 0
    else
        echo "Error: Problem converting JSON to PDDL."
        return 1
    fi
}

# Function to solve with HSP
solveHSP() {
    domainFile="src/main/resources/domain.pddl"
    problemFile="src/main/resources/pddl_problems/$(basename "$1" .json).pddl"

    # Check if the PDDL problem file exists
    if [ ! -f "$problemFile" ]; then
        echo "Problem file $problemFile does not exist."
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
        *) echo "Error..." && sleep 1 && return ;;
    esac

    read -p "Enter timeout in seconds [default 600]: " timeOut
    timeOut=${timeOut:-600}

    java -cp "target/sokoban-1.0-SNAPSHOT-jar-with-dependencies.jar" fr.uga.pddl4j.planners.statespace.HSP $domainFile $problemFile -t $timeOut -e $heuristic
}

# Function to solve with FF
solveFF() {
    domainFile="src/main/resources/domain.pddl"
    problemFile="src/main/resources/pddl_problems/$(basename "$1" .json).pddl"

    # Check if the PDDL problem file exists
    if [ ! -f "$problemFile" ]; then
        echo "Problem file $problemFile does not exist."
        return 1
    fi

    read -p "Enter timeout in seconds [default 600]: " timeOut
    timeOut=${timeOut:-600}

    java -cp "target/sokoban-1.0-SNAPSHOT-jar-with-dependencies.jar" fr.uga.pddl4j.planners.statespace.FF $domainFile $problemFile -t $timeOut
}

# Function to show heuristic options
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

# Function to show main menu
show_main_menu() {
    echo "| 1. Enter JSON file"
    echo "| 2. Exit"
    echo " ----------"
}

# Function to show planner menu
show_planner_menu() {
    echo "| 1. Solve with HSP"
    echo "| 2. Solve with FF"
    echo "| 3. Back to main menu"
    echo " ----------"
}

# Function to read user options for main menu
read_main_options() {
    read -p "Enter choice [1 - 2] : " choice
    case $choice in
        1) read -p "Enter the name of the JSON file to test from the config folder: " exercice
           jsonFile="config/$exercice"
           if convertJsonToPDDL $jsonFile; then
               show_planner_menu
               read_planner_options $exercice
           else
               show_main_menu
               read_main_options
           fi ;;
        2) exit 0 ;;
        *) echo "Error..." && sleep 1
    esac
}

# Function to read user options for planner menu
read_planner_options() {
    exercice=$1
    read -p "Enter choice [1 - 3] : " choice
    case $choice in
        1) solveHSP $exercice ;;
        2) solveFF $exercice ;;
        3) show_main_menu && read_main_options ;;
        *) echo "Error..." && sleep 1
    esac
}

# Main logic
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

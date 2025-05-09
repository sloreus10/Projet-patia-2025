package sokoban;

import java.io.*;
import java.util.*;

import org.json.simple.JSONObject;
import org.json.simple.parser.*;

import fr.uga.pddl4j.heuristics.state.StateHeuristic;
import fr.uga.pddl4j.planners.InvalidConfigurationException;
import fr.uga.pddl4j.planners.LogLevel;
import fr.uga.pddl4j.planners.Planner;
import fr.uga.pddl4j.planners.PlannerConfiguration;
import fr.uga.pddl4j.planners.statespace.HSP;
import fr.uga.pddl4j.problem.operator.Action;
import fr.uga.pddl4j.plan.*;

public class Parser {
    private String file;
    private String PDDLdomain;
    private String PDDLfile;

    public Parser(String PDDLdomain, String PDDLfile, String JSONFile){
        this.PDDLdomain = PDDLdomain;
        this.PDDLfile = PDDLfile;
        this.file = JSONFile;
    }

    /**
     * Crée le fichier du problème PDDL
     * Initialise le fichier avec son nom et le nom du domaine
     */
    public void createFile(){
        try {
            FileWriter fw = new FileWriter(PDDLfile);
            fw.write("(define (problem parsedProblem)\n(:domain sokoban)\n");
            fw.close();
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

    /**
     * Lit le fichier JSON correspondant au test et retourne la description du plateau de jeu
     * @return Un tableau contenant les lignes des différents éléments codés du plateau
     * @throws Exception
     */
    public String[] getGameBoard() throws Exception {
        Object o = new JSONParser().parse(new FileReader(file));
        JSONObject jsonObj = (JSONObject) o;
        String problem = (String) jsonObj.get("testIn");
        String[] result = problem.split("\n");
        return result;
    }
    
    /**
     * Identifie les différents éléments du plateau de jeu et les stocke dans une hashmap avec leurs coordonnées.
     * @param gameBoard
     * @return une hashmap avec comme clé les coordonnées et comme valeur le type d'élément présent
     * @throws Exception
     */
    public HashMap<Integer[], Character> getObjectCoordinates(String[] gameBoard) throws Exception {
        // s = sol, a = agent, b = boite, c = cible, d = boite sur cible, e = agent sur cible
        HashMap<Integer[], Character> result = new HashMap<>();
        for (int i = 0; i < gameBoard.length; i++) {
            for (int j = 0; j < gameBoard[i].length(); j++) {
                    if (gameBoard[i].charAt(j) == ' ')
                        result.put(new Integer[] { i, j }, 's');
                    else if (gameBoard[i].charAt(j) == '@')
                        result.put(new Integer[] { i, j }, 'a');
                    else if (gameBoard[i].charAt(j) == '.')
                        result.put(new Integer[] { i, j }, 'c');
                    else if (gameBoard[i].charAt(j) == '$')
                        result.put(new Integer[] { i, j }, 'b');
                    else if (gameBoard[i].charAt(j) == '*')
                        result.put(new Integer[] { i, j }, 'd');
                    else if (gameBoard[i].charAt(j) == '+')
                        result.put(new Integer[] { i, j }, 'e');
            }
        }
        return result;
    }

    /**
     * Retourne une chaîne de caractère qui décrit les objects présents dans le problème PDDL.
     * @param objects la hashmap comportant les coordonnées des objets du plateau de jeu
     * @return la chaîne de caractère qui décrit les objets et leurs types dans le problème PDDL
     */
    public String writeObjects(HashMap<Integer[], Character> objects) {
        String res = "(:objects ";
        HashMap<String, Integer> cmp = new HashMap<String,Integer>();
        cmp.put("Sol", 0);
        cmp.put("Agent", 0);
        cmp.put("Cible", 0);
        cmp.put("Boite", 0);
        //Calcul du nombre d'élements de chaque type
        for(Integer[] tabI : objects.keySet()){
            if(objects.get(tabI) == 's')
                cmp.put("Sol", cmp.get("Sol") + 1);
            else if(objects.get(tabI) == 'a') {
                cmp.put("Agent", cmp.get("Agent") + 1);
                cmp.put("Sol", cmp.get("Sol") + 1);
            }
            else if(objects.get(tabI) == 'c')
                cmp.put("Cible", cmp.get("Cible") + 1);
            else if(objects.get(tabI) == 'b'){
                cmp.put("Boite", cmp.get("Boite") + 1);
                cmp.put("Sol", cmp.get("Sol") + 1);
            }
            else if(objects.get(tabI) == 'd'){
                cmp.put("Boite", cmp.get("Boite") + 1);
                cmp.put("Cible", cmp.get("Cible") + 1);
            }
            else if(objects.get(tabI) == 'e'){
                cmp.put("Agent", cmp.get("Agent") + 1);
                cmp.put("Cible", cmp.get("Cible") + 1);
            }
        }
        //Ecriture de la chaîne de caractère qui initialise les objets dans le fichier PDDL
        for(int i=1; i<=cmp.get("Sol"); i++)
            res += "s"+i+" ";
        for(int i=1; i<=cmp.get("Cible"); i++)
            res += "c"+i+" ";
        res += "- sol\n";
        for(int i=1; i<=cmp.get("Agent"); i++)
            res += "a"+i+" ";
        res += "- agent\n";
        for(int i=1; i<=cmp.get("Boite"); i++)
            res += "b"+i+" ";
        res += "- boite)\n";
        return res;
    }

    /**
     * A partir des coordonnées des différents objets et du nombre de lignes et colonnes du plateau de jeu, initialise un tableau de jeu avec tous les objets précis présents.
     * @param objects la hashmap comportant les coordonnées des objets du plateau de jeu
     * @param nbLignes le nombre de lignes du plateau de jeu
     * @param nbColonnes le nombre de colonnes du plateau de jeu
     * @return Un tableau à 2 dimensions contenant les objets présents dans le fichier PDDL, placés aux coordonnées données par la Hashmap.
     * @throws IOException
     * @throws ParseException
     */
    public String[][] localizeObjects(HashMap<Integer[], Character> objects, int nbLignes, int nbColonnes) throws IOException, ParseException {
        // a = agent, b = boite, c = cible, s = sol
        String [][] result = new String[nbLignes][nbColonnes];
        Iterator<Map.Entry<Integer[], Character>> iterator = objects.entrySet().iterator();
        int[] nbObjects = new int[] {0, 0, 0, 0};
        while (iterator.hasNext()) {
            Map.Entry<Integer[], Character> entry = iterator.next();
            if(entry.getValue() == 's'){
                nbObjects[3]++;
                result[entry.getKey()[0]][entry.getKey()[1]] = "s"+nbObjects[3];
            }
            else if(entry.getValue() == 'a'){
                nbObjects[0]++;
                nbObjects[3]++;
                result[entry.getKey()[0]][entry.getKey()[1]] = "a"+nbObjects[0]+";"+"s"+nbObjects[3];
            }
            else if(entry.getValue() == 'b'){
                nbObjects[1]++;
                nbObjects[3]++;
                result[entry.getKey()[0]][entry.getKey()[1]] = "b"+nbObjects[1]+";"+"s"+nbObjects[3];
            }
            else if(entry.getValue() == 'c'){
                nbObjects[2]++;
                result[entry.getKey()[0]][entry.getKey()[1]] = "c"+nbObjects[2];
            }
            else if(entry.getValue() == 'd'){
                nbObjects[1]++;
                nbObjects[2]++;
                result[entry.getKey()[0]][entry.getKey()[1]] = "b"+nbObjects[1]+";"+"c"+nbObjects[2];
            }
            else if(entry.getValue() == 'e'){
                nbObjects[0]++;
                nbObjects[2]++;
                result[entry.getKey()[0]][entry.getKey()[1]] = "a"+nbObjects[0]+";"+"c"+nbObjects[2];
            }
        }
        return result;
    }

    /**
     * Crée la chaîne de caractère qui décrit les prédicats initiaux du problème PDDL à partir du tableau du plateau de jeu contenant les différents objets.
     * @param objects le tableau à 2 dimensions représentant le plateau de jeu et ses éléments
     * @return La description des prédicats initiaux du problème PDDL.
     */
    public String writeInitConditions(String[][] objects){
        String res ="\n(:init ";
        for(int i=0; i<objects.length; i++){
            for (int j = 0; j < objects[i].length; j++) {
                // Emplacement sur la map des différentes entités
                if (objects[i][j] == null) {
                } else if (objects[i][j].contains(";")) {
                    String[] o = objects[i][j].split(";");
                    if(o[0].contains("a")) {
                        res += "(agentEstSur " + o[0] + " " + o[1] + ")\n";
                        res += "(estLibre " + o[1] + ")\n";
                    }
                    else if(o[0].contains("b")) {
                        res += "(boiteEstSur " + o[0] + " " + o[1] + ")\n";
                        if (o[1].contains("c"))
                            res += "(boiteSurCible " + o[0] + ")\n";
                    } 
                    if (o[1].contains("c"))
                        res += "(estDestination " + o[1] + ")\n";
                } else {
                    if (objects[i][j].contains("c"))
                        res += "(estDestination " + objects[i][j] + ")\n";
                    res += "(estLibre " + objects[i][j] + ")\n";
                }
                //Définition des cases voisines
                if (objects[i][j] != null) {
                    String currentObject = objects[i][j];
                    if (objects[i][j].contains(";")) {
                        currentObject = objects[i][j].split(";")[1];
                    }
                    if(j-1 >= 0 && objects[i][j-1] != null){
                        String objectBefore = objects[i][j - 1];
                        if (objectBefore.contains(";")) {
                           objectBefore = objectBefore.split(";")[1];
                        }
                        res += "(aVoisinDroit " + objectBefore + " " + currentObject + ")\n";
                    }
                    
                    if(i-1 >= 0 && objects[i-1][j] != null){
                        String objectOnTop = objects[i-1][j];
                        if (objectOnTop.contains(";")) {
                            objectOnTop = objectOnTop.split(";")[1];
                        }
                        res += "(aVoisinHaut " + currentObject + " " + objectOnTop + ")\n";
                    }                    
                }
            }
        }
        res += ")";
        return res;
    }

    /**
     * Crée la chaîne de caractère qui détaille le but final du problème PDDL.
     * @param objects le tableau à 2 dimensions représentant le plateau de jeu et ses éléments
     * @return La chaîne de caractère décrivant le but du problème PDDL.
     */
    public String writeGoalConditions(String[][] objects){
        String res = "\n(:goal (and ";
        for(int i=0; i<objects.length; i++){
            for(int j=0; j < objects[i].length; j++){
                if(objects[i][j] != null) {
                    if (objects[i][j].contains("b")) {
                        String[] o = objects[i][j].split(";");
                        res += "(boiteSurCible " + o[0] + ")\n";
                    }
                }
            }
        }
        res += ")\n)\n)";
        return res;
    }

    /**
     * Fonction principale qui crée le fichier problème PDDL.
     * @throws Exception
     */
    public void parseProblemJSONToPDDL() throws Exception {
        createFile();
        FileWriter fw = new FileWriter(PDDLfile, true);
        String[] gameBoard = getGameBoard();
        HashMap<Integer[], Character> result = getObjectCoordinates(gameBoard);
        String res = "";
        int nbCol = 0;
        for(int i=0; i<gameBoard.length; i++){
            if(gameBoard[i].length() > nbCol)
                nbCol = gameBoard[i].length();
        }
        String[][] objects = localizeObjects(result, gameBoard.length, nbCol);
        res += writeObjects(result);
        res += writeInitConditions(objects);
        res += writeGoalConditions(objects);
        fw.write(res);
        fw.close();
    }

    /**
     * Définit le planificateur PDDL qui résout le problème PDDL traduit et renvoie la solution trouvée.
     * @return La solution trouvée au problème PDDL avec le planificateur définit.
     */
    public Plan getPDDLResult(){
        PlannerConfiguration config = HSP.getDefaultConfiguration();
        config.setProperty(HSP.DOMAIN_SETTING, PDDLdomain);
        config.setProperty(HSP.PROBLEM_SETTING, PDDLfile);
        config.setProperty(HSP.TIME_OUT_SETTING, 1000);
        config.setProperty(HSP.LOG_LEVEL_SETTING, LogLevel.INFO);
        config.setProperty(HSP.HEURISTIC_SETTING, StateHeuristic.Name.MAX);
        config.setProperty(HSP.WEIGHT_HEURISTIC_SETTING, 1.2);

        // Creates an instance of the HSP planner with the specified configuration
        Planner planner = Planner.getInstance(Planner.Name.HSP, config);

        // Runs the planner and print the solution
        Plan result = new SequentialPlan();
        try {
            result = planner.solve();
        } catch (InvalidConfigurationException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Traduit la solution au problème obtenue avec le planificateur en commandes lisibles par le serveur web.
     * @param p le plan trouvé par le solveur PDDL
     * @return La chaîne de caractère qui décrit les actions de la solution à réaliser.
     */
    public String getStringSolution(Plan p){
        String res= "";
        for (Action a : p.actions()) {
            if(a.getName().contains("haut"))
                res += "U";
            else if(a.getName().contains("bas"))
                res += "D";
            else if(a.getName().contains("gauche"))
                res += "L";
            else if(a.getName().contains("droit"))
                res += "R";
        }
        return res;
    }

    //******* Méthodes d'affichages *******
    public void showJsonFile(String[] gameboard) throws Exception {
        ArrayList<String> result = new ArrayList<String>(Arrays.asList(gameboard));
        for (String s : result) {
            System.out.println("|" + s + "|");
        }
    }

    public void showCoordinates(HashMap<Integer[], Character> objectCoordinates) throws Exception {
        StringBuilder stringBuilder = new StringBuilder("{");

        for (Map.Entry<Integer[], Character> entry : objectCoordinates.entrySet()) {
            stringBuilder.append(Arrays.toString(entry.getKey()))
                         .append(":")
                         .append("\"").append(entry.getValue()).append("\", ");
        }

        // Remove the trailing comma and space
        if (stringBuilder.length() > 1) {
            stringBuilder.setLength(stringBuilder.length() - 2);
        }

        stringBuilder.append("}");
        System.out.println(stringBuilder);
    }
    
    public void showEltsEmplacement(String[][] objects){
        for(int i=0; i< objects.length; i++){
            for(int j=0; j<objects[i].length; j++){
                System.out.print(objects[i][j] + "  ");
            } 
            System.out.print("\n");
        }
    }
    //******* Fin méthodes d'affichages *******


    public static void main(String[] args) throws Exception {
        if(args.length < 1){
            System.err.println("Il manque un argument ! Donnez le nom du fichier json (avec son extension .json) correspondant au niveau à tester.");
        }
        String JSONfile = "./config/" + args[0];
        String PDDLdomain = "./src/pddlSokoban/domain.pddl";
        String PDDLfile = "./src/pddlSokoban/problemPDDL.pddl";
        Parser p = new Parser(PDDLdomain, PDDLfile, JSONfile);
        p.parseProblemJSONToPDDL();
        Plan res = p.getPDDLResult();
        String solution = p.getStringSolution(res);
        try {
            FileWriter fw = new FileWriter(new File("./src/pddlSokoban/Resultat.txt"));
            for (char c : solution.toCharArray()) fw.write(""+c);
            fw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
}
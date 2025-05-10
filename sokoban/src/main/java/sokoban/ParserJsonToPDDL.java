package sokoban;

import org.json.JSONObject;
import org.json.JSONTokener;
import org.json.JSONException;

import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;

/**
 * Ce parseur lit un fichier JSON contenant une représentation textuelle d’un niveau de Sokoban
 * et génère un fichier PDDL décrivant le problème correspondant.
 */
public class ParserJsonToPDDL {

    public static void main(String[] args) {
        if (args.length < 2) {
            System.err.println("Usage: java sokoban.ParserJsonToPDDL <input.json> <output.pddl>");
            System.exit(1);
        }

        String jsonFilePath = args[0];
        String pddlFilePath = args[1];

        try {
            parseJsonToPDDL(jsonFilePath, pddlFilePath);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            System.err.println("Error parsing JSON file: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Convertit une carte Sokoban représentée en JSON vers le format PDDL.
     *
     * @param jsonFilePath  chemin vers le fichier JSON d'entrée
     * @param pddlFilePath  chemin vers le fichier PDDL de sortie
     * @throws IOException  en cas de problème de lecture/écriture de fichiers
     */
    public static void parseJsonToPDDL(String jsonFilePath, String pddlFilePath) throws IOException {
        FileInputStream fis = new FileInputStream(jsonFilePath);
        JSONObject jsonObject = new JSONObject(new JSONTokener(fis));

        // Lecture de la carte du niveau
        String testIn = jsonObject.getString("testIn");
        String[] lines = testIn.split("\n");

        FileWriter writer = new FileWriter(pddlFilePath);

        writer.write("(define (problem sokoban-level1)\n");
        writer.write("  (:domain sokoban)\n");

        // Déclaration des objets
        writer.write("  (:objects\n");
        int rows = lines.length;
        int cols = lines[0].length();
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                writer.write("    l" + i + "_" + j + " - sol\n");
            }
        }
        writer.write("    a - agent\n");
        writer.write("    b - boite\n");
        writer.write("  )\n");

        // Initialisation de l’état
        writer.write("  (:init\n");

        // Ajout des relations de voisinage
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                String loc = "l" + i + "_" + j;
                if (j < cols - 1) {
                    String rightLoc = "l" + i + "_" + (j + 1);
                    writer.write("    (a_voisin_droit " + loc + " " + rightLoc + ")\n");
                }
                if (i < rows - 1) {
                    String upLoc = "l" + (i + 1) + "_" + j;
                    writer.write("    (a_voisin_haut " + loc + " " + upLoc + ")\n");
                }
            }
        }

        // Écriture des états initiaux
        for (int i = 0; i < rows; i++) {
            String line = lines[i];
            for (int j = 0; j < line.length(); j++) {
                char c = line.charAt(j);
                String loc = "l" + i + "_" + j;

                switch (c) {
                    case '#':
                        // Mur : on ne le mentionne pas (implicite, non libre)
                        break;
                    case '$':
                        writer.write("    (boite_est_sur b " + loc + ")\n");
                        break;
                    case '.':
                        writer.write("    (est_destination " + loc + ")\n");
                        writer.write("    (est_libre " + loc + ")\n");
                        break;
                    case '@':
                        writer.write("    (agent_est_sur a " + loc + ")\n");
                        break;
                    default:
                        writer.write("    (est_libre " + loc + ")\n");
                        break;
                }
            }
        }

        writer.write("  )\n");

        // But : la boîte doit être sur une destination
        writer.write("  (:goal (and\n");

        for (int i = 0; i < rows; i++) {
            String line = lines[i];
            for (int j = 0; j < line.length(); j++) {
                char c = line.charAt(j);
                String loc = "l" + i + "_" + j;

                if (c == '.') {
                    writer.write("    (boite_est_sur b " + loc + ")\n");
                }
            }
        }

        writer.write("  ))\n");
        writer.write(")\n");

        // Fermeture des flux
        writer.close();
        fis.close();
    }
}

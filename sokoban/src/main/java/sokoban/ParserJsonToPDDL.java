package sokoban;

import org.json.JSONObject;
import org.json.JSONTokener;
import org.json.JSONException;

import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * This parser reads a JSON file containing a textual representation of a Sokoban level
 * and generates a PDDL file describing the corresponding problem.
 */
public class ParserJsonToPDDL {

    // Constants for map characters
    private static final char WALL = '#';
    private static final char BOX = '$';
    private static final char BOX_ON_TARGET = '*';
    private static final char TARGET = '.';
    private static final char AGENT = '@';
    private static final char EMPTY = ' ';

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
            System.err.println("Error reading/writing files: " + e.getMessage());
            e.printStackTrace();
        } catch (JSONException e) {
            System.err.println("Error parsing JSON file: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Converts a Sokoban map represented in JSON to PDDL format.
     *
     * @param jsonFilePath  path to the input JSON file
     * @param pddlFilePath  path to the output PDDL file
     * @throws IOException  in case of file reading/writing issues
     */
    public static void parseJsonToPDDL(String jsonFilePath, String pddlFilePath) throws IOException {
        try (FileInputStream fis = new FileInputStream(jsonFilePath);
             BufferedReader reader = new BufferedReader(new InputStreamReader(fis))) {

            JSONObject jsonObject = new JSONObject(new JSONTokener(reader));

            // Read the level map
            String testIn = jsonObject.getString("testIn");
            String[] lines = testIn.split("\n");

            try (FileWriter writer = new FileWriter(pddlFilePath)) {
                writePDDLHeader(writer);
                writeObjects(writer, lines);
                writeInit(writer, lines);
                writeGoal(writer, lines);
            } catch (IOException e) {
                System.err.println("Error writing to the PDDL file: " + e.getMessage());
                e.printStackTrace();
                throw e;
            }

        } catch (IOException e) {
            System.err.println("Error reading JSON file: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Writes the header of the PDDL file.
     *
     * @param writer  the FileWriter to write to the PDDL file
     * @throws IOException  in case of writing issues
     */
    private static void writePDDLHeader(FileWriter writer) throws IOException {
        writer.write("(define (problem sokoban-level1)\n");
        writer.write("  (:domain sokoban)\n");
    }

    /**
     * Writes the objects section of the PDDL file.
     *
     * @param writer  the FileWriter to write to the PDDL file
     * @param lines   the lines of the Sokoban map
     * @throws IOException  in case of writing issues
     */
    private static void writeObjects(FileWriter writer, String[] lines) throws IOException {
        writer.write("  (:objects\n");
        int rows = lines.length;
        int cols = lines[0].length();
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                writer.write("    pos" + i + "_" + j + " - sol\n");
            }
        }
        writer.write("    box1 box2 - boite\n");
        writer.write("    agent1 - agent\n");
        writer.write("  )\n");
    }

    /**
     * Writes the initialization section of the PDDL file.
     *
     * @param writer  the FileWriter to write to the PDDL file
     * @param lines   the lines of the Sokoban map
     * @throws IOException  in case of writing issues
     */
    private static void writeInit(FileWriter writer, String[] lines) throws IOException {
        writer.write("  (:init\n");

        int rows = lines.length;
        int cols = lines[0].length();

        // Add adjacency relationships
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                String loc = "pos" + i + "_" + j;
                if (j < cols - 1) {
                    String rightLoc = "pos" + i + "_" + (j + 1);
                    writer.write("    (a_voisin_droit " + loc + " " + rightLoc + ")\n");
                }
                if (j > 0) {
                    String leftLoc = "pos" + i + "_" + (j - 1);
                    writer.write("    (a_voisin_droit " + leftLoc + " " + loc + ")\n");
                }
                if (i < rows - 1) {
                    String upLoc = "pos" + (i + 1) + "_" + j;
                    writer.write("    (a_voisin_haut " + upLoc + " " + loc + ")\n");
                }
                if (i > 0) {
                    String downLoc = "pos" + (i - 1) + "_" + j;
                    writer.write("    (a_voisin_haut " + loc + " " + downLoc + ")\n");
                }
            }
        }

        // Write initial states
        for (int i = 0; i < rows; i++) {
            String line = lines[i];
            for (int j = 0; j < line.length(); j++) {
                char c = line.charAt(j);
                String loc = "pos" + i + "_" + j;

                switch (c) {
                    case WALL:
                        writer.write("    (est_mur " + loc + ")\n");
                        break;
                    case BOX:
                        writer.write("    (boite_est_sur box1 " + loc + ")\n");
                        break;
                    case BOX_ON_TARGET:
                        writer.write("    (boite_est_sur box1 " + loc + ")\n");
                        writer.write("    (est_destination " + loc + ")\n");
                        writer.write("    (boite_sur_cible box1)\n");
                        break;
                    case TARGET:
                        writer.write("    (est_destination " + loc + ")\n");
                        writer.write("    (est_libre " + loc + ")\n");
                        break;
                    case AGENT:
                        writer.write("    (agent_est_sur agent1 " + loc + ")\n");
                        break;
                    default:
                        if (c == EMPTY) {
                            writer.write("    (est_libre " + loc + ")\n");
                        }
                        break;
                }
            }
        }

        writer.write("  )\n");
    }

    /**
     * Writes the goal section of the PDDL file.
     *
     * @param writer  the FileWriter to write to the PDDL file
     * @param lines   the lines of the Sokoban map
     * @throws IOException  in case of writing issues
     */
    private static void writeGoal(FileWriter writer, String[] lines) throws IOException {
        writer.write("  (:goal (and\n");

        for (int i = 0; i < lines.length; i++) {
            String line = lines[i];
            for (int j = 0; j < line.length(); j++) {
                char c = line.charAt(j);
                String loc = "pos" + i + "_" + j;

                if (c == TARGET) {
                    writer.write("    (boite_sur_cible box1)\n");
                }
            }
        }

        writer.write("  ))\n");
        writer.write(")\n");
    }
}

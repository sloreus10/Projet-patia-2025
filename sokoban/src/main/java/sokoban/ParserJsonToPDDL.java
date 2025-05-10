package sokoban;

import org.json.JSONObject;
import org.json.JSONTokener;

import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;

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
        }
    }

    public static void parseJsonToPDDL(String jsonFilePath, String pddlFilePath) throws IOException {
        FileInputStream fis = new FileInputStream(jsonFilePath);
        JSONObject jsonObject = new JSONObject(new JSONTokener(fis));

        String testIn = jsonObject.getString("testIn");
        String[] lines = testIn.split("\n");

        FileWriter writer = new FileWriter(pddlFilePath);

        writer.write("(define (problem sokoban-level1)\n");
        writer.write("  (:domain sokoban)\n");
        writer.write("  (:objects\n");

        // Write objects
        for (int i = 0; i < lines.length; i++) {
            for (int j = 0; j < lines[i].length(); j++) {
                writer.write("    l" + (i * lines[i].length() + j + 1) + "\n");
            }
        }

        writer.write("  )\n");
        writer.write("  (:init\n");

        // Write initial state
        for (int i = 0; i < lines.length; i++) {
            for (int j = 0; j < lines[i].length(); j++) {
                char c = lines[i].charAt(j);
                if (c == '#') {
                    writer.write("    (wall l" + (i * lines[i].length() + j + 1) + ")\n");
                } else if (c == '$') {
                    writer.write("    (box l" + (i * lines[i].length() + j + 1) + ")\n");
                } else if (c == '.') {
                    writer.write("    (goal l" + (i * lines[i].length() + j + 1) + ")\n");
                } else if (c == '@') {
                    writer.write("    (player l" + (i * lines[i].length() + j + 1) + ")\n");
                }
            }
        }

        writer.write("  )\n");
        writer.write("  (:goal (and\n");

        // Write goal state
        for (int i = 0; i < lines.length; i++) {
            for (int j = 0; j < lines[i].length(); j++) {
                char c = lines[i].charAt(j);
                if (c == '.') {
                    writer.write("    (box l" + (i * lines[i].length() + j + 1) + ")\n");
                }
            }
        }

        writer.write("  ))\n");
        writer.write(")\n");

        writer.close();
        fis.close();
    }
}

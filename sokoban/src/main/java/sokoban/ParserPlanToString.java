package sokoban;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ParserPlanToString {

    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java sokoban.ParserPlanToString <plan.txt>");
            System.exit(1);
        }

        String planFilePath = args[0];

        try {
            String planString = parsePlanToString(planFilePath);
            System.out.println(planString);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String parsePlanToString(String planFilePath) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(planFilePath));
        StringBuilder result = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            if (line.contains("move")) {
                if (line.contains("left")) {
                    result.append("L");
                } else if (line.contains("right")) {
                    result.append("R");
                } else if (line.contains("up")) {
                    result.append("U");
                } else if (line.contains("down")) {
                    result.append("D");
                }
            }
        }

        reader.close();
        return result.toString();
    }
}

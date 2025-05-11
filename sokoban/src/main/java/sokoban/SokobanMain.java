package sokoban;

import com.codingame.gameengine.runner.SoloGameRunner;

public class SokobanMain {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.err.println("Usage: java sokoban.SokobanMain <testCase> <planFile>");
            return;
        }

        SoloGameRunner gameRunner = new SoloGameRunner();
        gameRunner.setAgent(Agent.class);

        // Utiliser le cas de test fourni en argument
        gameRunner.setTestCase(args[0]);

        // Passer le fichier de plan à l'agent
        System.setProperty("planFile", args[1]);

        gameRunner.start(4200); // Temps limite de 4200 ms
    }
}

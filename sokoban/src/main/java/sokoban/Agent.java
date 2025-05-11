package sokoban;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Agent {
    public static void main(String[] args) {
        // Chemin vers le fichier de solution généré par le planificateur
        String planFile = System.getProperty("planFile");

        if (planFile == null) {
            System.err.println("Usage: java sokoban.Agent <planFile>");
            return;
        }

        File fichierSolution = new File(planFile);

        try (BufferedReader lecteur = new BufferedReader(new FileReader(fichierSolution))) {
            String res;
            while ((res = lecteur.readLine()) != null) {
                for (char c : res.toCharArray()) {
                    System.out.println(c);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

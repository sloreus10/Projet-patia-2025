package sokoban;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Agent {
    public static void main(String[] args) {
        File fichierSolution = new File("./src/pddlSokoban/Resultat.txt");
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

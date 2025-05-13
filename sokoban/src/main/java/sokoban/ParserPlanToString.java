package sokoban;

import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Ce parser lit un plan PDDL (temp_plan.txt) et convertit les actions en directions (L, R, U, D).
 * Il prend en charge les actions "move-player" et "push-box".
 */
public class ParserPlanToString {

    /**
     * Extrait les mouvements depuis un fichier de plan PDDL et les écrit dans un fichier texte.
     *
     * @param fichierPlan      Le fichier contenant le plan (ex : temp_plan.txt)
     * @param fichierDeSortie  Le fichier où seront écrits les mouvements sous forme de chaîne
     * @throws IOException     En cas d’erreur de lecture/écriture
     */
    public static void extraireMouvements(String fichierPlan, String fichierDeSortie) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(fichierPlan));
        FileWriter writer = new FileWriter(fichierDeSortie);

        StringBuilder mouvements = new StringBuilder();
        String ligne;
        Pattern pattern = Pattern.compile("\\((push-box|move-player)\\s+(pos-\\d+-\\d+)\\s+(pos-\\d+-\\d+)");

        while ((ligne = reader.readLine()) != null) {
            Matcher matcher = pattern.matcher(ligne.toLowerCase());
            if (matcher.find()) {
                String action = matcher.group(1);
                String pos1 = matcher.group(2);
                String pos2 = matcher.group(3);
                char direction = determinerDirection(pos1, pos2);
                if (direction != ' ') {
                    mouvements.append(direction);
                }
            }
        }

        reader.close();
        writer.write(mouvements.toString());
        writer.close();

        System.out.println("Mouvements : " + mouvements.toString());
        System.out.println("Mouvements enregistrés dans : " + fichierDeSortie);
    }

    /**
     * Détermine la direction (L, R, U, D) entre deux positions du style "pos-x-y"
     *
     * @param pos1 La position initiale
     * @param pos2 La position finale
     * @return Un caractère représentant la direction
     */
    private static char determinerDirection(String pos1, String pos2) {
        String[] p1 = pos1.split("-");
        String[] p2 = pos2.split("-");
        int x1 = Integer.parseInt(p1[1]);
        int y1 = Integer.parseInt(p1[2]);
        int x2 = Integer.parseInt(p2[1]);
        int y2 = Integer.parseInt(p2[2]);

        if (x1 < x2) return 'R';
        if (x1 > x2) return 'L';
        if (y1 < y2) return 'D';  // D pour Down
        if (y1 > y2) return 'U';  // U pour Up
        return ' ';
    }

    /**
     * Point d’entrée du programme. Prend 2 arguments : fichierPlan et fichierDeSortie
     *
     * @param args args[0] = chemin du fichier temp_plan.txt, args[1] = fichier de sortie pour les directions
     */
    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Usage: java sokoban.ParserPlanToString <fichierPlanPDDL> <fichierDeSortie>");
            System.exit(1);
        }

        try {
            extraireMouvements(args[0], args[1]);
        } catch (IOException e) {
            System.err.println("Erreur lors du traitement du fichier : " + e.getMessage());
            e.printStackTrace();
        }
    }
}

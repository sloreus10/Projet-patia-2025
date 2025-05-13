package sokoban;

import org.json.JSONObject;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

/**
 * Convertit un fichier JSON représentant une grille Sokoban en fichier PDDL conforme au domaine.
 */
public class ParserJsonToPDDL {

    record Coord(int x, int y) {}

    public static void genererFichierPDDL(String fichierJSON, String fichierPDDL) throws IOException {
        String contenu = new String(Files.readAllBytes(Paths.get(fichierJSON)));
        JSONObject json = new JSONObject(contenu);

        String testIn = json.getString("testIn");
        String[] lignes = testIn.split("\n");
        int height = lignes.length;
        int width = Arrays.stream(lignes).mapToInt(String::length).max().orElse(0);

        List<Coord> walls = new ArrayList<>();
        List<Coord> boxes = new ArrayList<>();
        List<Coord> goals = new ArrayList<>();
        Coord player = null;

        // Analyse du contenu ligne par ligne
        for (int y = 0; y < height; y++) {
            String ligne = lignes[y];
            for (int x = 0; x < ligne.length(); x++) {
                char c = ligne.charAt(x);
                Coord pos = new Coord(x, y);
                switch (c) {
                    case '#': walls.add(pos); break;
                    case '@': player = pos; break;
                    case '$': boxes.add(pos); break;
                    case '.': goals.add(pos); break;
                    case '*':
                        boxes.add(pos);
                        goals.add(pos);
                        break;
                    // espace : case vide, rien à faire
                }
            }
        }

        // Génération du fichier PDDL
        StringBuilder pddl = new StringBuilder();
        pddl.append("(define (problem sokoban-problem)\n");
        pddl.append("  (:domain sokoban)\n");

        // Déclaration des objets
        pddl.append("  (:objects\n");
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                pddl.append("    pos-").append(x).append("-").append(y).append(" - position\n");
            }
        }
        pddl.append("  )\n");

        // Initialisation
        pddl.append("  (:init\n");

        // Relations de voisinage (adjacent)
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                String from = "pos-" + x + "-" + y;
                if (x < width - 1) {
                    String to = "pos-" + (x + 1) + "-" + y;
                    pddl.append("    (adjacent ").append(from).append(" ").append(to).append(")\n");
                    pddl.append("    (adjacent ").append(to).append(" ").append(from).append(")\n");
                }
                if (y < height - 1) {
                    String to = "pos-" + x + "-" + (y + 1);
                    pddl.append("    (adjacent ").append(from).append(" ").append(to).append(")\n");
                    pddl.append("    (adjacent ").append(to).append(" ").append(from).append(")\n");
                }
            }
        }

        // Prédicats de mur
        for (Coord wall : walls) {
            pddl.append("    (wall pos-").append(wall.x).append("-").append(wall.y).append(")\n");
        }

        // Prédicats de cases libres (non murées)
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                Coord pos = new Coord(x, y);
                if (!walls.contains(pos)) {
                    pddl.append("    (free pos-").append(x).append("-").append(y).append(")\n");
                }
            }
        }

        // Boîtes
        for (Coord box : boxes) {
            pddl.append("    (has_box pos-").append(box.x).append("-").append(box.y).append(")\n");
        }

        // Cibles
        for (Coord goal : goals) {
            pddl.append("    (is_target pos-").append(goal.x).append("-").append(goal.y).append(")\n");
        }

        // Joueur
        if (player != null) {
            pddl.append("    (has_player pos-").append(player.x).append("-").append(player.y).append(")\n");
        }

        pddl.append("  )\n");

        // Objectif
        pddl.append("  (:goal (and\n");
        for (Coord goal : goals) {
            pddl.append("    (boiteSurCible pos-").append(goal.x).append("-").append(goal.y).append(")\n");
        }
        pddl.append("  ))\n)\n");

        Files.write(Paths.get(fichierPDDL), pddl.toString().getBytes());
    }

    public static void main(String[] args) {
        if (args.length < 2) {
            System.err.println("Usage: java sokoban.ParserJsonToPDDL <fichierJSON> <fichierPDDL>");
            System.exit(1);
        }

        try {
            genererFichierPDDL(args[0], args[1]);
            System.out.println("Fichier PDDL généré avec succès : " + args[1]);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

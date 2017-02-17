---
title: AIUS/Documents
subtitle: Documentation
date: "`2017-02-09`"
author:
- Luka <span style="font-variant:small-caps;">Vandervelden</span>
tags:
- documentation
- aius-documents
...

# Prérequis

  - moonscript (`>= 0.5.0`)
  - luafilesystem
  - lyaml

Pour installer tout ces outils avec Luarocks :

	luarocks install luafilesystem
	luarocks install lyaml
	luarocks install moonscript

Toutes les versions de Lua sont normalement prises en charge et compatibles.

La génération des documents demandera également d’utiliser *pandoc*, qui devra donc être installé également.
Les versions obsolètes de pandoc sont connues pour poser problème avec les documents de ce dépôt.

# Utilisation

	Usage: helper [-d] [-h] <command> ...

	Helper for AIUS’ documents.

	Options:
	   -d, --debug           Adds a verbose debug output.
	   -h, --help            Show this help message and exit.

	Commands:
	   h, help
	   l, list
	   b, build
	   c, clean
	   s, status
	   i, index

Chaque commande de l’outil admet une version courte.

Un message d’aide spécialisé est disponible pour chaque commande avec `./helper command --help`.

## Listes

`./helper list` va lister l’ensemble des fichiers du dépôt.

L’option `-c` va colorier les parties distinctives des noms de fichier, dont les sous-répertoires et les dates.

## Construction

`./helper build` va construire tout les documents du dépôt. `./helper build file.md` va construire uniquement les documents utilisant `file.md` comme source.

## Nettoyage

`./helper clean` retire les documents générés du dépôt, y compris les fichiers JSON qui servent de metadonnées pour les applications.

Des sources précises peuvent être passées en paramètre pour ne pas effectuer l’opération sur le dépôt entier.

## Status

`./helper status` analyse les sources du dépôt et détecte des défauts potentiels dans ces dernières.

Des sources précises peuvent être passés en paramètre pour ne pas effectuer l’opération sur le dépôt entier.

## Indexation

`./helper i` génère des fichiers JSON qui contiennent les métadonnées des en-têtes des sources du dépôt, ainsi qu’une page d’index en HTML.

# Structure

Les documents dans le dépôt sont stockés dans plusieurs répertoires.
Ces répertoires servent à grouper et trier les documents en fonction de leur contenu.

Les répertoires suivants existent actuellement :

  - `doc/`, utilisé pour stocker de la documentation ;
  - `pv/`, utilisé pour stocker les procès verbaux et compte rendus de réunions ou assemblées générales de diverses associations ;
  - `cr/`, utilisé pour stocker les compte rendus de réunions ou autres évènements où un actif de l’AIUS était présent et a pris des notes ;
  - `pv/comite/`, utilisé pour stocker les procès verbaux des réunions de comité de l’AIUS ;
  - `other/`, utilisé pour stocker les documents qui ne rentrent pas dans les catégories précédentes.

Le répertoire dans lequel se trouve le document est utilisé pour générer les “catégories” sur la page d’index des documents.
Les catégories sont représentées sous forme de carrés colorés à gauche des informations des documents.


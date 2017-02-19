---
title: \huge{Assurance qualité pour l’infrastructure de l’AIUS}
subtitle: Proposition de projet pour le cours de Génie Logiciel
date: "`2017-02-16`"
author:
- Luka <span style="font-variant:small-caps">Vandervelden</span>
toc-title: "Sommaire"
toc: false
dense: true
mainfont: Merriweather-Light
mainfontoptions:
- ItalicFont = Merriweather-LightItalic
- BoldFont = Merriweather-Regular
monofont: Fira Code
geometry:
- margin=1.5in
tags:
- cours
- L3
- infrastructure
...

\vspace{4em}

Ce document décrit une proposition de projet pour l’*Unité d’Enseignement* de *Génie Logiciel*.
Le projet proposé consiste à mettre en place des dispositifs de qualité d’assurance sur l’infrastructure de l’*AIUS* et de greffer des fonctionnalités manquantes sur cette dernière.

Cette proposition présente les besoins logiciels de l’association, son infrastructure actuelle, une liste de modifications à y apporter et les contraintes dans lesquelles ces modifications doivent être apportées, puis la liste des étudiants volontaires.

Ce document sera mis à jour à chaque fois qu’un étudiant viendra proposer sa contribution ou sa participation au projet ou à une tâche connexe.

\pagebreak

\tableofcontents

\pagebreak

# Introduction

L’AIUS[^AIUS] est une association étudiante qui a pour buts d’aider les étudiants à acquérir des connaissances techniques, de promouvoir l’utilisation de méthodes informatiques dans tout les domaines, et à défendre les intérêts des étudiants auprès des instances les concernant.

Pour assurer ses missions, l’AIUS organise des évènements de nature variée et met à disposition les services numériques de son infrastructure à ses adhérents.

L’infrastructure de l’AIUS doit également permettre aux membres actifs de l’association de mener à bien et efficacement les projets de l’association.

[^AIUS]: Amicale des Informaticiens de l’Université de Strasbourg

# Besoin initial

L’infrastructure de l’AIUS doit assurer de façon non exhaustive les fonctions suivantes :

  - garder trace des ventes effectuées dans le local ;
  - permettre les adhésions et la gestion des adhérents ;
  - faciliter l’accès et l’inscription aux évènements et services de l’AIUS, tels que des conventions de jeux de rôles, des conférences, des ateliers, des ventes de croque-messieurs, etc. ;
  - permettre l’hébergement de services ou de projets maintenus par ses adhérents pour des raisons universitaires ou ludiques ;
  - permettre l’hébergement et la publication des documents formels de l’association.

## Contraintes générales

Pour assurer ces fonctions et assurer leur maintien dans le temps, l’ensemble des services de l’AIUS doivent être facilement administrables et documentés.
Additionnellement, les services écrits et mis à jour par l’équipe de développement de l’AIUS doivent être maintenables, extensibles et facilement remplaçables.

Le renouvellement fréquent des membres de l’AIUS[^renouvellement] justifie le besoin de pouvoir retirer et remplacer n’importe quel composant de l’infrastructure sans conséquence néfaste majeure sur son ensemble.
Par exemple, le retrait du logiciel de caisse ne doit pas avoir de conséquence sur le logiciel de gestion des utilisateurs ou sur le logiciel de vente de croque-messieurs.

Chaque outil doit également pouvoir être maintenu par une équipe séparée et n’ayant que des connaissances limitées sur l’architecture de l’ensemble des services.
De cette manière, de petits groupes de développeurs ou d’étudiants peuvent maintenir, écrire ou, de manière générale, travailler sur des parties isolées du projet sans contrainte ou contrepartie sur le reste de l’équipe.

[^renouvellement]: Les membres changent dans leur intégralité tout les 3 à 5 ans. Certains restent moins longtemps.

### Services actuels

Plusieurs services ont déjà été développés pour répondre à certains des besoins les plus immédiats de l’association.
D’autres ont été entamés et abandonnés par manque de personnel dans l’équipe de développement.

----------------------------------------------------------------------------------
Nom            Fonction                                                Status
-------------- ------------------------------------------------------- -----------
authd          Authentification.                                       Utilisé

salesd         Ventes et caisse.                                       Utilisé

documents      Visualisation des procès verbaux et autres              Utilisé
               document formels.

aiusctl        Interface en ligne de commande aux outils de            À l’abandon
               l’AIUS. Sert principalement à tester le reste des
			   composants de l’infrastructure.

aiusctl-web    Interface web aux outils de l’AIUS.                     Utilisé

classesd       Outil d’organisation de cours et de parrainages.        En attente[^1]

crocsd         Ventes et réservations de croque-messieurs.             En attente

www            Site web.                                               À l’abandon

demons         Outil de gestion et d’inscription à des tables de       À l’abandon
               jeux de rôles.
----------------------------------------------------------------------------------

: Liste des micro-services développés pour l’AIUS

[^1]: Les projets sont en attente de développeurs prêts à compléter une implémentation initiale.

### Modularité

Pour s’assurer que les contraintes de modularité soient respectées, chaque service de l’AIUS est implémenté sous la forme d’un micro-service.

![Graphe de dépendance des services](resources/infra.pdf "Graphe de dépendances des services"){width=100%}

Chaque service doit assurer une fonction unique et ne dépendre que des composants utiles pour assurer cette fonction.

De plus, par soucis d’uniformité et pour permettre l’implémentation de nouveaux services dans des langages arbitraires, les services doivent communiquer entre eux avec des technologies courantes et suffisamment génériques.
HTTP et JSON ont été les technologies d’échange choisies.

Chaque service doit en conséquence être capable de recevoir des requêtes HTTP contenant des objets en JSON et de répondre en renvoyant de nouveaux objets en JSON.

### Homogénéité

Les outils utilisés par l’AIUS doivent être développés de façon à ce que de nouveaux développeurs puissent remplacer l’équipe de maintenance sur une échelle de quelques années seulement.
Pour se faire, les API publiques et privées de chaque application se doivent d’être intuitives et correctement documentées.

Il est également important d’écrire du code idiomatique pour des raisons de lisibilité et de cohérence.

Chaque projet devrait avoir des contraintes strictes et documentées sur son *coding style*, et des relectures[^pair-prog] devraient être faites pour s’assurer que ce coding style est respecté.

[^pair-prog]: La programmation par paires peut être utilisé dans ce but, mais les tâches devront être validées par un autre développeur du projet.

## Besoins spécifiques

### Gestion des ventes

L’AIUS doit disposer d’un logiciel de caisse pour éviter la gestion des ventes manuelle.
La caisse doit être accessible depuis une machine dédiée dans le local de l’AIUS ou depuis celle d’un membre de l’équipe de l’association[^panne].

Les ventes doivent être archivées et accessibles à distance.

La gestion des stocks et la comptabilité sont des options utiles et régulièrement considérées, mais pas encore jugées comme prioritaires par l’association.

Certaines ventes évènementielles (par exemple, les croque-messieurs) répondent également à des règles uniques (par exemple, sélection des ingrédients par les adhérents) et des outils de gestion adaptés permettraient une réduction de la charge de travail des organisateurs.

[^panne]: La machine dédiée tombe souvent en panne.
Quand cela arrive, l’ordinateur portable d’un membre doit pouvoir être utilisé jusqu’à ce que la machine dédiée soit à nouveau en état de marche.

### Gestion des adhérents

La gestion de la liste des adhérents est actuellement faire sur papier.

Une transition vers une base de données numérique est nécessaire pour pouvoir assurer un plus grand nombre de services et de façon automatique.

Un outil capable de gérer une liste d’adhérents, leurs côtisations, leurs comptes utilisateurs correspondants, et leurs rôles potentiels dans l’équipe de l’AIUS est nécessaire.

### Objectifs pédagogiques & ludiques

Un des objectifs de l’AIUS est d’organiser des évènements ou services à visée pédagogique ou ludique.

Le système de parrainage des amicales[^ademaius], l’organisation d’ateliers et l’organisation de conventions en font partie.
Ces évènements et services sont en revanche couteux en temps organisationnel et des solutions logicielles[^demons-aius] sont régulièrement demandées par les membres du comité de l’association.

De manière générale, l’association demande des outils permettant aux organisateurs d’évènements de laisser les participants s’inscrire et gérer les données utiles qui leur sont liés.
Les besoins exacts sont variables au cours du temps et doivent être définis de façon précise avec les organisateurs des différents projets.

[^ademaius]: L’ADEM contribue à mettre en place des parrainages au même titre que l’AIUS.

[^demons-aius]: Un outil d’inscription et de gestion de tables de jeux de rôles était à une époque maintenu par l’AIUS — `aius-demons`.
L’outil est actuellement en cours de réécriture.

# Architecture

## Authentification

Le composant d’authentification, `authd` ou `aius-authd`, sert de couche d’abstraction entre la base de données des utilisateurs, stockée dans une base de données en LDAP, et le reste de l’infrastructure.
Elle sert principalement à occulter la complexité de LDAP, tout en conservant des structures de données flexibles capable d’associer des données arbitraires[^2] aux utilisateurs.

`authd` fonctionne avec un système de jetons — ou en anglais *tokens* — pour authentifier les utilisateurs auprès des applications.
Chaque utilisateur (ou client) envoie un nom d’utilisateur et un mot de passe en échange d’un jeton.
Ce jeton pourra être fourni aux services qui imposent une authentification ou des permissions.
Chacun de services qui reçoit un jeton pourra demander des informations sur l’utilisateur auprès d’`authd`.

[^2]: Par exemple, des groupes de permission, de la configuration UNIX, ou n’importe quel autre type de meta-données utiles que pourrait vouloir utiliser une application.

## Ventes & caisse

La caisse, `salesd` ou `aius-salesd` enregistre les ventes effectuées dans le local de l’association.

Elle dépend d’`authd` pour la gestion des permissions et d’une base de données postgresql pour le stockage de données.

## Publications

Un outil de construction et de visualisation des documents écrits par l’association a été mis en place.
Il est écrit en Moonscript, génère des pages d’index publiques en HTML statique et exporte des documents en divers formats grace à pandoc.

L’outil porte les noms de `documents` ou `AIUS/documents`.

## Interface(s)

### aiusctl-web

`aiusctl-web` est le nom de l’interface web aux divers services de l’AIUS.

`aiusctl-web` dépend d’`authd` pour l’authentification de l’utilisateur, et communique ensuite avec chaque micro-service de façon séparée.

Le projet a été écrit à l’aide de VueJS[^3].

[^3]: Voir [références](#références).

### aiusctl

`aiusctl` est l’interface alternative aux services de l’AIUS, fonctionnant en ligne de commande et écrite en Crystal.

Une interface en ligne de commande permettrait de plus facilement tester les divers services, mais le projet a été mis en attente en l’absence d’un nouveau mainteneur.

# Gestion de projet

## Git

Le code de l’AIUS est actuellement déposé sur [Github](https://github.com/AIUS).

L’utilisation de git sera imposée pour travailler sur le présent projet.

## Phabricator

Un outil de gestion de projet nommé *Phabricator* est mis à disposition par l’AIUS pour la gestion de toutes les tâches de développement.

L’outil permet, entre autres, de lister des tâches sur des tableaux kanbans et fournit un wiki.

## Équipes

Chaque micro-service pouvant être écrit dans des technologies complètement différentes, plusieurs équipes peuvent être formées et pourront travailler de façon autonome et en parallèle.
Les équipes seront en mesure de tester leurs projets de façon croisée (en les testant les uns avec les autres).

# Extensions

Plusieurs des services actuels, bien que fonctionnels, pourraient profiter de fonctionnalités additionnelles.

## Gestion des utilisateurs

`authd` ne permet pour le moment pas aux utilisateurs d’éditer leurs informations personnelles.

Il est pour le moment également impossible pour un administrateur de créer, retirer ou modifier d’autres utilisateurs.

## Adhésions

Les services actuels ne permettent pas à des tiers d’entamer leur adhésion en ligne.
Les adhésions en ligne pourraient être implémentées dans `authd` et `aiusctl-web`.

# Documentation

L’ensemble de la documentation des projets logiciels de l’AIUS se limite actuellement aux fichiers de `README` (ou `README.md`) contenus dans les dépôts des projets respectifs.

Cette documentation est incomplète, parfois incohérente, et souvent peu utilisable pour des personnes n’ayant pas accès aux développeurs d’origine.

## API publique

Le format des requêtes reçues et renvoyées par chaque service est l’élément principal à documenter.

Le contenu de chaque objet transmis ainsi que les en-têtes particuliers qui pourraient être traités par les services concernés.

> ```json
> {
> 	"username": "i-am-test",
> 	"password": "i-am-secret"
> }
> ```
> 
> Exemple : HTTP/GET sur `aius-auth/token`

> ```json
> {
> 	"token": "123e4567-e89b-12d3-a456-426655440000"
> }
> ```
> 
> Exemple : HTTP/GET depuis `aius-auth/token`

Il n’existe actuellement aucune forme de documentation centralisée ou aucun standard de documentation à suivre.
La mise en place de tels outils sera donc un objectif du projet.

## API privée

Les objets, méthodes, fonctions ou autres outils utilisés en interne par chaque outil sont également peu documentés, rendant la contribution aux projets existants difficile.

## Architecture & intégration

L’architecture de l’infrastructure et les interactions entre ses composants devront être documentés.

La configuration des composants extérieurs et des instructions de déploiement claires devront être fournies.

# Tests

Le code écrit par l’AIUS n’est pour le moment *pas* testé.

Un des buts du projet sera d’écrire des suites de test cohérentes et complètes pour les divers composants de l’infrastructure de l’AIUS.

## Intégration

## Fonctionnels

## Unitaires

La mise en place de tests unitaires n’est pas considérée comme prioritaire par l’AIUS, contrairement aux tests d’intégration et aux tests fonctionnels.

## Intégration continue

Aucun mécanisme d’intégration continue n’est actuellement mis en place au sein des projets de l’AIUS.

Mettre en place des mécanismes d’intégration continue pourrait être un objectif du projet.
Il est à noter que l’AIUS possède désormais du matériel permettant d’effectuer des tâches de construction et de tests de façon intensive, et la mise en place de ce matériel ferait alors partie des objectifs des étudiants concernés.

## Difficultés attendues

L’hétérogénéité des différentes technologies utilisées risque de consommer plus de temps à l’équipe de développement.
En particulier, la rédaction des tests devra se faire dans plusieurs langages et avec des outils différents.
La collecte et la centralisation des résultats des différents tests fera donc partie des objectifs du projet.

L’interaction avec les développeurs ou mainteneurs des divers projets — eux aussi étudiants et souvent indisponibles —, risque également de provoquer des délais pour les diverses équipes.

## Considérations sur la sécurité

Chaque micro-service communique sur le réseau et utilise des ressources fournies par les serveurs de l’AIUS.
L’utilisation de ressources sur le réseau provoque des risques de sécurité indéniables.

Des relectures de code — ou *audits* — devront être effectués en plus des tests d’intégration et fonctionnels.
Ces relectures auront pour objectif de détecter des failles de sécurité potentielles et de réduire les risques pour l’infrastructure dans son ensemble.

# Nouveaux outils

En plus des services actuels, un besoin a été exprimer pour écrire plusieurs nouveaux outils pour l’AIUS.

## Vente de croque-messieurs

L’AIUS organise une vente de croque-messieurs une fois par semaine.
Chaque croque-monsieur est composé d’une liste d’ingrédients variable, et la sélection de ces ingrédients est à faire par l’adhérent.

La gestion des réservations de croque-messieurs et de leur composition se fait actuellement à l’aide d’une feuille de tableur-grapheur.

Un outil de gestion dédié permettant la réservation en ligne par les adhérents simplifierait le coût organisationnel de l’évènement.

## Adhésions en ligne

L’adhésion à l’AIUS se fait actuellement sur papier.
Les adhérents de l’AIUS pouvant demander l’accès à de nombreux services (ssh, machines virtuelles, croque-messieurs, etc.), des comptes sur l’infrastructure de l’association doivent être également créés.
Ces comptes sont pour le moment créés sur demande et au cas par cas.

Permettre des pré-adhésions en ligne réduirait le travail de gestion des adhérents et permettrait de créer des comptes utilisateurs de façon systématique.

Un tel outil devrait également pouvoir permettre aux adhérents de gérer leur compte en ligne (mot de passe, données personnelles, etc.) sans avoir à passer par l’équipe d’administration de l’AIUS.

Le projet est nommé `crocsd` dans le reste du document.

## Parrainages et cours

Les amicales étudiantes, tant l’AIUS que l’ADEM, organisent régulièrement des parrainages pour aider les étudiants en difficulté.
Ces parrainages sont organisés au cas par cas et sur des sujets restraints.

Un outil en ligne permettant aux étudiants — ou enseignants — de s’inscrire pour demander ou offrir du soutient ou des cours pour des sujets variés — universitaires ou non — faciliterait le partage des connaissances dans la faculté.

Le projet est nommé `classesd` dans le reste du document.

# Équipe

## Étudiants

**Luka Vandervelden** :

   - Chargé de mission à l’AIUS
   - Chargé de mission à l’ASCMI
   - Membre de sxb.so et du Hackstub
   - Ancien mainteneur de pkg++

**Guillaume Grosshenny** :

   - Président de l’AIUS

**Alexandre Combeau**

**Paul Roux FIXME**

**FIXME: NEED MOAR PEOPLE**

## Contributeurs extérieurs

Bien que le projet présenté ici ne concerne que des étudiants inscrits à l’*UE* de Génie Logiciel, leur interaction avec le reste de l’équipe de l’AIUS sera requise.
L’équipe de développement et d’administration de l’AIUS avec laquelle devront travailler les étudiants est donc présentée ici.

Il est à noter qu’une grande partie de cette équipe est composée d’administrateurs système, et qu’ils imposeront des contraintes pratiques supplémentaires sur le code écrit pour pouvoir le déployer en production.

**Quentin *Sandhose* Gliech** :

  - Administrateur réseau à l’AIUS
  - Mainteneur de `aius-authd`.

**Éloïse *Niveale* Stein** :

  - Vice administratrice réseau à l’AIUS
  - Développeuse de `aiusctl-web`.

**Ludovic *deimos* Muller** :

  - Développeur de `aiusctl-web`.

**Marie-France *caswitch* Kommer** :

  - Développeuse de `aius-salesd`.

**Mickaël *Mika* Bauer** :

  - Développeur de `aius-salesd`.

## Tâches

Les sections suivantes du document concernent des « *tâches* » — ou projets — spécifiques, qui peuvent être données à des groupes d’étudiants séparés.

La plupart de ces « tâches » peuvent être effectuées en parallèle, mais certaines demanderont de communiquer ou de travailler avec d’autres groupes pour des problèmes précis.
Par exemple, le groupe travaillant sur `aiusctl-web` devra échanger avec la plupart des autres groupes, et sa taille devra donc être proportionnée.

### aiusctl

Objectifs :

  - Réécrire ou compléter l’outil `aiusctl`.
  - Écrire une batterie de tests fonctionnels pour l’infrastructure complète avec `aiusctl`.

Détails techniques :

> `aiusctl` est écrit en Crystal.

Difficultés :

> Les tests fonctionnels demanderont l’installation et la configuration des autres composants de l’infrastructure.

Prérequis :

> Étudiants requis : 3 à 4

### aiusctl-web

Objectifs :

  - Compléter l’outil `aiusctl-web`.
  - Écrire une batterie de tests fonctionnels ou unitaires.
  - Écrire de la documentation.

Détails techniques :

> `aiusctl-web` est écrit en JavaScript avec VueJS.
>
> Le nombre d’étudiants requis dépend du nombre de groupes travaillant sur les projets de l’AIUS.

Prérequis :

> Étudiants requis : 1 à 4 étudiants.

### Gestion d’utilisateurs

Objectifs :

  - Implémenter la gestion des utilisateurs dans `authd`.
    Les opérations à implémenter seront la liste des utilisateurs, leur retrait, la vérification des cotisations et l’édition de leurs informations personnelles.
  - Implémenter une gestion d’erreur propre dans `authd`.
    Les erreurs devront être documentées.
  - Compléter la documentation d’`authd`.
  - Écrire des tests fonctionnels ou unitaires.
  - Faire enregistrer des journaux utiles et homogènes à l’application.

Détails techniques :

> `authd` est écrit en Rust.

Difficultés :

> Rust est à considérer comme étant un langage difficile pour les débutants en raison des concepts d’extrêmement haut niveau qu’il implémente — par exemple, la durée de vie des références.
>
> Si aucun autre groupe ne travaille sur `aiusctl-web`, quatre à cinq étudiants seront nécessaires.

Prérequis :

> Étudiants requis : 3 à 5

### Adhésions en ligne

Objectifs :

  - Implémenter un système de pré-adhésion et ligne et de validation des adhésions par les membres du comité de l’AIUS.
  - Écrire la documentation et les tests correspondants.
  - Intégrer l’outil dans `aiusctl-web` pour le rendre immédiatement exploitable.

Détails techniques :

> `authd` est écrit en Rust et `aiusctl-web` en VueJS.
>
> Si aucun autre groupe ne travaille sur `aiusctl-web`, les trois étudiants seront nécessaires.

Difficultés :

> `authd` est écrit en Rust.
> Voir « Gestion des utilisateurs ».

Prérequis :

> Étudiants requis : 1 à 3

### salesd

Objectifs :

  - Écrire des tests fonctionnels.
  - Documenter les API internes.
  - Documenter le format des entrées et sorties du service.
  - Améliorer la capacité de l’outil à être configuré — fichiers de configuration, plus d’options en ligne de commande, variables d’environnement.
  - Faire enregistrer des journaux utiles et homogènes à l’application.

Détails techniques :

> `salesd` est écrit en Crystal.
>
> Si aucun autre groupe ne travaille sur `aiusctl-web`, les trois étudiants seront nécessaires.

Difficultés :

> La documentation sur Crystal est encore relativement faible.
> Beaucoup de documentation sur Ruby est en revanche encore valable pour Crystal.

Prérequis :

> Étudiants requis : 1 à 3 étudiants.

### crocsd

Objectifs :

  - Écrire un outil de gestion des réservations et des ventes de croque-messieurs.
  - Les quantités d’ingrédients et leur consommation devront être pris en charge.
  - Écrire la documentation et les tests — fonctionnels ou unitaires — correspondant.

Détails technique :

> Le langage de programmation et les outils à utiliser sont au choix[^au-choix] des étudiants du groupe.
>
> Si aucun autre groupe ne travaille sur `aiusctl-web`, les quatre étudiants seront nécessaires.

Prérequis :

> Étudiants requis : 2 à 4 étudiants.

[^au-choix]: Java est interdit pour des raisons de performances.
PHP est interdit pour des raisons de maintenance.
Les langages fortement typés ou fournissant des garanties sur la bonne exécution des programmes sont bien entendu préférés.

### classesd

Objectifs :

  - Écrire un cahier des charges en collaboration avec le comité de l’AIUS.
  - Implémenter l’outil en utilisant `authd` pour gérer l’authentification et les utilisateurs.
  - Implémenter l’interface correspondante dans `aiusctl-web`.
  - Écrire la documentation correspondante.
  - Écrire une batterie de tests fonctionnels ou unitaires.

Détails techniques :

> Le langage de programmation et les outils à utiliser sont au choix des étudiants du groupe.
>
> Si aucun autre groupe ne travaille sur `aiusctl-web`, 5 à 8 étudiants seront nécessaires.

Prérequis :

> Étudiants requis : 3 à 8 étudiants.

# Références

  - <http://moonscript.org>

    > Langage de programmation *Moonscript*.

  - <http://crystal-lang.org> 

    > Langage de programmation *Crystal*.

  - <https://www.rust-lang.org>

    > Langage de programmation *Rust*.

  - <https://vuejs.org>

    > Cadre applicatif *VueJS*, utilisé pour le développement web d’applications riches et conformes aux recommandations du *material design*.

  - <http://pandoc.org>

    > Outil de conversion générique de documents *pandoc*.


Conductivité thermique négative des chaînes de rotors avec forçage mécanique
============================================================================

Prérequis :

    1) Installer Julia v1.4 (https://julialang.org)

    2) Depuis le terminal exécuter le script install_packages.jl, qui se
       trouve dans le répertoire racine de se projet :

        julia install_packages.jl

Afin de faire exécuter le code aussi vite que possible il est conseillé
d'utiliser le Julia REPL. Depuis le terminal lancer le REPL :

    julia --check-bounds=no

Veuillez noter que la première execution du code ci-dessous
nécessite le chargement de plusieurs bibliothèques. Ce chargement dure
quelques secondes. En exécutant le code depuis le Julia REPL, après la
première exécution, le code s'exécute beaucoup plus rapidement.

============================================================================

Afficher le moment cinétique moyenne de la chaîne depuis le Julia REPL :

    include("src/plots/plot_average_momentum.jl

============================================================================

Afficher l'erreur entre la loi jointe des distances/impulsions et le produit
tensoriel des distances/impulsions depuis le Julia REPL :

    include("src/plots/plot_distribution_error.jl

============================================================================

Afficher le flux d'énergie depuis le Julia REPL :

    include("src/plots/plot_energy_current.jl

============================================================================

Afficher le flux d'énergie "normale" (calculé avec plot_energy_current.jl)
depuis le Julia REPL :

    include("src/plots/plot_energy_current_normal.jl

============================================================================

Afficher le flux d'énergie "étrange" (calculé avec plot_energy_current.jl)
depuis le Julia REPL :

    include("src/plots/plot_energy_current_strange.jl

============================================================================

Afficher la distribution de la distance du rotor le plus chaud depuis
le Julia REPL :

    include("src/plots/plot_gibbs_distance.jl

============================================================================

Afficher la distribution du moment cinétique du rotor le plus chaud
depuis le Julia REPL :

    include("src/plots/plot_gibbs_momentum.jl

============================================================================

Afficher la température de plusieurs chaînes de tailles différentes depuis
le Julia REPL :

    include("src/plots/plot_scaled_temperature.jl

============================================================================

Afficher la température de la chaîne depuis le Julia REPL :

    include("src/plots/plot_temperature.jl

============================================================================

Afficher la conservation d'énergie du schéma de Verlet depuis le
Julia REPL :

    include("src/plots/plot_verlet_energy.jl

============================================================================

Afficher la relation entre l'énergie et le pas de temps du schéma de Verlet
depuis le Julia REPL :

    include("src/plots/plot_verlet_energy_spread.jl

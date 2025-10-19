# Documentation

https://kayno0o.github.io/gwj-86-godot/index.html

## Organization des scripts

### Variables

Dans l'ordre :
1. enum
2. var
3. @export
4. @onready
5. signal

### Fonctions

1. func _init
2. func _ready
3. func _process
4. func _physics_process
5. func _unhandled_input
6. autres fonctions
7. fonction de signaux

## Livraison

### Prérequis

https://bun.sh

### Déploiement

`bun pm version patch && git push --follow-tags`

t'attends 5 minutes, et logiquement c'est sur github

ça fonctionne avec `patch`, `minor`, `major`
- **patch** : `v0.0.X` = fix de bugs
- **minor** : `v0.X.0` = ajouts mineurs
- **major** : `vX.0.0` = gros changements

# Kaynooo

- [x] refactor/simplify and document state machine

# Pediluve EN URGENCE

- [ ] Refactor spawner : faire spawn en dehors de la zone de jeux (path2D ou Area2D) / mettre un effet de brouillard là ou ça peut spawn
- [ ] Parler à kaynoo a propos d'une state "bodygard" pour les attaquant : ils choisisse un masqué random qu'ils decide de garder, les tank eux reste a coté du totem pour tank et tempo. ça permet au attaquant de pouvoir defendre (oui) les unités et evite qu'ils glande h24 au totem avec les tank


# Global

- [x] animation de la récolte d'item
- [x] animation du déposit d'item
- [x] stone
- [x] blé
- [X] mask gris récolte la pierre
- [X] mask orange récolte le blé
- [x] idle trop longtemps -> wandering
- [X] animation d'attaque
- [X] transporters
- [x] Lacher l'inventaire du masked quand il meurt
- [X] pour payer, les transporteurs doivent transporter les items du totem vers le feu
- [x] state saccrifice des mask pour payer une upgrade
- [ ] les ennemies drop des souls
- [ ] particules de mort

- [ ] spawner à ressource

- [ ] camera

- [ ] skill tree (en mode nodes)
- [ ] Hero
  - [ ] stats du hero = stats du mask + bonus * 2, sauf pour inventory_size et health = bonus de tous les masks
  - [ ] le hero peut changer de masque pour changer de rôle principal
  - [ ] le hero respawn 15 secondes après sa mort

# BUG

- [ ] baston + inventaire plein = sais plus ou aller
- [ ] spawner `implicit_ready: Invalid type in function 'new' in base 'GDScript'.`
  - `The Object-derived class of argument 1 (CharacterBody2D (Villain))`
  - `entity.gd:32, Spawner.gd:50, Spawner.gd:31`

# skill tree

- transporter
  - débloquer l'affichage des stats

# EZ (mais pas prio)

- [ ] Rendre les white mask pacifiste
- [ ] les unités se heal pendant la journée

# Later

- [ ] drag and drop new totems to positions
- [ ] agrandir les mini totem à chaque upgrade
- [ ] faire un vrai saccrifice (pas juste un tween)

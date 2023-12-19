# lis
Life is Strange experimental demake

## Directory Layout

From [Reddit](https://redd.it/7786ee/)
```
/
    entities/
        player/
            player.tscn
            player.gd
        enemies/
            generic_enemy.gd
            enemy.tscn #base scene to be overridden
            boss_enemy.gd
            boss.tscn #base scene to be overridden
        actor.tscn
        actor.tres
        actor.gd
    globals/ #used as autoloads
        notifications.tscn
        lobby.tscn
        serialization.tscn
    menus/ #for scenes that are used standalone 2d menus, or popups
        title/
            title.tscn
            font_title.tres
    ui/ #for any assets related to UI that are reused
        theme_default/
            assets/
                [...] #generally pngs for interface
            theme_default.tres
        font_uidefault.tres
        cool_font.ttf
    scenes/ #scenes where a player will probably be instantiated
         common/
             assets/
                 [...]
             prefabs/ #premade designs for inclusion in a level elsewhere
                 [...].tscn
             common_gridmap.tres
         main/
             assets/
                 [...]
             main.tscn
             [...]
         overworld/
             assets/
                 [...]
             overworld.tscn
             [...]
         dungeon/
             assets/
                 [...]
             dungeon.tscn
             [...]
```
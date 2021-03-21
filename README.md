# Visual Novel
> This repository is currently private and meant to be accessed by only those who are working on this project

__Please read the following links__ before starting with collaboration on git
1. [Using Git and GitHub for Team Collaboration](https://docs.google.com/document/d/1mKd73Ums7ni0IoFjBYn3bLag_5NwFDtxpwCU-Xra1sY/edit?usp=sharing)
2. [Version Control (Git Plugin) in Godot Editor](https://docs.godotengine.org/en/stable/getting_started/workflow/project_setup/version_control_systems.html)

And of course-

3. [The Godot Official Documentation](https://docs.godotengine.org/en/stable/index.html)

## Resource Nomenclature
- Scene files are saved as **"s_<scene_name>.tscn"**
>**s_** is indicator of the file being directly related to a _scene_. In this case, it is the entire scene file itself.
- Folders for scenes are saved as **f_s_<scene_name>**
 >**f_** is indicator of _Folder_.
 - Resources e.g., fonts are saved as **r_dfd_<font_name>.tres**
 > **r_** is indicator of _Resource_
 > **dfd_** of _Dynamic Font Data_ (a godot resource type)
 > Similarly, **df_** for _Dynamic font_

## Project Directory Structure
As of now you may see some directories in the repo i.e.

 - ### Commons/
To keep the resources/scenes/assets that are meant to be reused heavily throughout the game in different contexts. **Note that these files are supposed to be standalone**, which means if you use them in level(or scene) in the game, you should be **EXXTRA careful _as to not write back changes permanently_.**

Whenever you instance a _common_ scene in your work, if you need to    make changes in local context,
- Right Click on the instanced Scene (node)
- Select the **Make scene Local** option

This will copy the scene as part of the parent scene and will no longer ruin the scene file saved in commons/

However, any **resources referenced** e.g. (textures and most importantly, _scripts_) in the instanced node, **will point to the same location on disk**. To overcome that, make sure to manually and    recursively make all sub-resources and their properties local, (if    required) and save new resources in the current scene folder.

 - ### Levels/
To have 8 sub-directories names "Level1/", "Level2/".. to save Level scene and resources local to the level. Pretty self explanatory.
 - ### Other Scenes/
To have scenes that are not really _reusable_ (as in commons/) and not really level related. e.g. the Intro scene.

>_Do not move any files around the repository without prior discussion. There are formalities that will need to be synced with the editor as well as collaborators._

## Contributing to the project
We have to be _very_ communicative about our work and try best not to touch files that are being used by other people. Let's figure out branches that everyone is going to work on, and how to merge them safely.

## More to be added later `¯\_(ツ)_/¯`
Working  with the Godot editor is going to be quite a task, _please (I insist) contact me for any queries._
>(Pranjal)

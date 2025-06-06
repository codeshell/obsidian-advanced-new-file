## Obsidian Advanced New File

![Obsidian Downloads](https://img.shields.io/badge/dynamic/json?logo=obsidian&color=%23483699&label=downloads&query=%24%5B%22obsidian-advanced-new-file%22%5D.downloads&url=https%3A%2F%2Fraw.githubusercontent.com%2Fobsidianmd%2Fobsidian-releases%2Fmaster%2Fcommunity-plugin-stats.json)


Obsidian Advanced New file is a plugin for [Obsidian](https://obsidian.md/), that provide functionality to choose folder over note creation.
The new note file is created with `Untitled.md` filename just to provide same behavior as default Obsidian.

The plugin is heavily inspired by [Note refactor](https://github.com/lynchjames/note-refactor-obsidian) and [similar extension](https://marketplace.visualstudio.com/items?itemName=dkundel.vscode-new-file) for Vs Code.

## Features

**Hint:** you can set command `advanced new file` to shortcut like `Ctrl/Cmd` + `Alt` + `N`.

Spawn command `advanced new file` and choose directory. Then you can type full path to file.

### Custom File Extensions

The plugin now supports creating files with custom extensions! When you specify a filename with an extension, the plugin will create the file with that exact extension. If no extension is provided, it defaults to `.md`.

**Examples:**
- `my-canvas.canvas` → creates `my-canvas.canvas` (Obsidian Canvas file)
- `data.json` → creates `data.json` (JSON file)
- `script.js` → creates `script.js` (JavaScript file)
- `myfile` → creates `myfile.md` (defaults to Markdown)

This is particularly useful for creating Canvas files (`.canvas`), which are commonly used in Obsidian for visual note-taking and mind mapping.

https://user-images.githubusercontent.com/8286271/163267550-3699ec7d-27e3-4ea4-9bba-a0d9afeef44e.mp4



### How to develop

- Clone this repo.
- `npm i` or `yarn` to install dependencies
- `npm run dev` to start compilation in watch mode.

### Manually installing the plugin

- Copy over `main.js`, `styles.css`, `manifest.json` to your vault `VaultFolder/.obsidian/plugins/your-plugin-id/`.

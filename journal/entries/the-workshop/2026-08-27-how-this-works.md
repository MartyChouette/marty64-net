# This is your private dev log

Only you get past the passphrase on the way in. Each game you make gets
its own section in the sidebar, and every section holds as many entries as
you want. Talk about bugs, half-formed ideas, implementation notes, whatever.

## Writing a new entry

Open `edit.html` (the **+ write** link, top-left). First time only, click
**Connect journal folder** and pick this `journal` folder. After that the
editor writes straight into your files. Then:

1. Pick a game, or choose **+ new game** and name it.
2. Give the entry a title, a date, tags, and a **format**.
3. Write in markdown.
4. Paste a screenshot right into the text box. It gets saved as a real
   image file under `media/` and dropped in where your cursor was.
5. Hit **Save entry to disk**, then commit and push:

```
git add -A
git commit -m "journal: new entry"
git push
```

## Formats give each entry a different look

- **log** - monospace, tight. Good for bug hunts and terminal-flavored notes.
- **essay** - serif, roomy. Good for longer reflection.
- **gallery** - lays images out in a grid. Good for screenshot dumps.
- **raw** - plain, so your own HTML/markdown drives the styling.

Each game also has its own **accent color**, so switching sections feels
like switching rooms.

## A note on "secret"

The passphrase hides this from anyone browsing marty64.net. The files still
live in the public repo, so treat this as *hidden*, not *encrypted*. Nothing
here should be something you'd be hurt by a determined person finding.

> Change the passphrase anytime: in the editor, use the **Set the viewer
> passphrase** tool at the bottom, then paste the hash into `viewer.js`.

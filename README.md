# CV template

A [Typst](https://typst.app) CV template that renders from YAML. Content and publishing live in
[cv-content](https://github.com/alisheryeginbay/cv-content), which pulls this repo in at a pinned tag.

- `template.typ` — layout and styling; exports `render(data)`
- `fonts/` — bundled Inter and Source Serif 4 (SIL OFL), used instead of system fonts so local and CI builds match
- `example.yaml` / `example.typ` — sample data covering every section, used to preview and test the template

## Usage

```sh
brew install typst   # once
make                 # build example.pdf
make watch           # rebuild on every change
```

CI builds `example.pdf` on every push and PR, and uploads it as a workflow artifact.

## Data format

See `example.yaml`. Every top-level section is optional: leave a key out and its section disappears.
Free-text fields support Typst markup (`*bold*`, `_italic_`, `#link("url")[text]`).

## Releasing

cv-content uses a tagged version of this repo, so template changes never reach the published CV until you
opt in:

```sh
git tag v1.1.0 && git push origin v1.1.0
```

Then bump `TEMPLATE_REF` in cv-content's `Makefile`.

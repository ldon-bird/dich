![Image of a disc changer](https://i.imgur.com/2ysAhJj.png "Disc changer")

# dich
dich (pronounced "ditch") stands for DIsc CHanger, a profile/configuration file manager. Switch between your profiles as if you are using a good-ol' CD changer.

---

dich was written when I was binge-downloading data from the Corpenius Data Store. Its API uses a profile file for each account, and I needed to switch between them frequently.
It should be useful for similar uses.

## First time setup

Clone this repository in a favorable location.

Before running, edit the `config.json` file and the `CONFIG_FILE` variable in `dich.sh` based on your needs.

**Important**: Use absolute paths for `CONFIG_FILE` in `dich.sh`, and `directory` and `target` in `config.json` if you intend to run it from elsewhere.

You might also want to add execute permission, create a link of `dich` and add to `PATH` variable by:

```bash
chmod u+x dich.sh
ln -s dich.sh dich
export PATH=`pwd`:$PATH
```
Use `dich -i` to initialize first before running other modes.

## Usage

dich has four primary modes: init `-i`, get `-g`,next `-n`, and set `-s`. The modes are pretty much self-explanatory.

* Use `dich -i` to initialize first before running other modes.

After this, you can edit the list of candidate files `config.json` manually, or `dich -i` again if there are changes.

* `-g` would output the current state that the target file is in.

* Use `-n` flag to update the target file to the next file in the candidate file list, or use `-s` to interactively specify a file to overwrite to the target.

* Use `-h` flag for a brief help message.

# dich
dich (pronounced "ditch") stands for DIsc CHanger, a profile/configuration file manager.

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

## Usage

dich has four primary modes: init `-i`, get `-g`,next `-n`, and set `-s`. The modes are pretty much self-explanatory.

Use `dich -i` to initialize first before running other modes.

Use `dich -h` for a brief help message.

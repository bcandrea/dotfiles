Description
===========

A more or less standard set of config files, plus a rakefile to manage them.

Installation & Usage
====================

The installation process uses rake. Use the `list` task to display all the dotfiles:

    $ rake list

or the `install` task to copy all the files to your home directory:

    $ rake install

Note that you can override the contents of the configuration files by providing patches; just put
the .patch files in the `patches` directory. For example, if you need local modifications to the
`.emacs` file, you can

 1. modify it
 2. diff and store the patch:
 
        $ cd ~/dotfiles
        $ diff -Naur base/.emacs ../.emacs > patches/.emacs

There is a task that can be invoked to automatically store all the local modifications to the patches
directory:

    $ rake sync

During the next invocation of `rake install`, the patch will be applied after copying the base file.

As a result, a common workflow that can be adopted is the following:

 * first install the dotfiles as they are:
   
        $ cd ~/dotfiles
        $ rake install
 
 * if a local modification is needed, edit the file in your home directory and then sync the dotfiles:

        $ vi ~/.emacs
        $ cd ~/dotfiles
        $ rake sync

 * if the modification is generic, edit the file in the `base` directory, commit it, push it and install it:

        $ cd ~/dotfiles
        $ vi base/.emacs
        $ git commit -a
        $ git push
        $ rake install    # we assume that your local modification are already stored as patches

Further documentation
=====================

Run `rake -T` from the command line to get an up-to-date list of available tasks.

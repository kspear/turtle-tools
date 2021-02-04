local install_dir = fs.getDir(shell.dir()) .. "/tt"
shell.setDir(install_dir)
require("main")
main.startup("Hello world")
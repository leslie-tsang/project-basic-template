Name
====

`project-basic-template` - an <u>OS-independent</u> container development framework

Table of Contents
===================

* [Name](#name)
* [Description](#description)
* [Project Structure](#project-sructure)
* [Report Bugs](#report-bugs)

Description
===========

`project-basic-template` is a full-fledged development framework,
aims to provide a user-friendly out-of-the-box container development environment.

[Back to TOC](#table-of-contents)

Project Structure
==============

```shell
.
├── Makefile  # project helper driven by makefile                   
├── Readme.md # project self-description document
└── ci
    ├── Makefile                  # project ci helper driven by makefile
    ├── docker-compose.devops.yml # devops docker-compose yaml
    ├── docker-compose.lint.yml   # devops linter docker-compose yaml
    ├── pod                       # docker-compose pod meta folder
    │   ├── build
    │   │   └── release
    │   │       ├── Dockerfile    # basic devops image dockerfile
    │   │       └── entrypoint.sh # basic devops image entrypoint script
    │   └── lint
    │       ├── eclint
    │       │   └── Dockerfile    # basic eclint image dockerfile
    │       └── spellcheck
    │           └── Dockerfile    # basic spellcheck image dockerfile
    └── utils
        └── linux-common.sh       # basic linux utils script
```

[Back to TOC](#table-of-contents)

How to launch
=============

Use the `make` command to show the project's built-in cmd.

```shell
$ make
[ info ] Makefile rules:

    make help                 : Show Makefile rules
    make devops               : Run DevOPS container
    make devops_build         : Build DevOPS container image
    make devops_clean         : Clean up DevOPS container
    make lint                 : Run lint check
    make lint_build           : Build lint container image
    make lint_clean           : Clean up lint container
    make publish              : Publish release artifact in pure mode
    make release              : Release current project without version control
    make release_clean        : Clean up release artifact
```

Use `make devops` to launch devops devel container.

```shell
$ make devops
[ info ] _devops -> [ Start ]
[+] Building 0.0s (0/0)                                                                                                                                                                 docker:desktop-linux
[+] Creating 1/0
 ✔ Network project_template_default  Created                                                                                                                                                            0.0s 
[+] Building 0.0s (0/0)                                                                                                                                                                 docker:desktop-linux
devops:~/workbench# 
```

devops container will mount project folder as `/root/workbench` in container.

then, you are ready to go.

[Back to TOC](#table-of-contents)

Report Bugs
===========

You're very welcome to report issues on [GitHub](https://github.com/leslie-tsang/project-basic-template/issues)

[Back to TOC](#table-of-contents)

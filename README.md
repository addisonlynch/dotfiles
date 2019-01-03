# Addison Lynch's Dotfiles

Below are my dotfiles. They contain aliases and other handy commands for making life easier in a Linux development environment. I hope to customize a Mac version soon.

## Contents

* Third Party Softare Used
* Aliases
* Environment Configuration

## 3rd Party Software Used



* [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/)
	* *managing virtualenvs*
* [pip-review](https://github.com/jgonggrijp/pip-review)
	* *managing pip packages*
* [GRC (coloring)](https://github.com/garabik/grc)
	* *colorization*
* [dotfiles-framework](https://github.com/wking/dotfiles-framework)
	* *managing dotfiles*
* [pip](https://pypi.org/project/pip/)
    * *Python package manager*


## Aliases


### Coreutils

| Alias  | Command | Notes
|:---|:---| :----|
| ``..``  | ``cd ..``  | - |
| ``...``  | ``cd ../.. `` | - |
| ``....``  | ``cd ../../..``  |  - |
| ``.....`` | ``cd ../../../..`` | - |
| ``.3`` | ``cd ../..``  |  - |
| ``.4``  | ``cd ../../..``  | - |
| ``.5`` | ``cd ../../../..`` | - |
| ``~`` | ``cd ~`` | - |
| | |
| ``c`` | ``clear`` | - |
| ``cp`` | ``cp -iv`` | prompt before overwrite |
| ``ll`` | ``ls -alGF`` | long listing, no group
| ``llm`` | ``ls -alGF --block-size=m`` | long listing, no group with MB block size|
| ``la`` | ``ls -A`` | long listing, no .. or . |
| ``l`` | ``ls -CF`` | append indicator, list entries by column |
| ``lr`` | ``ls -R \| grep ":$" \| sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/\|/'\'' \| less`` | full recursive directory listing
| ``mkdir`` | ``mkdir -pv`` | make necessary parent directories |
| ``mkd(DIR)`` | ``mkdir -p "$1" && cd "$1"`` | make dir and step inside |
| ``mv`` | ``mv -iv`` | prompt before overwrite |
| ``ff(FILENAME)`` | ``/usr/bin/find . -name "$@"`` | find file under current directory |
| ``ffs(STR)`` | ``/usr/bin/find . -name "$@"'*'`` | find file whose name starts with ``STR`` |
| ``ffe(STR)`` | ``/usr/bin/find . -name '*'"$@"`` | find file whose name ends with ``STR`` |
| ``lsock`` | ``sudo lsof -i -P`` | list of all open sockets |
| ``lsock_t`` | ``sudo lsof -i -P \| grep TCP`` | list of all open TCP sockets |
| ``lsock_u`` | ``sudo lsof -i -P \| grep UDP`` | list of all open UDP sockets |
| ``openPorts`` | ``sudo lsof -i \| grep LISTEN`` | list of all open ports
| ``allPorts`` | ``sudo netstat -tulanp \| grep LISTEN`` | detailed list of all open ports |
| ``firewall`` | ``sudo iptables -L -n -v --line-numbers`` | list all firewall rules
| ``updateapt`` | ``sudo apt-get update && sudo apt-get upgrade`` | update and upgrade at the same time |
| ``zipf(DIR)`` | ``zip -r "$1".zip "$1"`` | zip directory ``DIR`` |
| ``ii`` | - | displays system information (users logged in, machine status, etc.) |

### System Resources



| Alias  | Command | Notes
|:---|:---| :----|
| ``memhogs`` | ``ps auxf \| sort -nr -k 4 \| head -10``|
| ``cpuhogs`` | ``ps auxf \| sort -nr -k 3 | head -10 |


### tmux


I am an avid user of [tmux](https://github.com/tmux/tmux). Below are some aliases which make the software more useful for me:

#### System Aliases


| Alias | Command | Notes
| :---|:---|:---|
| ``tat`` | ``tmux att -t`` | attach session|
| ``tls`` | ``tmux ls`` | list sessions |
| ``tkill`` | ``tmux kill-session -t`` | kill session|
| ``trename`` | ``tmux rename-session -t`` | rename session |
| ``tstart`` | ``tmuxp load`` | load session |

#### .tmux.conf bindings


**\\\TODO**

#### Plugins

* [tmux-gitbar](https://github.com/arl/tmux-gitbar)


### Python


Below are some Python-related aliases

| Alias | Command | Notes
| :---- | :--- | :---|
| ``pywork`` | ``source /usr/local/bin/virtualenvwrapper.sh`` | activate [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/) |
| ``python3`` | ``python3.6`` | forces Python 3.6 shell |
| ``pip3`` | ``pip3.6`` | forces pip 3.6 |
| ``pip`` | ``python2.7 -m pip`` | forces pip 2.7 |
| ``preview`` | ``pip-review`` | pip status using [pip-review](https://github.com/jgonggrijp/pip-review) |
| ``pupdate`` | ``pip-review --auto`` | update all pip packages automatically |
| ``pupdate_i`` | ``pip-review --interactive`` | update pip packages (step through one-by-one) |

### Coloring Enhancements


The following commands are colored using [GRC](https://github.com/garabik/grc) when available (all aliases not listed):

* ``as``
* ``diff``
* ``dig``
* ``g++``
* ``gas``
* ``gcc``
* ``head``
* ``ifconfig``
* ``ld``
* ``make``
* ``mount``
* ``netstat``
* ``ping``
* ``ps``
* ``tail``
* ``traceroute``

## Environment Configuration

I use the following software for various development environments:

* Sublime Text 3


### Sublime Text 3


#### Configuration

See


#### Plugins

* Sublime SFTP - *SFTP Client*
* GitGutter - *Shows git diff in gutter*
* Sublime-Notes - *Syntax highlighting for notetaking*
* SublimeLinter - *Code linting*
* TrailingSpaces - *Highlight and delete trailing whitespace*
* MarkdownLivePreview - *Preview markdown*


**Python**

* AutoPEP8 - *Automatic PEP-8 formatting
* Jedi - *Python auto-completion*
* SublimeLinter-flake8 *SublimeLinter plugin for flake8*

**Prolog**

* Prolog - *Prolog syntax highlighting*

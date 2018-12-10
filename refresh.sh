#! /bin/bash

LOGFILE="/var/log/daily_scripts/dotfiles.log"

BACKUP_ROOT="/var/backups/dotfiles/"
DATE=`date +%Y-%m-%d"-"%H-%M`
DEST=$BACKUP_ROOT$DATE

FILES=("$HOME/.bashrc" "$HOME/.bash_aliases" "$HOME/.tmux.conf")
 
TAR_EXT='.tar'
GZ_EXT='.gz'

TAR_FILENAME=$DATE$TAR_EXT
echo $TAR_FILENAME 
TODAY=`date`
BU_FILE_COUNT=0


update_header()
{
	printf "\n\n********************************************\n\tDotfiles Update r
	Log for:\n\t" | tee -a $LOGFILE
	echo $TODAY | tee -a $LOGFILE
	printf "********************************************\n" $TODAY | tee -a $LOGFILE
	printf "see ${LOGFILE} for details\n\n"
}

backup_dotfiles()
{

	printf "Backing up current dotfiles...\n\n" | tee -a $LOGFILE
	tar cf "$TAR_FILENAME" --files-from /dev/null

	for i in "${FILES[@]}"
	do
	    echo "Backing up "$i | tee -a $LOGFILE
	    BU_FILE_COUNT=$(( $BU_FILE_COUNT + 1 ))
	    tar rf "$TAR_FILENAME" -P "$i"
	done

	printf "\nCreating "$TAR_FILENAME"...\n" | tee -a $LOGFILE
	gzip "$TAR_FILENAME"
	printf "Moving to "$BACKUP_ROOT"...\n" | tee -a $LOGFILE
	mv $TAR_FILENAME$GZ_EXT $BACKUP_ROOT

	printf "DONE" | tee -a $LOGFILE
	printf "\n\n********************************************\n" | tee -a $LOGFILE
	echo $BU_FILE_COUNT dotfiles were backed up | tee -a $LOGFILE
	printf "********************************************\n" $TODAY | tee -a $LOGFILE
}

update_dotfiles(){
	echo "update dotfiles"
}

check_git(){
#!/bin/bash
GITNAME="dotfiles"
DIR=~/"dotfiles"

cd $DIR

if [ "`git log --pretty=%H ...refs/heads/master^ | head -n 1`" = "`git ls-remote origin -h refs/heads/master |cut -f1`" ] ; then
    status=0
    statustxt="up to date"
else
    status=1
    statustxt="not up to date"
fi

if [[ `git status --porcelain` ]]; then
    status=1
    statustxt="uncommited"
fi

}
#backup_dotfiles
echo check_git

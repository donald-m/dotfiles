#!/bin/bash
# Most from dotfiles of Paul Irish

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && cd "$@"
}

# List all files, long format, colorized, permissions in octal
function la(){
    ls -l  "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
    cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}



# git commit browser. needs fzf
log() {
    git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
    --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
    xargs -I % sh -c 'git show --color=always % | less -R'"
}



# Start an HTTP server from a directory, optionally specifying the port
function server() {
    local port="${1:-8000}"
    open "http://localhost:${port}/" &
    # statikk is good because it won't expose hidden folders/files by default.
    # yarn global add statikk
    statikk --port "$port" .
}


# Copy w/ progress
cp_p () {
    rsync -WavP --human-readable --progress $1 $2
}



# get gzipped size
function gz() {
    echo "orig size    (bytes): "
    cat "$1" | wc -c
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}


# preview csv files. source: http://stackoverflow.com/questions/1875305/command-line-csv-viewer
function csvpreview(){
    sed 's/,,/, ,/g;s/,,/, ,/g' "$@" | column -s, -t | less -#2 -N -S
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract() {
    if [ -f "$1" ] ; then
        local filename=$(basename "$1")
        local foldername="${filename%%.*}"
        local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
        local didfolderexist=false
        if [ -d "$foldername" ]; then
            didfolderexist=true
            read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                return
            fi
        fi
        mkdir -p "$foldername" && cd "$foldername"
        case $1 in
            *.tar.bz2) tar xjf "$fullpath" ;;
            *.tar.gz) tar xzf "$fullpath" ;;
            *.tar.xz) tar Jxvf "$fullpath" ;;
            *.tar.Z) tar xzf "$fullpath" ;;
            *.tar) tar xf "$fullpath" ;;
            *.taz) tar xzf "$fullpath" ;;
            *.tb2) tar xjf "$fullpath" ;;
            *.tbz) tar xjf "$fullpath" ;;
            *.tbz2) tar xjf "$fullpath" ;;
            *.tgz) tar xzf "$fullpath" ;;
            *.txz) tar Jxvf "$fullpath" ;;
            *.zip) unzip "$fullpath" ;;
            *) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# animated gifs from any video
# from alex sexton   gist.github.com/SlexAxton/4989674
gifify() {
    if [[ -n "$1" ]]; then
        if [[ $2 == '--good' ]]; then
            ffmpeg -i "$1" -r 10 -vcodec png out-static-%05d.png
            time convert -verbose +dither -layers Optimize -resize 900x900\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > "$1.gif"
            rm out-static*.png
        else
            ffmpeg -i "$1" -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > "$1.gif"
        fi
    else
        echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
    fi
}

# turn that video into webm.
# brew reinstall ffmpeg --with-libvpx
webmify(){
    ffmpeg -i "$1" -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y "$2" "$1.webm"
}

# direct it all to /dev/null
function nullify() {
    "$@" >/dev/null 2>&1
}


# visual studio code. a la `subl`
function code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCodeInsiders" --args $*; }

# `shellswitch [bash |zsh]`
#   Must be in /etc/shells
shellswitch () {
    chsh -s $(brew --prefix)/bin/$1
}

# stop php, nginx, mariadb or all
function halt() {
    if [[ $@ == "php" ]]; then
        command brew services stop php
        elif [[ $@ == "nginx" ]]; then
        command sudo brew services stop nginx
        elif [[ $@ == "mariadb" ]]; then
        command brew services stop mariadb
        elif [[ $@ == "all" ]]; then
        command sudo brew services stop nginx
        command brew services stop php
        command brew services stop mariadb
    fi
}

# start php, nginx, mariadb or all
function start() {
    if [[ $@ == "php" ]]; then
        command brew services start php
        elif [[ $@ == "nginx" ]]; then
        command sudo brew services start nginx
        elif [[ $@ == "mariadb" ]]; then
        command brew services start mariadb
        elif [[ $@ == "all" ]]; then
        command brew services start mariadb
        command brew services start php
        command sudo brew services start nginx
    fi
}

# List all services
function list() {
    if [[ $@ == "all" ]]; then
        command brew services list
    fi
}


#  Open in Finder
function o() {
    if [[ $@ == "~" ]]; then
        command open ~
        elif [[ $@ == "sar" ]]; then
        command open $HOME/GitHub/sunriseafrica.org.uk/
        elif [[ $@ == "sartheme" ]]; then
        command open $HOME/GitHub/sunriseafrica.org.uk/web/app/themes/sunriseafrica
        elif [[ $@ == "etc" ]]; then
        command open /usr/local/etc
        elif [[ $@ == "pics" ]]; then
        command open $HOME/Pictures
        elif [[ $@ == "gh" ]]; then
        command open $HOME/GitHub
    fi
}

# Open in terminal
function ot() {
    if [[ $@ == "sar" ]]; then
        cd $HOME/GitHub/sunriseafrica.org.uk/
        elif [[ $@ == "sartheme" ]]; then
        cd $HOME/GitHub/sunriseafrica.org.uk/web/app/themes/sunriseafrica
        elif [[ $@ == "etc" ]]; then
        cd /usr/local/etc
        elif [[ $@ == "pics" ]]; then
        cd $HOME/Pictures
        elif [[ $@ == "gh" ]]; then
        cd $HOME/GitHub
    fi
}

# Open github repo in current dir
function github() {
  giturl=$(git config --get remote.origin.url)
  if [ "$giturl" == "" ]
    then
     echo "Not a git repository or no remote.origin.url set"
     exit 1;
  fi
  giturl=${giturl/git\@github\.com\:/https://github.com/}
  giturl=${giturl/\.git//}
  echo $giturl
  open $giturl
}

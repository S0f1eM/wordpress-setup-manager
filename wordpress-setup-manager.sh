#!/bin/bash

#(｡◕‿◕｡)
# Automatize your WordPress installation

# ======================
# = Script installation =
# ======================
#bash path/to/the/script/file/auto-install-wp.sh $1 $2 $3
#$1 folder name
#$2 website name
#$3 database name

#Don't forget to change and replace all the variables and default path

# colorize and formatting command line
# You need iTerm and activate 256 color mode in order to work 
green='\x1B[0;32m'
cyan='\x1B[1;36m'
blue='\x1B[0;34m'
grey='\x1B[1;30m'
red='\x1B[0;31m'
bold='\033[1m'
normal='\033[0m'

# Jump a line
function line {
  echo " "
}

# bot
function bot {
  line
  echo -e "${blue}${bold}(｡◕‿◕｡)${normal}"
}


# VARS 
# admin email 
email=""

# login admin 
admin="$1-wpmanage"

# path to the wordpress websites folder
pathtoinstall="/path/to/the/wordpress-website/folder/"

# path to the plugin list file plugins.txt 
pluginfilepath="/path/to/the/plugin-list/file/plugins.txt"

# parse the current directory name
currentdirectory=${PWD##*/}

#url 
url=http://localhost/$currentdirectory
# end VARS ---


# Stop on error
set -e


bot "${blue}${bold}================== Hello ! ====================="

# Welcome !
bot "${blue}${bold} I am your assistant for your wordpress installation.${normal}"
echo -e "         Ready to install you WordPress website for : ${cyan}$2${normal}"

#Se positionne dans le dossier des sites web
cd $pathtoinstall

# vérifie si le dossier existe déjà
if [ -d $1 ]; then
  bot "${red}The folder ${cyan}$1${red}already exists${normal}."
  echo "         For safety's sake, I'm not going any further than that to avoid crushing anything."
  line

  # quit script
  exit 1
fi

# créer le répertoire
bot "${blue}${bold}Phase 1 -${normal} I create the folder: ${cyan}$1${normal}"
mkdir $1
cd $1
bot "${blue}${bold}Phase 1 -${normal} I create a folder cms to download wordpress in"
mkdir cms
cd cms

# Télécharge WP
bot "${blue}${bold}Phase 1 -${normal}I download ${cyan}${bold}WordPress${normal}..."
wp core download   

# check version
bot "${blue}${bold}Phase 1 -${normal} I got the version: ${cyan}${bold}" 
wp core version

#renommer le répertoire /plugins en /extensions 
#penser à modifier la constant PLUGINDIR vers le nouveau chemin
#dans la phase 3 ?

# create base configuration - wp-config.php file - dbuser -> A REMPLACER
bot "${blue}${bold}Phase 1 -${normal} I launch the configuration and create the file ${cyan}wp-config.php:"
wp core config --dbname="$2" --dbuser="" --dbpass="" --skip-check --extra-php 
define( 'WP_DEBUG', true );


#edition of wp-config.php for database info
#bot "${blue}${bold}Phase 1 -${normal} Editing wp-config.php to modify dbuser, dbpass and dbname"
#echo "Edit the wp-config.php ? (y/n)"
#read run
#if [ "$run" = "y" ]; then
#vi wp-config.php

#bot "${blue}${bold}Phase 1 -${normal} Editing the wp-config.php to change the table prefix? (le module de sécurité secupress le fait automatiquement)"
#echo "edite the wp-config.php ? (y/n)"
#read run
#if [ "$run" = "y" ]; then
#vi wp-config.php

#fi 
# Create database
bot "${blue}${bold}Phase 1 -${normal} I create the database:"
wp db create 

# generate random password
bot "${blue}${bold}Phase 1 -${normal} I create a password too:"
password=$(LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c 12)
echo $password  
bot "${grey}Your password will be displayed at the end of the installation."

# launch install - don't forget to change the url/path 
bot "${blue}${bold}Phase 1 -${normal} Now I install WordPress core!"
wp core install --url="http://localhost/$currentdirectory" --title="$2" --admin_user=$admin --admin_email=$email --admin_password=$password

clear

line
bot  "${green}${bold}Phase 1 OK - Wordpress is installed.${normal}"
line
echo "===================================================================="
echo "         Login admin :  $admin"
echo -e "         Password :  ${cyan}${bold} $password ${normal}${normal}"
line
echo "===================================================================="
line
bot   "${cyan}${bold}Phase 2 - Do you want an advanced installation ?"
echo "          Install the basic features ?(y/n)"

# add a simple yes/no confirmation before we proceed
read advanced

# if the user didn't say no, then go ahead an install
if [ "$advanced" == y ] ; then

# Plugins install 
bot "${blue}${bold}Phase 2 -${normal} I install the plugins from the list of plugins on the $pluginfilepath :"
while read line || [ -n "$line" ]
do
    wp plugin install $line --activate
done < $pluginfilepath
wp plugin status
wp plugin update --all

# Create standard pages
bot "${blue}${bold}Phase 2 -${normal} I create standard pages :"
echo " - Home"
echo " - Contact"
wp post create --post_type=page --post_title='Home' --post_status=publish
wp post create --post_type=page --post_title='Contact' --post_status=publish

# Misc cleanup
bot "${blue}${bold}Phase 2 -${normal} I delete Hello Dolly, the basic themes and example articles"
wp post delete 1 --force 
wp post delete 2 --force 
wp plugin delete hello
wp theme delete twentyfifteen
wp theme delete twentysixteen
wp option update blogdescription ''

# cat and tag base update
wp option update category_base theme
wp option update tag_base sujet

line
line

bot "${green}${bold}Phase 2 OK - Advanced installation is complete !${normal}"
line
echo "===================================================================="
line

fi

bot  "${cyan}${bold}Phase 3 -  Do you want to improve the security of the directory?${normal}"
echo "         Modify tree structure, retrieve .htaccess,.gitignore, functions.php preconfigured?(y/n)"
bot  "         ${red}SIf not, the.htaccess and.gitignore files will still be recovered, since they are necessary in both cases. ${normal}"

# add a simple yes/no confirmation before we proceed
read secure

# if the user didn't say no, then go ahead an install
if [ "$secure" == y ] ; then

bot "${blue}${bold}Phase 3 -${normal} I will now secure the ${green}${bold} folder of your new site."
line
 
#Move the file wp-config.php to avoid overwriting it at each update

bot "${blue}${bold}Phase 3 -${normal} I move the file ${green}wp-config.php${normal} to the root of the project."
echo "This will prevent it from being overwritten at the next update."
cd $pathtoinstall/$1/cms/
mv wp-config-sample.php $pathtoinstall/$1/wp-config.php

#Move the wp-content to the root of the project so that it is no longer accessible online
bot "I move the wp-content folder to the root of the project"
mv wp-content $pathtoinstall/$1/
bot "I edit the file and redefine the WP_CONTENT_DIR and the WP_CONTENT_URL."
cd $pathtoinstall/$1/cms/
sed -i  78i"define( 'WP_CONTENT_DIR', dirname(__FILE__) . '/cms' );" wp-config.php
sed -i  79i"define('WP_CONTENT_URL', 'http://localhost/$currentdirectory');" wp-config.php
sed -i  19i"// Voir https://core.trac.wordpress.org/ticket/15733" wp-config.php
sed -i  20i"$_SERVER['HTTPS'] = 'on';" wp-config.php
sed -i  21i"// Voir https://core.trac.wordpress.org/ticket/19337#comment:8" wp-config.php
sed -i  22i"$_SERVER['REMOTE_ADDR']=$_SERVER['HTTP_X_FORWARDED_FOR'];" wp-config.php
fi


#recovery of the.htaccess file and the.gitignore file and robots.txt
# put all this section in comments if you don't have your own preconfigured files
bot "${blue}${bold}Phase 3 -${normal} I get the files:"
bot " ${green}sample.htaccess${normal} at the root of the project"
cp $pathtoinstall/SAMPLEfiles/sample.htaccess $pathtoinstall/$1/.htaccess
bot " ${green}sample.gitignore${normal} at the root of the project"
cp $pathtoinstall/SAMPLEfiles/sample.gitignore $pathtoinstall/$1/.gitignore
bot " ${green}robots.txt${normal}"
cp $pathtoinstall/SAMPLEfiles/robots.txt $pathtoinstall/$1/robots.txt


#Delete the install.php and README.html
bot "${blue}${bold}Phase 3 -${normal} I delete the file ${grey}install.php${normal} and ${grey}README.html${normal}" 
cd $pathtoinstall/$1/cms/wp-admin/
rm install.php 
cd $pathtoinstall/$1/cms/
rm readme.html

bot "${green}${bold}Phase 3 OK - The security of the directory is improved!${normal}"
line
echo "===================================================================="

bot "${cyan}${bold}Do you want to 'git' your new project ?(y/n)"
read gitinit

# if the user didn't say no, then go ahead an install
if [ "$gitinit" == y ] ; then
#Git project
cd  $pathtoinstall/$1
git init    # git project
git add -A  # Add all untracked files
git commit -m "Initial commit"   # Commit changes

fi

# That's all ! 
echo "===================================================================="
bot "${green}${bold}The site installation ${cyan}$2${normal} is finally finished!"
line
echo "Database name: $3"
echo "Login admin : nimda-$1"
echo -e "Password : ${cyan}${bold} $password ${normal}${normal}"
echo "Connection Url: $url/$1"
line
echo -e "${grey}(Don't forget to write down the password!)"
echo "===================================================================="
bot "See you !"
line
line

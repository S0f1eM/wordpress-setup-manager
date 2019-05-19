# wordpress-setup-manager
Script to install a WordPress site with wp-cli.

## Installation

Just downloading the file zip on your computer wherever you want. For example, at the root folder of your wordpress websites and replacing the variables with your own data.

## Prerequisites 

You need wp-cli on your computer for using this script. 
For the wp-cli installation and prerequisites follow this link https://wp-cli.org/#installation 

* UNIX-like environment (OS X, Linux, FreeBSD, Cygwin); limited support in Windows environment
* PHP 5.4 or later
* WordPress 3.7 or later. Versions older than the latest WordPress release may have degraded functionality

## Usage

Don't forget to change and replace the variables and default path on the file before running it.

```bash
bash path/to/the/script/file/nom-du-script.sh $1 $2 $3 
#$1 for the folder name 
#$2 for the website name 
#$3 for the database name 
```

## Script workflow 
* Phase 1:
	* Creation of a folder for the new website
	* Download the last version of wordpress core
	* Setup the wp-config.php and the database configuration 
	* Installing Wordpress
* Phase 2 : advanced installation :
	* Downloading plugins listed
	* Create Home and Contact page 
	* Delete Hello dolly, demo post and somme theme
	* update tag and base
* Phase 3 : Improve security folder :
	* Move the wp-config.php to the root of the project
	* Move the wp-content folder to the root of the project and redefine WP_CONTENT_DIR and WP_CONTENT_URL
	* Recory your .htacess file, gitignore and robots.txt if you have ones configured
	* Delete the install.php and README.html
	* Git the project


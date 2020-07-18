

# WordPress Installation (｡◕‿◕｡) Assistant Manager   


### Table Of Contents
* [Introduction](#intro)
* [System requirements](#prerequisites)
* [Installation](#setup)
* [Usage](#usage)
* [Features](#features)
* [Links](#links)

## Introduction<a name="intro"></a>

This script was made for installing several WordPress websites hosted on internal servers.
I used Bash and wp-cli tools.

## System requirements<a name="prerequisites"></a>

You need wp-cli on your computer for using this script. 
For the wp-cli installation and prerequisites follow this link https://wp-cli.org/#installation

* UNIX-like environment (OS X, Linux, FreeBSD, Cygwin); limited support in Windows environment
* PHP 5.4 or later
* WordPress 3.7 or later. Versions older than the latest WordPress release may have degraded functionality.


## Installation<a name="setup"></a>

Just downloading the file zip on your computer. 
The script must be at the root folder of your wordpress websites.

## Usage<a name="usage"></a>

Go to the directory where are your WordPress websites folder in which you want to use the script. 
You will need also 2 .txt files : 
* 1 for listing websites path you want to update.
* 1 .txt for the major plugins names you want to desactivate before at the beginning of the process, before the update. They will be reactivate at the end.

Before running the script with the following command you need to change and replace all the variables and default path in the file according to your needs.  

```bash
bash path/to/the/script/file/nom-du-script.sh $1 $2 $3 
#$1 for the folder name 
#$2 for the website name 
#$3 for the database name 
```
## Features<a name="features"></a>

The script will walk throught the following actions : 
	
* Phase 1:
	* Creation of a folder for the new website.
	* Download the last version of wordpress core.
	* Setup the wp-config.php and the database configuration.
	* Installing Wordpress last version.
* Phase 2 : Ask if you want advanced installation :
	* Downloading plugins listed.
	* Create Home and Contact pages.
	* Delete Hello dolly, demo post and somme theme.
	* update tag and database.
* Phase 3 : Ask in you want to improve security folder :
	* Move the wp-config.php to the root of the project.(optional)
	* Move the wp-content folder to the root of the project and redefine WP_CONTENT_DIR and WP_CONTENT_URL.(optional)
	* Replace your .htacess file, gitignore and robots.txt if you have ones configured.(optional)
	* Delete the install.php and README.html.(will be executed)
	* Ask if you want to Git the project.(optional)

## Links<a name="links"></a>

* *[WP-CLI](https://wp-cli.org/fr/)*






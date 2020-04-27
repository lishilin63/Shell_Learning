#!/bin/bash
set -e

FILE="$0"

echo "Using files: ${FILE}"
JQUERY=''
ssh data@sleet.lga.appfigures.com "pypy diffs.py $FILE | jq  -c '$JQUERY'" > diff.json
echo 'Comparing diffs and running'
cmp -s old_diff.json diff.json &&  echo "Old and new diff file are the same. Try and rerun again later." || sudo -H -u josh python beta_update.py -f diff.json
echo 'SimApp Update Complete'

----------------------------------------------------------------------------------------------------------
# appbase-stats.sh
#!/bin/bash
set -e

DATE="$1"
YEAR=`date -d $DATE +'%G'`
gsutil cat gs://appbase-us/$YEAR/$DATE-full.gz | pv | zcat | ./remove_sizes.sh | ./jquery.sh | python appbase_main.py -d $DATE -db appbase.db


# make .sh excutable
chmod +x appbase-stats.sh

# run .sh file with arg
./appbase-stats.sh 2019-01-01

# open a file and could edit it. ^x for saving
nano appbase-stats.sh 

# parallel dryrun check if the sh could run
parallel --dryrun './appbase-stats.sh {}' ::: 2019-03-01 2019-02-01 
# parallel computing with two args 
parallel './appbase-stats.sh {}' ::: 2019-03-01 2019-02-01
# zcat file and run it on python
pv appbase.gz | zcat | ./remove_sizes.sh | ./jquery.sh | python appbase_main.py --date 2019-03-21 --database appbase.db


# enter virtual environment
virenv "folder"
source "folder"/bin/activate
eg. source appbase/bin/activate


# appbase_daily.sh
# the .sh file runs several scripts on appbase data receving from bowser
# type 'ssh george@bowser' to enter bowser server 

# 11/06/2019 update new path for appbase data '/opt/appbase-data/output/raw' looks like this
# 2019-11-03       2019-11-04       2019-11-05       diff-2019-11-03-full  diff-2019-11-04-full  diff-full-2019-11-05  error-2019-11-04  stats-2019-11-05.json
# 2019-11-03-full  2019-11-04-full  diff-2019-11-03  diff-2019-11-04       diff-2019-11-05       error-2019-11-03      full-2019-11-05

# on airflow
# if task fails, click the faild circle and clean it. Then it will re-run right away


# crontab -e
# create automation start at 10am daily, file any progress into log.txt
0 10 * * * bash /home/george/appbase-stats/appbase-daily.sh > /home/george/appbase-stats/log.txt 2>&1

----------------------------------------------------------------------------------------------------------



#zcat appbase.gz | ./remove_sizes.sh | jq -r '[.active, .product_id, .store, .categories.main, (.categories.all|tostring), .type, .deviceset, (.prices|tostring), ((.sdks | map( [.sdk_id, .active ]) | tostring))]| @csv'

#zcat appbase.gz | ./remove_sizes.sh | jq -r '[.active, .product_id, .store, [if .categories.main then .categories.main else (.categories.all|tostring) end], .type, .deviceset, [if .prices["143441"] then .prices["143441"] else (.prices|tostring) end], ((.sdks | map( [.sdk_id, .active ]) | tostring))]| @csv'

# use this one for jquery.sh
#zcat appbase.gz | ./remove_sizes.sh | jq -r '[.active, .product_id, .store] + [if .categories["main"] then .categories["main"] else ( .categories["all"] | tostring) end] + [.type, .deviceset] + [if .prices["143441"] then .prices["143441"] else (.prices|tostring) end] + [((.sdks | map( [.sdk_id, .active ]) | tostring))]| @csv'

#get_product_file.sh | ./remove_sizes.sh | jq -r 'select(.["active"] == true)  | [.product_id, .store, .name, .developer] +  [if .categories.main then .categories.main else .categories.all end] + [if .["meta"]["primary_description.EN"] then .["meta"]["primary_description.EN"] else .["meta"]["primary_description.en"] end] +  [.deviceset] + [if .prices.US then .prices.US else .prices end] + [.type] +  [if .["meta"]["all_rating.EN"] then .["meta"]["all_rating.EN"] else .["meta"]["all_rating.en"] end] + [if .["meta"]["all_rating_count.EN"] then .["meta"]["all_rating_count.EN"] else .["meta"]["all_rating_count.en"] end] | @json' > SimApp.json



#pv appbase.gz | zcat | ./remove_sizes.sh | ./jquery.sh | python appbase_main.py --date 2019-03-21 --database appbase.db
#pv 2019-03-21-full | ./remove_sizes.sh | ./jquery.sh | python appbase_main.py --date 2019-03-21 --database appbase.db


#//SQL
#select date, categories, cat_name, sum(counts) from appbase_stats where report == 3 and active == 1 and deviceset in (1, 2, 3, 9, 10, 11) group by date, cat_name, categories;
#select date, store, cat_name, sum(counts) from appbase_stats where report == 3 and active == 1 and deviceset in (1, 2, 3, 9, 10, 11) group by date, store, cat_name limit 50;


----------------------------------------------------------------------------------------------------------

################   Git SSH Key create and test  ################
# server to server
https://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/

1. generate rsa private and pub id, and save it to .ssh file
2. if there is already rsa keys, rename the one you create
3. copy the pub id to the other server .ssh/authorized_keys
4. check by 'ssh datascience@falkor' as an example

arabica.lga.internal.appfigur.es


# github
https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh

1. check for exists ssh key / create a new one ==> id_rsa, id_rsa.pub  # when created, save the password you set 
2. add the ssh public key on github
3. setup agent id ensure its running 'eval $(ssh-agent -s)'
4. add ssh private key 'ssh-add ~/.ssh/id_rsa'
5. test connection 'ssh -T git@github.com'


----------------------------------------------------------------------------------------------------------

################   Shell File Create & Git  ################
# create ssh key and added on github
# follow https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection

# testing ssh connection
ssh -T git@github.com

# initialize a directory for git
git init

# set up the remote repository link with git
git remote add origin/origin3/origin_george http://.......

# get config set up
git config --global user.email "george@appfigures.com"
git config --global user.name "george"


# test_suite reposity with token
https://f8bba28cd809b5fc63939e99d4b3356aef39ffb9:x-oauth-basic@github.com/appfigures/Test_Suite.git

# list out all git remotes ever created
git remote -v


################## process of pulling and pushing ##################
# pull = fetch + merge; we could always fetch to see if there is any change and merge after
git fetch origin master
git merge origin master
git pull origin master

# add all changes/files on git before commit
# use {.} only when add all changes, otherwise give file name while adding
git add -u # pudate files that already exist, use this normally instead of git add .
git add {file_name}
git add .

# commit the changes and give comment
git commit -m 'comment on the commit'

# push the commits to master
git push origin master

# check git status (tracked / untracked file)
git status 

# retrieve to the version after the last push 
git checkout

# Alex used
git fetch
git merge origin/master
git merge origin HEAD  
git push origin HEAD

# After file change in falkor, check difference with file on git
git diff all_countries_afp.R

# create working directory under root, but since it is under root, we cannot save files in there
sudo makdir sales-estimates

# change the current user instead of root, so we can save file
sudo chown $user

# change user/group access to a folder
chown -R USER:GROUP DIRECTORY

# clone the repository online
git clone https://github.com/libgit2/libgit2 (ssh key)

----------------------------------------------------------------------------------------------------------

################ linux virtual machine ##################

# install virtual envirment package
pip install virtualenv

# create virtual environment folder for code to run
virtualenv test1

# activate the virtual environment and now we are in the virtualenv
source test1/bin/activate

# check if everything is under virtualenv; check version we installed pandas
which python
pip install pandas....
ls /home/george/test1/lib/python2.7/site-packages/ | grep pandas

# deactivate virtualenv and return to the global environment
deactivate

----------------------------------------------------------------------------------------------------------

# create a tunnel to connect artax / arabica to web brower using jupyter notebook
# Source port: 8889 //// Destination localhost:8889
# Source port: 8888 //// Destination localhost:8888

# two ways of calling jupyter notebook; 2nd is when first fail with "jupyter command not found"
jupyter notebook
~/.local/bin/jupyter-notebook
# for RStudio on arabica
http://arabica.lga.internal.appfigur.es:8787/
----------------------------------------------------------------------------------------------------------


################ linux learn example ##################

# texted htop so you can grep
ps aux 

# disk usage report
df -h

# simple command example data manipulation
zcat, | head, awk, cut
grep, jq, replace, echo
sudo, su, nano


# zcat the .gz file and use cut to separate the line by tab delimiter, return field 1,2,9,10 (columns), and save it to a tsv file
zcat reviews_pre.tsv.gz | cut -f 1,2,9,10 -d$’/t’ > reviews.tsv

# run all_rank_fafp.R to get data
Rscript all_ranks_afp.R --start_date 2018-02-01 --end_date 2018-07-01 --store apple --subcategory free --file apple_finance.csv --country PE --categories 6014,6015 --lead 6 

# check status / list of docker running
sudo docker ps


----------------------------------------------------------------------------------------------------------

Estimate production procedure

Part A)
- Models ready .RDS file and save on falkor -- /opt/sales-estimates/misc/
- Modify the settings file, rename the new file -- /opt/sales-estimates/misc/
- Create backups (1. Remove ‘estimates_back files’ 2. cp-R estimates estimate_backup’) -- 
- Back date (modify the sales_estimate_backfill.sh file; history | grep backfill), in testing, comment out the second half of the sales_estimate_backfill.sh file
  eg. ./sales_estimate_backfill.sh -s 2019-09-15 -e 2019-10-01 -r free -t android -c US -p a
Part B) 
- add country to merge file -- /opt/sales-estimates/
- push to github & pull on arabica
- backfill: only write store / subcategory
eg. ./sales_estimate_backfill.sh -s 2019-09-15 -e 2019-10-01 -r free -t android -c US -p b
Part C)
- Add to Airflow (modify DAG file) -- /home/datascience/airflow/dags/estimates_airflow.py
- push to github and pull on arabica

----------------------------------------------------------------------------------------------------------

############################### test on falkor ############################
# lm / rq
Rscript test_suite/data_test1.R --start_date 2018-10-01 --end_date 2019-02-01 --store android --subcategory free --lead 20 --country GB --serial_id 53,56,57,59 --online_id 53 --model android_free_GB_base.RDS@android_free_GB_base2.RDS --model_online "53@lm@L_SAD_Ed_P ~ -1 + poly(L_vol_rank_6,2) + as.factor(month) + as.factor(year) + as.factor(weekend) + holidays2" 

# gam / glm
Rscript test_suite/data_test1.R --start_date 2018-10-01 --end_date 2019-02-01 --store android --subcategory free --lead 20 --country GB --serial_id 53,56,57,59 --online_id 53 --model android_free_GB_base.RDS@android_free_GB_base2.RDS --model_online "53@glm@L_SAD_Ed_P ~ -1 + poly(L_vol_rank_6,2) + as.factor(month) + as.factor(year) + as.factor(weekend) + holidays2@family@poisson@link@identity"

# data_test2
Rscript test_suite/data_test2.R --start_date 2018-01-01 --end_date 2018-04-01 --store android --subcategory free --lead 20 --country GB --online_id 53

# saveRDS
saveRDS(mod, file = '/opt/sales-estimates/misc/apple_free_GB_top.RDS', version = 2)
# if save rds file permission denied
sudo chown -R datascience:datascience models/


53@glm@L_SAD_Ed_P ~ -1 + poly(L_vol_rank_6,2) + as.factor(month) + as.factor(year) + as.factor(weekend) + holidays2@family@poisson@link@identity@56@lm@L_SAD_Ed_P ~ -1 + poly(L_vol_rank_6,2) + as.factor(month) + as.factor(year) + as.factor(weekend) + holidays2


 L_SAD_Ed_P ~ -1 + poly(L_vol_rank_6,2) + as.factor(day) + as.factor(month) + as.factor(holiday)


# josh made api call for data request (date, country, product_id, aggregate downloads)
http://atalanta:8000/plot?ids=6164168,6315111&start=2019-01-01&end=2019-06-01

# important links to appfigures api
https://api.appfigures.com/v2/data/categories/?client_key=sunkist

# pull data
# android
Rscript all_ranks_afp.R --start_date 2018-01-01 --end_date 2020-03-20 --store android --subcategory free --lead 20 --file android_downloads_jp_aug.csv --country JP --categories 100,42,43,44,45,47,48,50,51,52,53,54,55,56,57,58,59,61,62,63,64,65,66,67,68,69,70,71,72,73,74,101,102,103,104,105,106,107,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130 --augment
# apple
Rscript all_ranks_afp.R --start_date 2018-01-01 --end_date 2020-03-20 --store apple --subcategory free --lead 6 --file apple_downloads_us_aug.csv --country US --categories 6000...... --augment


# test suite/data_test1
# for apple rq
Rscript test_suite/data_test1.R --start_date 2018-10-01 --end_date 2019-02-01 --store apple --subcategory free --lead 20 --country DE --serial_id 6003,6008,6013,6014,25204 --online_id 25204 --model apple_free_DE_base.RDS --model_online "25204@rq@L_SAD_Ed_P ~ -1 + ns(L_vol_rank_6, df=10) + as.factor(month) + as.factor(day) + as.factor(year) + holidays2 + bs(IDate, df=10)"
# for apple gam / glm
Rscript test_suite/data_test1.R --start_date 2018-10-01 --end_date 2019-02-01 --store apple --subcategory free --lead 20 --country DE --serial_id 6003,6008,6013,6014,25204 --online_id 25204 --model apple_free_DE_base.RDS --model_online "25204@gam@L_SAD_Ed_P ~ -1 + ns(L_vol_rank_6, df=10) + as.factor(month) + as.factor(day) + as.factor(year) + holidays2@family@quasipoisson@link@identity"

# arabica
Rscript test_suite/data_test2.R --start_date 2018-01-01 --end_date 2019-11-01 --store apple --subcategory free --lead 6 --country TH --online_id 6009,6010,6011 --file apple_th_downloads.csv
----------------------------------------------------------------------------------------------------------

arabica change user

sudo chown -R george:datascience folder_name  
sudo chmod g+rwx folder_name

----------------------------------------------------------------------------------------------------------

# fastText model calling
./fastText-0.9.1/fasttext supervised -input train_fasttext.csv -output topics -loss one-vs-all -lr 0.5 -epoch 50 -dim 100 -minCount 1 -wordNgrams 2 && 
./fastText-0.9.1/fasttext test topics.bin test_update_fasttext.csv -1 0.5

# tranform data to fasttext format
python fasttext_format.py --field review_clean --exclude train.csv


----------------------------------------------------------------------------------------------------------
docker: 

1. Dockerfile is step-by-step set up an image and will run/create container instances, usually includes environment and app process code
2. While 'docker build -tag [image_name]', it finds the Dockerfile to create an image for the container
3. While 'docker run -- bb[container process name] bullitboard1.0[image_name]', it will instantiate the container and run from the [Entry_point]

# list all the containers with image name
docker ps -all

# list all the images downloaded
docker images

# build a container with image name tag
docker build --tag hello-world[Image_NAME]

# run the image container 
docker run --name bb[process_name] hello-world[Image_NAME]

# enter the container built by image
docker run -it review_topics:latest[IMAGE_NAME] bash
docker run -it --env-file deploy.env --entrypoint=/bin/bash -t review_topics:latest


# create a docker group and add group member
groups # check current group member. it may return error / no group
sudo groupadd docker # groupadd: group 'docker' already exists
sudo usermod -aG docker george
sudo usermod -aG docker josh
.
.
.
docker ps -a # Got permission denied while trying to connect to the Docker daemon socket at .....
newgrp docker # refresh / activate docker group



# remove the jupyter checkpoint folder automatically generated when calling a notebook
rm -rf `find -type d -name .ipynb_checkpoints`



bash ranks.sh -s 2020-04-01-22 -e 2020-04-02-01
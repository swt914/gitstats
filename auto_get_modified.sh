topdir=`pwd`
while read project
do

cd $project
mkdir $topdir/tmp/$project -p

result_dir=$topdir/tmp/$project
result_file=$result_dir/${project}_gitstat.txt

firstcommit=`git log --format="%cd %cn" --date=short| tail -n 1`
lastcommit=`git log --format="%cd %cn" --date=short| head -n 1`
totalusername=`git log --pretty='%aN' | sort | uniq -c | sort -k1 -n -r |awk '{print $2}' | tr '\n' ' '`



echo "Commiter list: $totalusername" > $result_file

echo "Project: First Commits: $firstcommit Last Commit: $lastcommit" >> $result_file


echo "Author, Date, Commits, AddLines, DeleteLines" >> $result_file
for u in $totalusername;
do

    uniq_date=`git log --author="$u"  --pretty=format:"%cd" --date=short | sort -u | tr '\n' ' '`
    #echo "$u [$uniq_date]"
    #total_modified_line=`git log --no-merges --author="$u" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' - `
    total_modified_line=`git log --no-merges --author="$u" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s, %s\n", add, subs}' - `
    #echo "$u,  total modified: $total_modified_line:" >>$result_file
    #echo "$u,  total modified: $total_modified_line:" >>$result_file
    
    git log --author="$u"  --pretty=format:"%cd %h" --date=short > $result_dir/${u}_date_commits
    for day in $uniq_date
    do
      #one_day_commit_nums=`grep "2018-11-19" allcommit |wc -l`
      one_day_commit_nums=`grep "$day" $result_dir/${u}_date_commits |wc -l`
      one_day_commit_list=`grep "$day" $result_dir/${u}_date_commits |awk '{print $2}' | tr '\n' ' '`
      #modified_lines=`git log --no-merges --author="$u" $one_day_commit_list -n $one_day_commit_nums --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2} END { printf "added lines: %s, removed lines: %s, total lines: %s\n",add, subs,loc}' -`
      #modified_lines=`git log --no-merges --author="$u" $one_day_commit_list -n $one_day_commit_nums --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2} END { printf "added lines: %s, removed lines: %s\n",add, subs}' -`
      modified_lines=`git log --no-merges --author="$u" $one_day_commit_list -n $one_day_commit_nums --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2} END { printf "%s, %s\n",add, subs}' -`
      #echo "$u,$day, $one_day_commit_nums commits, ( $modified_lines )" >> $result_file
      echo "$u,$day, $one_day_commit_nums, $modified_lines" >> $result_file

    done
 
    #git log --author=chenzheng 3b1e7d1e4d3a 67aadeb070849a -n 2 --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
    


done

cd -

done < list

#git log --author=chenzheng  --pretty=format:"%cd" --date=short | sort -u

####git log --author=chenzheng  --pretty=format:"%cd" --date=short | sort -u | tr '\n' ' '

###git log --author="username" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -


#git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done

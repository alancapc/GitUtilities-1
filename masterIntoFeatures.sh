# Update all feature branches by merging master into them (remote tracking)
pullResults=$(git pull 2>&1)
if [[ $pullResults = *"but no such ref was fetched"* ]]; then
  echo "PULL UNSUCCESSFULL"
else
  branches=$( git ls-remote | grep "refs/heads/feature/" )
  echo "started"
  for branch in $branches; do
    if [[ $branch = *"feature"* ]]; then
      thisBranch=${branch##*refs/heads/}
      echo "master into" $thisBranch
      checkoutResults=$(git checkout $thisBranch)
      if [[ $checkoutResults = *"you need to resolve your current index first"* ]]; then
        echo "ABORTING $branch MERGE - you need to resolve your current index first - checkout to an existing branch"
        break
      else
        git fetch --all
        mergeResults=$(git merge --no-ff remotes/origin/master)
        if [[ $mergeResults = *"CONFLICT"* ]]; then
          git merge --abort
          echo "ABORTING $branch MERGE"
        else
          git pull
          git push
        fi
      fi
    fi
  done
fi  
echo "finished"

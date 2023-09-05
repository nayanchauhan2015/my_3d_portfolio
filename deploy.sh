#!/usr/bin/env sh

# abort on errors
set -e

# delete the existing build (worktree must be bare)
rm -rf dist

# create an output directory checked out to the gh-pages branch
git worktree add -B gh-pages dist origin/gh-pages

# build the static app
npm run build

# navigate into the build output directory
cd dist

# bypass Jekyll processing
echo > .nojekyll

# ensure git actions are being performed on the gh-pages worktree
current_branch=$(git symbolic-ref --short -q HEAD)
if [ "$current_branch" != "gh-pages" ]; then
  echo "Expected build folder to be on gh-pages branch."
  exit 1
fi

# Provide a helpful timestamp to commits 
git add -A
git commit -m "GitHub Pages deploy script
[$(date '+%F@%T (%Z)')]"
git push

# uncomment: when deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git checkout -B main
git add -A
git commit -m 'deploy'
# if you are deploying to https://<USERNAME>.github.io
# git push -f git@github.com: <USERNAME>/<USERNAME>.github.io.git main
# if you are deploying to https://<USERNAME>.github.io/<REPO>
# git push -f git@github.com: nayanchauhan2015/my_3d_portfolio.git main:gh-pages

cd -
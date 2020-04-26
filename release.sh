if [ -z "GITHUB_TOKEN" ]
then
      echo "export GITHUB_TOKEN=<>"
      exit 1
fi

if [ $# -eq 0 ]; then
    echo "Pass release version. e.g. v0.1.0"
    exit 1
fi

VERSION=$1
echo "Releasing version $VERSION"
goreleaser --snapshot --rm-dist
git tag -a $VERSION -m "$VERSION"
git push origin $VERSION
goreleaser release --rm-dist

for dir in */
do
    echo "Entering "$dir"..."
    cd $dir
    echo "Removing earlier versions of differences..."
    rm -rf diff*
    for file in *_tree
    do
        echo "Comparing "$file" with reference tree..."
        ./treecompare --notext *.tree $file >> differences
    done
    echo "Creating table..."
    ./difftab differences > differences.table
    echo "Removing differences file..."
    rm -rf differences
    echo "Leaving directory "$dir"..."
    cd ..
done
